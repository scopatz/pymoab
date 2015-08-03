"""Implements range functionality."""

from . cimport moab

cdef class Range:

    cdef moab.Range * inst

