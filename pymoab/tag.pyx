"""MOAB Tag Class"""

from . cimport moab 
import numpy as np
cimport numpy as np
from libc.stdlib cimport malloc,free

cdef class Tag(object): 
    def __cinit__(self):
        self.inst = <moab.TagInfo*> malloc(sizeof(moab.TagInfo))

    def __del__(self):
        free(self.inst)

    def get_data_type(self): 
        return self.inst.get_data_type()