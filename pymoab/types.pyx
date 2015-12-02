"""Python wrappers for MOAB Types."""

from . cimport moab
cimport numpy as np
import numpy as np

# Error codes
MB_SUCCESS = moab.MB_SUCCESS
MB_INDEX_OUT_OF_RANGE = moab.MB_INDEX_OUT_OF_RANGE   
MB_TYPE_OUT_OF_RANGE = moab.MB_TYPE_OUT_OF_RANGE    
MB_MEMORY_ALLOCATION_FAILED = moab.MB_MEMORY_ALLOCATION_FAILED     
MB_ENTITY_NOT_FOUND = moab.MB_ENTITY_NOT_FOUND     
MB_MULTIPLE_ENTITIES_FOUND = moab.MB_MULTIPLE_ENTITIES_FOUND  
MB_TAG_NOT_FOUND = moab.MB_TAG_NOT_FOUND    
MB_FILE_DOES_NOT_EXIST = moab.MB_FILE_DOES_NOT_EXIST  
MB_FILE_WRITE_ERROR = moab.MB_FILE_WRITE_ERROR     
MB_NOT_IMPLEMENTED = moab.MB_NOT_IMPLEMENTED  
MB_ALREADY_ALLOCATED = moab.MB_ALREADY_ALLOCATED    
MB_VARIABLE_DATA_LENGTH = moab.MB_VARIABLE_DATA_LENGTH     
MB_INVALID_SIZE = moab.MB_INVALID_SIZE     
MB_UNSUPPORTED_OPERATION = moab.MB_UNSUPPORTED_OPERATION    
MB_UNHANDLED_OPTION = moab.MB_UNHANDLED_OPTION     
MB_STRUCTURED_MESH = moab.MB_STRUCTURED_MESH  
MB_FAILURE = moab.MB_FAILURE 


cdef dict _ERROR_MSGS = {
    MB_INDEX_OUT_OF_RANGE: (IndexError, 'MOAB index out of range'),
    MB_TYPE_OUT_OF_RANGE: (TypeError, 'Incorrect MOAB type, out of range'),
    MB_MEMORY_ALLOCATION_FAILED: (MemoryError, 'MOAB memory allocation'),
    MB_ENTITY_NOT_FOUND: (RuntimeError, 'Entity not found'),
    MB_MULTIPLE_ENTITIES_FOUND: (RuntimeError, 'Multiple entities found'),
    MB_TAG_NOT_FOUND: (RuntimeError, 'Tag not found'),
    MB_FILE_DOES_NOT_EXIST: (IOError, 'File not found'),
    MB_FILE_WRITE_ERROR: (IOError, 'File write error'), 
    MB_NOT_IMPLEMENTED: (NotImplementedError, '[MOAB]'),
    MB_ALREADY_ALLOCATED: (MemoryError, 'already allocated'),
    MB_VARIABLE_DATA_LENGTH: (TypeError, 'variable length data'),
    MB_INVALID_SIZE: (ValueError, 'invalid size'),
    MB_UNSUPPORTED_OPERATION: (RuntimeError, 'unsupported operation'),
    MB_UNHANDLED_OPTION: (RuntimeError, 'unhandled option'),
    MB_STRUCTURED_MESH: (RuntimeError, 'structured mesh'),
    MB_FAILURE: (RuntimeError, '[MOAB] failure'),
    }

def check_error(int err, tuple exceptions, **kwargs):
    """Checks error status code and raises error if needed."""
    for exception in exceptions:
        if exception == err:
            return
    if err == moab.MB_SUCCESS:
        return
    errtype, msg = _ERROR_MSGS[err]
    if len(kwargs) > 0:
        msg += ': '
        msg += ', '.join(sorted(['{0}={1!r}'.format(k, v) for k, v in kwargs.items()]))
    raise errtype(msg)

# Data Types
MB_TYPE_OPAQUE  = moab.MB_TYPE_OPAQUE 
MB_TYPE_INTEGER  = moab.MB_TYPE_INTEGER
MB_TYPE_DOUBLE   = moab.MB_TYPE_DOUBLE
MB_TYPE_BIT      = moab.MB_TYPE_BIT   
MB_TYPE_HANDLE   = moab.MB_TYPE_HANDLE
MB_MAX_DATA_TYPE = moab.MB_MAX_DATA_TYPE

_DTYPE_CONV = {
    MB_TYPE_OPAQUE   : 'S',
    MB_TYPE_INTEGER  : 'int32',
    MB_TYPE_DOUBLE   : 'float64',
    MB_TYPE_BIT      : 'S',
    MB_TYPE_HANDLE   : 'uint64',
    MB_MAX_DATA_TYPE : 'uint64'
    }


def np_tag_type(type):
    return _DTYPE_CONV[type];

def verify_type(exp_type,act_type):
    if exp_type == MB_TYPE_OPAQUE:
       assert 'S' == act_type.char
    else:
       exp_type = np.dtype(_DTYPE_CONV[exp_type])
    assert exp_type == act_type
    
# Entity types
MBVERTEX = moab.MBVERTEX
MBEDGE = moab.MBEDGE
MBTRI = moab.MBTRI
MBQUAD = moab.MBQUAD
MBPOLYGON = moab.MBPOLYGON
MBTET = moab.MBTET
MBPYRAMID = moab.MBPYRAMID
MBPRISM = moab.MBPRISM
MBKNIFE = moab.MBKNIFE
MBHEX = moab.MBHEX
MBPOLYHEDRON = moab.MBPOLYHEDRON
MBENTITYSET = moab.MBENTITYSET
MBMAXTYPE = moab.MBMAXTYPE

# Tag Types
MB_TAG_BIT  = moab.MB_TAG_BIT   
MB_TAG_SPARSE = moab.MB_TAG_SPARSE
MB_TAG_DENSE = moab.MB_TAG_DENSE
MB_TAG_MESH = moab.MB_TAG_MESH  
MB_TAG_BYTES = moab.MB_TAG_BYTES 
MB_TAG_VARLEN = moab.MB_TAG_VARLEN
MB_TAG_CREAT = moab.MB_TAG_CREAT 
MB_TAG_EXCL = moab.MB_TAG_EXCL  
MB_TAG_STORE = moab.MB_TAG_STORE 
MB_TAG_ANY = moab.MB_TAG_ANY   
MB_TAG_NOOPQ = moab.MB_TAG_NOOPQ 
MB_TAG_DFTOK = moab.MB_TAG_DFTOK 

