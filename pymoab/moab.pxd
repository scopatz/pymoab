"""Header file for MOAB"""
from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.string cimport string as std_string

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

    ctypedef EntityHandle EntityHandle


cdef extern from "moab/Range.hpp" namespace "moab":

    cdef cppclass Range:
        Range()
        Range (EntityHandle val1, EntityHandle val2)

        size_t size()
        size_t psize()
        bint empty()
        void clear()
        #void print()


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
        ErrorCode create_meshset(const unsigned int options, EntityHandle &ms_handle, int start_id=0)

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
