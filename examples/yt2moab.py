

import yt, argparse, sys
import numpy as np
from pymoab import core,types
from pymoab.tag import Tag

def parse_args(): 

    parser = argparse.ArgumentParser() 

    #parser.add_argument('filename', type=str, nargs='+', help="Filename of yt dataset to convert")
    parser.add_argument("filename")
    args = parser.parse_args()


    return args


def yt2moab_uniform_gridgen(mb,ds):
    """Generates a uniform grid in a moab instance (mb) meshset which is representative of the yt grid dataset (ds)"""

    #create a meshset for this grid
    msh = mb.create_meshset(1)

    domain = ds.domain_dimensions

    #uniform grid parameters    
    #number of elements in each axis
    nex = domain[0] 
    ney = domain[1]
    nez = domain[2]

    #number of vertices in each axis
    nvx = domain[0]+1
    nvy = domain[1]+1
    nvz = domain[2]+1
    
    num_elems = nex*ney*nez
    
    num_verts = nvx*nvy*nvz

    le = ds.domain_left_edge
    re = ds.domain_right_edge 
    
    dx = (re[0]-le[0])/domain[0]
    dy = (re[1]-le[1])/domain[1]
    dz = (re[2]-le[2])/domain[2]

    #indices
    i=0
    j=0
    k=0

    coords = np.empty(3*num_verts,dtype='float64')

    while k < (nvz):
        j=0
        while j < (nvy):
            i=0
            while i < (nvx):

                ref_index = 3*(i+j*nvx+k*nvx*nvy)
                coords[ref_index] = le[0] + i*dx
                coords[ref_index+1] = le[1] + j*dy
                coords[ref_index+2] = le[2] + k*dz
                print (i,j,k), (coords[ref_index],coords[ref_index+1],coords[ref_index+2])
                i+=1
            j+=1
        k+=1
        
   
    #create vertices
    vert_handles = mb.create_vertices(coords)

    print "Number of verts added to MOAB instance: ", vert_handles.size()

    #reset indices for connectivity loop
    i=0
    j=0
    k=0


    offsets= np.array([0,1,nvx+1,nvx, nvx*nvy, nvx*nvy+1, nvx*nvy+nvx+1, nvx*nvy+nvx])
    
    moab_hex_type = types.MBHEX

    conn_arr = np.empty((num_elems,8),dtype='uint64')

    hex_handles = np.empty(num_elems,dtype='uint64')

    while i < (nex):
        j=0
        while j < (ney):
            k=0
            while k < (nez):

                ref_index = i+j*nvx+k*nvx*nvy

                connectivity = ref_index+offsets

                conn_arr[i+j*nex+k*nex*ney] = [vert_handles[connectivity[elem]] for elem in range(8)]

                # for elem in range(len(connectivity)):
                #     conn_arr[elem] = vert_handles[connectivity[elem]]
                    
                # hex_handles[i+j*nex+k*nex*ney] = mb.create_element(moab_hex_type, conn_arr)
        
                k+=1
            j+=1
        i+=1



    #create hex elements
    hex_handles = mb.create_elements( types.MBHEX, conn_arr)

    field = ds.field_list[-1]
    
    dd = ds.all_data()

    data_arr = dd['Density']

    #create field tag
    density_tag = mb.tag_get_handle("density", 1, 2)
    
    #randomly tag :) 
    mb.tag_set_data(density_tag, hex_handles, data_arr)


    #add created vertices and elements to meshset
    mb.add_entities(msh,vert_handles)
    mb.add_entities(msh,hex_handles)
    
    #return the grid meshset
    return msh

def main():

    args = parse_args() 
    filename = args.filename
    print filename

    print "Loading yt dataset " + filename.split("/")[-1] + "..."
    ds = yt.load(filename)

    #establish a moab instance for use
    mb = core.Core()
    
    yt2moab_uniform_gridgen(mb,ds)

    #write file
    mb.write_file("test.h5m")
    

if __name__ == "__main__": 
    main()
