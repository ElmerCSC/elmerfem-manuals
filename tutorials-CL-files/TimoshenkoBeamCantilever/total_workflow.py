from subprocess import run

from numpy import array

from create_geometry import create_geo
from create_sif import write_new_sif
from plot_results import plot_displacements

# path to elmer solver
elmersolver = "ElmerSolver"

if __name__ == '__main__':
    
    # different characteristic mesh scales
    lcs = array([1e0,1e-1,1e-2,1e-3])
    # iterate over different mesh sizes
    for lc in lcs:
        
        # create the geometry and mesh it with gmsh. Convert it to elmer 
        # compatible file format
        create_geo(lc)
        # write a sif file that is adapted to the specific mesh scale
        write_new_sif(file = "constant_pressure_load.sif", 
                      search_strings = ['  Mesh DB "." "cantilever"',
                                 '  Post File = "cantilever.vtu"',
                                 '  Filename = cantilever.dat'], 
                      replacements = ['  Mesh DB "." "cantilever-{0}"\n',
                                 '  Post File = "cantilever-{0}.vtu"\n',
                                 '  Filename = cantilever-{0}.dat\n'],
                      lc = lc)
        # call elmer solver to solve the system of equations
        run([elmersolver, # path to Elmer solver
             "constant_pressure_load-{0}.sif".format(str(lc))], # name of sif file that runs the elmer simulation
            shell=True, 
            check=True)
    #
    plot_displacements(lcs, True)
        
    
