"""Implements core functionality."""
from cython.operator cimport dereference as deref

cimport numpy as np
import numpy as np

from . cimport moab
from .range cimport Range

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
        cdef moab.EntityHandle ms_handle
        cdef moab.ErrorCode err = self.inst.create_meshset(options, ms_handle)
        if err > 0:
            raise RuntimeError('This error happened: {0}'.format(err))
        return ms_handle

    def create_vertices(self, np.ndarray[np.float64_t, ndim=1] coordinates):
        cdef Range rng = Range()
        cdef moab.ErrorCode err = self.inst.create_vertices(<double *> coordinates.data, 
                                                            len(coordinates)//3,
                                                            deref(rng.inst))
        if err > 0:
            raise RuntimeError('This error happened: {0}'.format(err))
        return rng

    def create_element(self, int t, np.ndarray[np.uint64_t, ndim=1] connectivity):
        cdef moab.EntityType typ = <moab.EntityType> t
        cdef moab.EntityHandle handle
        cdef int nnodes = len(connectivity)
        cdef moab.ErrorCode err = self.inst.create_element(typ,
            <unsigned long*> connectivity.data, nnodes, handle)
        if err > 0:
            raise RuntimeError('This error happened: {0}'.format(err))
        return handle

