"""Implements core functionality."""

from . cimport moab

cdef class Core(object):

    cdef moab.Core * inst

    def __cinit__(self):
        self.inst = new moab.Core()

    def __del__(self):
        del self.inst

    def impl_version(self):
        return self.inst.impl_version()

