"""Header file for MOAB"""
from libcpp.string cimport string as std_string

cdef extern from "moab/Core.hpp" namespace "moab":

    cdef cppclass Core:
        # Constructors
        Core()

        # member functions
        float impl_version()
        float impl_version(std_string *version_string)
