PyMOAB
======

PyMOAB is a python interface to the Mesh Oriented datABase (`MOAB <http://sigma.mcs.anl.gov/moab-library/>`_).

Installation
------------

PyMOAB has the following dependencies:

1. (`Cython <http://cython.org/>`_)
2. (`numpy <http://www.numpy.org/>`_)
3. (`MOAB <http://sigma.mcs.anl.gov/moab-library/>`_)

   PyMOAB relies on a prior installation of MOAB. The root location of this install should be added to the user environment in the variable `MOAB_PATH` or provided to the installation command as --moab-path=<moab_installation_dir>.

   Along with this installation PyMOAB requires one small modification to the MOAB install. The TagInfo.hpp file found in the source must be copied/linked to the installation's include directory at './moab/TagInfo.hpp'.

After these steps are complete PyMOAB can be installed using the command line:

```python setup.py install --user```

Testing
-------

Coming soon.
