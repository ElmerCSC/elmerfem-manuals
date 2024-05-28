from subprocess import run

import numpy as np

import gmsh

# path to elmer grid
elmergrid = r"ElmerGrid"

def create_geo(lc=1e-2, gui=False):
    """
    Create simple cantilever beam with beam elements. The geometry is created
    with gmsh and converted to the elmer format via elmergrid.

    Parameters
    ----------
    lc : float, optional
        characteristic mesh length scale.
    gui : bool, optional
        starts gmsh GUI before finishing the process.

    Returns
    -------
    None.

    """
    # initialize gmsh
    gmsh.initialize()
    # create gmsh model
    gmsh.model()
    # create points between which span our beam
    i = 0
    for x,y in zip([0.,1.],[0.,0.]):
        i = i + 1
        #
        gmsh.model.geo.addPoint(x, 
                                y, 
                                0., # gmsh always needs a third coordinate, 
                                lc, # mesh length scale
                                i) # point tag. starts from 1
    # create line to connect nodes
    gmsh.model.geo.addLine(1, 2, 1)
    # synchronize model. Usually done before meshing or physical group creation
    gmsh.model.geo.synchronize()
    # create physical group for the beam
    gmsh.model.addPhysicalGroup(1, [1], 
                                name = "beam")
    # create physical group for the point anchored to the wall
    gmsh.model.addPhysicalGroup(0, [1], 
                                name = "anchor")
    # generate mesh
    gmsh.model.mesh.generate(1)
    # count number of line elements
    for phys in gmsh.model.getEntities():
        # if dimension of physical group is 1, we have a line element
        if phys[0] == 1: 
            # get number of elements
            eltyps, eltags, ndtags = gmsh.model.mesh.getElements(phys[0], 
                                                                 phys[1]) 
            nelements = eltags[0].shape[0]
    #save number of elements to disk
    np.savetxt("cantilever-{0}_nelem.csv".format(str(lc)), np.array([nelements]))
    # save mesh to disk 
    filename = "cantilever-{0}.msh".format(str(lc))
    gmsh.write(filename)
    # start the graphical user interface of gmsh. Useful for checking mistakes
    if gui:
        gmsh.fltk.run()
    # this clears out the gmsh model 
    gmsh.clear()
    # close gmsh
    gmsh.finalize() 
    # call elmer grid to convert the gmsh file into a useable format for Elmer
    run([elmergrid, # path to Elmer grid
         "14", # input file format: here the gmsh format .msh
         "2", # output format: here .mesh. You can directly use this to start an elmer calculation
         filename], # name output file, which is a big lie as here it is a directory
        shell=True, 
        check=True) 
    return

if __name__ == '__main__':
    
    # this will create a geometry with one beam element
    lc = 1e0
    #
    create_geo(lc, True)
        
    
