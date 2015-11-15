#!/usr/bin/env python

from setuptools import setup, find_packages
import os
import numpy as np
from Cython.Build import cythonize

moab_env_var = 'MOAB_PATH'

try:
    moab_root = os.environ[moab_env_var]
except KeyError:
    raise EnvironmentError('MOAB_PATH not found in environment.')

moab_include = moab_root + '/include/'
moab_lib = moab_root + '/lib/'

include_path = [np.get_include(),moab_include]

ext_modules = cythonize('pymoab/*.pyx', language='c++', 
                        include_dirs=include_path)
for ext in ext_modules:
    ext.include_dirs = include_path
    ext.library_dirs = [moab_lib]
    ext.libraries = ["MOAB"]

setup(
    name="pymoab",
    ext_modules=ext_modules,
    packages=find_packages(),
    package_data = {'pymoab': ['*.pxd']}
)
