#!/usr/bin/env python

from setuptools import setup, find_packages

import numpy as np
from Cython.Build import cythonize

include_path = [np.get_include(),"/home/shriwise/dagmc_blds/moabs/include/"]

ext_modules = cythonize('pymoab/*.pyx', language='c++', 
                        include_dirs=include_path)
for ext in ext_modules:
    ext.include_dirs = include_path
    ext.library_dirs = ["/home/shriwise/dagmc_blds/moabs/lib/"]
    ext.libraries = ["MOAB"]

setup(
    name="pymoab",
    ext_modules=ext_modules,
    packages=find_packages(),
    package_data = {'pymoab': ['*.pxd']}
)
