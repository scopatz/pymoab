"""MOAB Tag Class"""

from . cimport moab

cdef class Tag:
    cdef moab.TagInfo * inst