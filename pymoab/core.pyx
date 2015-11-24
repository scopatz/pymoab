"""Implements core functionality."""
from cython.operator cimport dereference as deref

cimport numpy as np
import numpy as np

from . cimport moab
from .tag cimport Tag
from .range cimport Range
from .types import check_error, np_tag_type
from . import types

cdef class Core(object):

    cdef moab.Core * inst

    def __cinit__(self):
        self.inst = new moab.Core()

    def __del__(self):
        del self.inst

    def impl_version(self):
        """MOAB implementation number as a float."""
        return self.inst.impl_version()

    def write_file(self, str fname, exceptions = ()):
        """Writes the MOAB data to a file."""
        cfname = fname.decode()
        cdef const char * file_name = cfname
        cdef moab.ErrorCode err = self.inst.write_file(fname)
        check_error(err, exceptions)

    def create_meshset(self, unsigned int options = 0x02, exceptions = ()):
        cdef moab.EntityHandle ms_handle = 0
        cdef moab.EntitySetProperty es_property = <moab.EntitySetProperty> options 
        cdef moab.ErrorCode err = self.inst.create_meshset(es_property, ms_handle)
        check_error(err, exceptions)
        return ms_handle

    def add_entities(self, moab.EntityHandle ms_handle, entities, exceptions = ()):
        cdef moab.ErrorCode err
        cdef Range r
        cdef np.ndarray[np.uint64_t, ndim=1] arr         
        if isinstance(entities, Range):
           r = entities
           err = self.inst.add_entities(ms_handle, deref(r.inst))
        else:
           arr = entities
           err = self.inst.add_entities(ms_handle, <unsigned long*> arr.data, len(entities))
        check_error(err, exceptions)

    def create_vertices(self, np.ndarray[np.float64_t, ndim=1] coordinates, exceptions = ()):
        cdef Range rng = Range()
        cdef moab.ErrorCode err = self.inst.create_vertices(<double *> coordinates.data, 
                                                            len(coordinates)//3,
                                                            deref(rng.inst))
        check_error(err, exceptions)
        return rng

    def create_element(self, int t, np.ndarray[np.uint64_t, ndim=1] connectivity, exceptions = ()):
        cdef moab.EntityType typ = <moab.EntityType> t
        cdef moab.EntityHandle handle = 0
        cdef int nnodes = len(connectivity)
        cdef moab.ErrorCode err = self.inst.create_element(typ,
            <unsigned long*> connectivity.data, nnodes, handle)
        check_error(err, exceptions)
        return handle

    def create_elements(self, int t, np.ndarray[np.uint64_t, ndim=2] connectivity, exceptions = ()):
        cdef int i
        cdef moab.ErrorCode err
        cdef moab.EntityType typ = <moab.EntityType> t
        #cdef moab.EntityHandle handle = 0
        cdef int nelems = connectivity.shape[0]
        cdef int nnodes = connectivity.shape[1]
        cdef np.ndarray[np.uint64_t, ndim=1] connectivity_i
        cdef np.ndarray[np.uint64_t, ndim=1] handles = np.empty(nelems, 'uint64')
        for i in range(nelems):
            connectivity_i = connectivity[i]
            err = self.inst.create_element(typ, <unsigned long*> connectivity_i.data,
                                           nnodes, deref((<unsigned long*> handles.data)+i))
            check_error(err, exceptions)
        return handles

    def tag_get_handle(self, const char* name, int size, moab.DataType type, exceptions = ()):
        cdef Tag tag = Tag()
        cdef moab.ErrorCode err = self.inst.tag_get_handle(name, size, type, tag.inst, types.MB_TAG_DENSE|types.MB_TAG_CREAT)
        check_error(err, exceptions)
        return tag
    
    def tag_set_data(self, Tag tag, np.ndarray[np.uint64_t, ndim=1] entity_handles, np.ndarray data, exceptions = ()):
        cdef moab.ErrorCode err
        cdef Range r
        cdef np.ndarray[np.uint64_t, ndim=1] arr
        if isinstance(entity_handles,Range):
            r = entity_handles
            err = self.inst.tag_set_data(tag.inst, deref(r.inst), <const void*> data.data)
        else:
            arr = entity_handles
            err = self.inst.tag_set_data(tag.inst, <unsigned long*> arr.data, len(entity_handles), <const void*> data.data)
        check_error(err, exceptions)

    def tag_get_data(self, Tag tag, np.ndarray[np.uint64_t, ndim=1] entity_handles, exceptions = []):
        cdef moab.ErrorCode err
        cdef Range r
        cdef np.ndarray[np.uint64_t, ndim=1] arr
        cdef moab.DataType type
        err = self.inst.tag_get_data_type(tag.inst, type);
        check_error(err, exceptions)
        cdef np.ndarray data = np.empty((len(entity_handles),),dtype=np_tag_type(type))
        if isinstance(entity_handles,Range):
            r = entity_handles
            err = self.inst.tag_get_data(tag.inst, deref(r.inst), <void*> data.data)
        else:
            arr = entity_handles
            err = self.inst.tag_get_data(tag.inst, <unsigned long*> arr.data, len(entity_handles), <void*> data.data)
        check_error(err,exceptions)
        return data