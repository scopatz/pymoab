from pymoab import core
from pymoab import types
from subprocess import call
import numpy as np
import os

def test_write_mesh():

    mb = core.Core()

    mb.create_vertices(np.ones(3))

    mb.write_file("outfile.h5m")

    assert os.path.isfile("outfile.h5m")


def test_tags():

    mb = core.Core()

    coord = np.array((1,1,1),dtype='float64')

    vert = mb.create_vertices(coord)

    vert_copy = np.array((vert[0],),dtype='uint64')

    test_tag = mb.tag_get_handle("Test",1,types.MB_TYPE_INTEGER)

    test_val = 4
    
    test_tag_data = np.array((test_val),dtype='int')
    
    mb.tag_set_data(test_tag, vert_copy, test_tag_data)

    data = mb.tag_get_data(test_tag, vert_copy)

    assert len(data) == 1
    
    assert data[0] == test_val 

    test_tag = mb.tag_get_handle("Test1",1,types.MB_TYPE_DOUBLE)

    test_val = 4.4

    test_tag_data = np.array((test_val),dtype='float64')

    mb.tag_set_data(test_tag, vert_copy, test_tag_data)

    data = mb.tag_get_data(test_tag, vert_copy)

    assert len(data) == 1

    assert data[0] == test_val

    test_tag = mb.tag_get_handle("Test2",4,types.MB_TYPE_OPAQUE)

    test_val = 'four'

    test_tag_data = np.array((list(test_val)),dtype='S1')

    mb.tag_set_data(test_tag, vert_copy, test_tag_data)

    data = mb.tag_get_data(test_tag, vert_copy)

    assert len(data) == len(test_val)
    
    assert "".join(data) == test_val

    

    
