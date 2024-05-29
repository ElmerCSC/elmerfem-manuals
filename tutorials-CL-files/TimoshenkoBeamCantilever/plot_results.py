import numpy as np
import matplotlib.pyplot as plt

def plot_displacements(lcs,
                       save_fig=False):
    """
    Plot number of elements versus the deflection in y direction and angular 
    deflection.

    Parameters
    ----------
    lcs : np.ndarray
       list of characterlistic mesh length scales for which results are plotted.
    save_fig : bool
       save figure if True.
     
    Returns
    -------
    None.

    """
    # font size for labels etc.
    font = 14
    #
    nelems = []
    displ = []
    for lc in lcs:
        nelems.append(np.loadtxt("cantilever-{0}_nelem.csv".format(str(lc))))
        displ.append(np.loadtxt("cantilever-{0}.dat".format(str(lc)))[[4,-1]])
    # convert collection from list to numpy array by stacking the entries on 
    # top of each other
    displ = np.vstack(displ)
    # deflection and angle displacement
    w = displ[:,0]
    theta = displ[:,1]
    # 
    fig, axs = plt.subplots(1,2,figsize=(12,8))
    # plot u and theta vs the inverse length scale which is approximately the 
    # number of elements versus displacement
    axs[0].plot(nelems,w)
    axs[1].plot(nelems,theta)
    # plot analytical solutions as horizontal red line
    A,I,G,L,E,f = 1,1,1,1,0.2,1e-2
    axs[0].axhline(y=L**4 * f * ( 1 + 4*E*I / (G*A*L**2) ) / (8*E*I), 
                   color = "r", linestyle="--")
    axs[1].axhline(y=L**3 * f / (6*E*I), 
                   color = "r", linestyle="--")
    # make x axis logarithmic
    axs[0].set_xscale("log")
    axs[1].set_xscale("log")
    # set lower and upper limit of y axis
    axs[0].set_ylim(8e-3,1.2e-2)
    axs[1].set_ylim(8e-3,8.5e-3)
    # put labels on x axis
    axs[0].set_xlabel(r"elements",fontsize=font)
    axs[1].set_xlabel(r"elements",fontsize=font)
    # put labels on y axis
    axs[0].set_ylabel(r"deflection $w$",fontsize=font)
    axs[1].set_ylabel(r"rotation $\theta$",fontsize=font)
    #
    if save_fig:
        plt.savefig("nr-elements-displacements.pdf", format="pdf",
                    bbox_inches="tight")
    # show the plot as pop up window
    plt.show()
    return 

if __name__ == '__main__':
    plot_displacements(lcs=np.array([1e0]))
    
