These are the files related to Elmer non-GUI tutorials.

Note that they may be partly out-dated. The sif file
and the mesh files should be backward compatible, but the
best practices may have changed over the years.

Note also that the collection of the files may not be complete. 

Updated January, 2021:

Each folder includes a '.sif' file, an 'ELMERSOLVER_STARTINFO' file, and a geometry input file, at a minimum.  Additional .sif files, script files, subfolder, may be included and are specific to each tutorial.

Assuming the geometry input file is a '.grd' file, which is an ElmerGrid input file, then to run the tutorial using 'example.grd' enter the following in a terminal window (command prompt window):

    ElmerGrid 1 2 example.grd

    ElmerSolver

This will generate the mesh files and run ElmerSolver using the .sif file.  The mesh files and the result files will be located in a sub-folder named 'example'.
