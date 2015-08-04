"""MOAB Tag Class"""

from . cimport moab 
import numpy as np
cimport numpy as np
from libc.stdlib cimport malloc,free

cdef class Tag(object): 
    def __cinit__(self):
        self.inst = <moab.TagInfo*> malloc(sizeof(moab.TagInfo))
    # def __cinit__(self, const char* name, int bytes, moab.DataType type, np.ndarray default_value):
    #     cdef moab.SequenceManager seqman = moab.SequenceManager()
    #     cdef moab.Error err = moab.Error()
    #     self.inst = moab.DenseTag.create_tag(&seqman, &err, name, bytes, type, default_value.data)

    def __del__(self):
        free(self.inst)

    def get_data_type(self): 
        return self.inst.get_data_type()