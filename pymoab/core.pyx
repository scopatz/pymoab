"""Implements core functionality."""
from cython.operator cimport dereference as deref

cimport numpy as np
import numpy as np

from . cimport moab
from .tag cimport Tag
from .range cimport Range
from .types import check_error
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

    def write_file(self, str fname):
        """Writes the MOAB data to a file."""
        cfname = fname.decode()
        cdef const char * file_name = cfname
        self.inst.write_file(fname)

    def create_meshset(self, unsigned int options):
        cdef moab.EntityHandle ms_handle = 0
        cdef moab.ErrorCode err = self.inst.create_meshset(options, ms_handle)
        check_error(err)
        return ms_handle

    def add_entities(self, moab.EntityHandle ms_handle, entities):
        cdef moab.ErrorCode err
        cdef Range r
        cdef np.ndarray[np.uint64_t, ndim=1] arr         
        if isinstance(entities, Range):
           r = entities
           err = self.inst.add_entities(ms_handle, deref(r.inst))
        else:
           arr = entities
           err = self.inst.add_entities(ms_handle, <unsigned long*> arr.data, len(entities))
        check_error(err)

    def create_vertices(self, np.ndarray[np.float64_t, ndim=1] coordinates):
        cdef Range rng = Range()
        cdef moab.ErrorCode err = self.inst.create_vertices(<double *> coordinates.data, 
                                                            len(coordinates)//3,
                                                            deref(rng.inst))
        check_error(err)
        return rng

    def create_element(self, int t, np.ndarray[np.uint64_t, ndim=1] connectivity):
        cdef moab.EntityType typ = <moab.EntityType> t
        cdef moab.EntityHandle handle = 0
        cdef int nnodes = len(connectivity)
        cdef moab.ErrorCode err = self.inst.create_element(typ,
            <unsigned long*> connectivity.data, nnodes, handle)
        check_error(err)
        return handle

    def create_elements(self, int t, np.ndarray[np.uint64_t, ndim=2] connectivity):
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
            check_error(err)
        return handles

    def tag_get_handle(self, const char* name, int size, moab.DataType type):
        cdef Tag tag = Tag()
        cdef moab.ErrorCode err = self.inst.tag_get_handle(name, size, type, tag.inst, types.MB_TAG_DENSE|types.MB_TAG_CREAT)
        check_error(err)
        return tag
    
    def tag_set_data(self, Tag tag, np.ndarray[np.uint64_t, ndim=1] entity_handles, np.ndarray data):
        cdef moab.ErrorCode err
        cdef Range r
        cdef np.ndarray[np.uint64_t, ndim=1] arr
        if isinstance(entity_handles,Range):
            r = entity_handles
            err = self.inst.tag_set_data(tag.inst, deref(r.inst), <const void*> data.data)
        else:
            arr = entity_handles
            err = self.inst.tag_set_data(tag.inst, <unsigned long*> arr.data, len(entity_handles), <const void*> data.data)
        check_error(err)
    
