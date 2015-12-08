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

def test_integer_tag():
    
    mb = core.Core()

    vh = vertex_handle(mb)

    test_tag = mb.tag_get_handle("Test",1,types.MB_TYPE_INTEGER)

    test_val = 4
    
    test_tag_data = np.array((test_val,))
    
    mb.tag_set_data(test_tag, vh, test_tag_data)

    data = mb.tag_get_data(test_tag, vh)

    assert len(data) == 1
    
    assert data[0] == test_val

    assert data.dtype == 'int32'

def test_double_tag():
    
    mb = core.Core()

    vh = vertex_handle(mb)

    test_tag = mb.tag_get_handle("Test",1,types.MB_TYPE_DOUBLE)

    test_val = 4.4

    test_tag_data = np.array((test_val))

    mb.tag_set_data(test_tag, vh, test_tag_data)

    data = mb.tag_get_data(test_tag, vh)

    assert len(data) == 1

    assert data[0] == test_val

    assert data.dtype == 'float64'

    test_tag = mb.tag_get_handle("Test1",1,types.MB_TYPE_DOUBLE)

    test_val = 4.4

    test_tag_data = np.array((test_val),dtype='float32')

    try:
        mb.tag_set_data(test_tag, vh, test_tag_data)
    except AssertionError:
        pass
    else:
        print "Shouldn't be here. Test fails."
        raise AssertionError

    test_tag = mb.tag_get_handle("Test2",1,types.MB_TYPE_DOUBLE)

    test_val = 4.4

    test_tag_data = np.array((test_val),dtype='int32')

    try:
        mb.tag_set_data(test_tag, vh, test_tag_data)
    except AssertionError:
        pass
    else:
        print "Shouldn't be here. Test fails."
        raise AssertionError

def test_opaque_tag():

    mb = core.Core()

    vh = vertex_handle(mb)

    tag_length = 6

    test_tag = mb.tag_get_handle("Test",tag_length,types.MB_TYPE_OPAQUE)

    test_val = 'four'

    test_tag_data = np.array((test_val,))

    mb.tag_set_data(test_tag, vh, test_tag_data)

    data = mb.tag_get_data(test_tag, vh)

    assert len(data) == 1

    assert data.nbytes == tag_length

    assert data[0] == test_val

    assert data.dtype == '|S' + str(tag_length)
    
def vertex_handle(core):

    coord = np.array((1,1,1),dtype='float64')

    vert = core.create_vertices(coord)

    vert_copy = np.array((vert[0],),dtype='uint64')

    return vert_copy
