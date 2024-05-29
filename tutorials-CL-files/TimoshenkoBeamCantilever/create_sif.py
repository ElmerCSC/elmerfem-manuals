def write_new_sif(file, 
                  search_strings, 
                  replacements,
                  lc):
    """
    Take an existing sif file and exchange some lines for a new job. Give a 
    list of strings and an equally long list of replacements. If one of the
    strings is found in a line, it is exchanged by its corresponding element
    in the replacement list.
    

    Parameters
    ----------
    file : str
        name of the file to be copied and modified.
    search_strings : list
        contains the strings for which each line is checked.
    replacements : list
        contains strings which are inserted instead of the line that contains
        a search string.
    lc : float
        characteristic mesh scale.

    Returns
    -------
    None.

    """
    # Open the file in read mode to not change anything
    with open(file, 'r') as f:
        # Read all lines
        lines = f.readlines()
    # open new file
    with open(file.split(".")[0]+"-"+str(lc)+".sif", "w") as f:
        # iterate over lines of previous file
        # check each one if a string expression is contained. if not, copy line
        # else replace it
        for line in lines:
            # check whether a 
            flags = [string in line for string in search_strings]
            if any(flags):
                # index of string expression that was found
                ind = [i for i,flag in enumerate(flags) if flag][0]
                f.write(replacements[ind].format(str(lc)))
            else:
                f.write(line)
    
    return

if __name__ == '__main__':
    
    #
    lc = 1e0
    # replace  
    write_new_sif(file = "constant_pressure_load.sif", 
                  search_strings = ['  Mesh DB "." "cantilever"',
                                    '  Post File = "cantilever.vtu"',
                                    '  Filename = cantilever.dat'], 
                  replacements = ['  Mesh DB "." "cantilever-{0}"\n',
                             '  Post File = "cantilever-{0}.vtu"\n',
                             '  Filename = cantilever-{0}.dat\n'],
                  lc = lc)
        
    
