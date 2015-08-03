"""Implements range functionality."""

from . cimport moab

cdef class Range(object):

    cdef moab.Range * inst

    def __cinit__(self, moab.EntityHandle val1=None, moab.EntityHandle val2=None):
        if val1 is None or val2 is None:
            self.inst = new moab.Range()
        else:
            self.inst = new moab.Range(val1, val2)

    def __del__(self):
        del self.inst

    def size(self):
        """The number of values this Ranges represents."""
        return self.inst.size()

    def psize(self):
        """The number of range pairs in the list."""
        return self.inst.psize()

    def empty(self):
        """Is the range empty?"""
        return self.inst.empty()

    def clear(self):
        """clears the contents of the list."""
        self.inst.clear()

