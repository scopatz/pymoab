"""Implements core functionality."""

from . cimport moab

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
        cdef const char * file_name = fnanme.decode()
        self.inst.write_file(fname)

    def create_meshset(self, unsigned int options):
        cdef EntityHandle ms_handle
        cdef ErrorCode err = self.inst.create_meshset(options, ms_handle)
        if err > 1:
            raise RuntimeError('This error happened: {0}'.format(err))
        return ms_handle