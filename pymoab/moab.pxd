"""Header file for MOAB"""
from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.string cimport string as std_string

cdef extern from "moab/Types.hpp" namespace "moab":

    cdef enum DataType:
        MB_TYPE_OPAQUE   = 0
        MB_TYPE_INTEGER  = 1
        MB_TYPE_DOUBLE   = 2
        MB_TYPE_BIT      = 3
        MB_TYPE_HANDLE   = 4
        MB_MAX_DATA_TYPE = 4

cdef extern from "moab/TagInfo.hpp" namespace "moab":

    cdef cppclass TagInfo:
        TagInfo()
        DataType get_data_type()

cdef extern from "moab/Types.hpp" namespace "moab":

    cdef enum ErrorCode:
        MB_SUCCESS  
        MB_INDEX_OUT_OF_RANGE   
        MB_TYPE_OUT_OF_RANGE    
        MB_MEMORY_ALLOCATION_FAILED     
        MB_ENTITY_NOT_FOUND     
        MB_MULTIPLE_ENTITIES_FOUND  
        MB_TAG_NOT_FOUND    
        MB_FILE_DOES_NOT_EXIST  
        MB_FILE_WRITE_ERROR     
        MB_NOT_IMPLEMENTED  
        MB_ALREADY_ALLOCATED    
        MB_VARIABLE_DATA_LENGTH     
        MB_INVALID_SIZE     
        MB_UNSUPPORTED_OPERATION    
        MB_UNHANDLED_OPTION     
        MB_STRUCTURED_MESH  
        MB_FAILURE 

    ctypedef TagInfo* Tag;

# cdef extern from "moab/SequenceManager.hpp" namespace "moab":

#     cdef cppclass SequenceManager:
#         SequenceManager()

# cdef extern from "moab/Error.hpp" namespace "moab":

#     cdef cppclass Error:
#         Error()

# cdef extern from "moab/DenseTag.hpp" namespace "moab": 

#     cdef cppclass DenseTag:
#         DenseTag()
#         DataType get_data_type()
#         @staticmethod
#         DenseTag* create_tag(SequenceManager* seqman, 
#                              Error* error,
#                              const char* name,
#                              int bytes, 
#                              DataType type, 
#                              const void* default_value)

cdef extern from "moab/EntityType.hpp" namespace "moab":

    ctypedef enum EntityType:
        MBVERTEX = 0
        MBEDGE
        MBTRI
        MBQUAD
        MBPOLYGON
        MBTET
        MBPYRAMID
        MBPRISM
        MBKNIFE
        MBHEX
        MBPOLYHEDRON
        MBENTITYSET
        MBMAXTYPE 


cdef extern from "moab/EntityHandle.hpp" namespace "moab":

    ctypedef long EntityID
    ctypedef unsigned long EntityHandle


cdef extern from "moab/Range.hpp" namespace "moab":

    cdef cppclass Range:
        Range()
        Range(EntityHandle val1, EntityHandle val2)

        size_t size()
        size_t psize()
        bint empty()
        void clear()
        void print_ "print" ()

        EntityHandle operator[](EntityID index)


cdef extern from "moab/Core.hpp" namespace "moab":

    cdef cppclass Core:
        # Constructors
        Core()

        # member functions
        float impl_version()
        float impl_version(std_string *version_string)

        ErrorCode write_file(const char *file_name)
        ErrorCode write_file(const char *file_name, const char *file_type)
        ErrorCode write_file(const char *file_name, const char *file_type, 
                             const char *options)
        ErrorCode write_file(const char *file_name, const char *file_type, 
                             const char *options, const EntityHandle *output_sets)
        ErrorCode write_file(const char *file_name, const char *file_type, 
                             const char *options, const EntityHandle *output_sets, 
                             int num_output_sets)
        #ErrorCode write_file(const char *file_name, const char *file_type, 
        #                     const char *options, const EntityHandle *output_sets, 
        #                     int num_output_sets, const Tag *tag_list) 
        #ErrorCode write_file(const char *file_name, const char *file_type, 
        #                     const char *options, const EntityHandle *output_sets, 
        #                     int num_output_sets, const Tag *tag_list, 
        #                     int num_tags)

        ErrorCode create_meshset(const unsigned int options, EntityHandle &ms_handle)
        ErrorCode create_meshset(const unsigned int options, EntityHandle &ms_handle, int start_id)

        ErrorCode add_entities(EntityHandle meshset, const EntityHandle *entities, int num_entities)
        ErrorCode add_entities(EntityHandle meshset, const Range &entities)
 
        ErrorCode create_vertices(const double *coordinates, const int nverts,
                                  Range &entity_handles)   

        ErrorCode create_element(const EntityType type, const EntityHandle *connectivity,
                                 const int num_nodes, EntityHandle &element_handle)

        ErrorCode get_connectivity(const EntityHandle *entity_handles,
                                   const int num_handles,
                                   vector[EntityHandle] & connectivity)   
        ErrorCode get_connectivity(const EntityHandle *entity_handles,
                                   const int num_handles,
                                   vector[EntityHandle] & connectivity,
                                   bool corners_only)   
        ErrorCode get_connectivity(const EntityHandle *entity_handles,
                                   const int num_handles,
                                   vector[EntityHandle] & connectivity,
                                   bool corners_only,
                                   vector[int] * offsets)   
        ErrorCode tag_get_handle(const char* name, 
                                 int size, DataType type, 
                                 Tag & tag_handle, 
                                 unsigned flags = 0, 
                                 const void * default_value = 0, 
                                 bool * created = 0)
        ErrorCode tag_set_data(Tag& tag,
                               const EntityHandle* entity_handles,
                               int num_entities, 
                               const void * data)
        ErrorCode tag_set_data(Tag& tag, 
                               Range& entity_handles, 
                               const void * data)