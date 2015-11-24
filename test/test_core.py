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

    test_tag = mb.tag_get_handle("Test",1,2)

    

    
