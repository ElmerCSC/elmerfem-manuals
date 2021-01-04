ElmerGUI manual and tutorials
=============================

* This repository includes the source files for building
  part of the Elmer doumentation.
* Currently ElmerGUI Manual and Elmer Tutorials are provided.
  The other parts of the domentation are not yet in open repository.
* The documentation here is licensed under Creative Commons
  Attribution-NonCommercial.

Content of the directories
--------------------------

* gui - ElmerGUI manual
* tutorials-GUI - tutorials where ElmerGUI is used
* tutorials-GUI-files - files related to GUI tutorials
* tutorials-CL - tutorials without graphical user interface (command-line usage, files explained)
* tutorials-CL-files - files related to the tutorials wihout the graphical user interface 

Building in Linux
-----------------

- To build the documentation requires LaTex being installed.
- To create the documentation under Linux you can open a terminal window in the 'elmerfem-manuals' directory and type "source makedoc".
- If you get an error like 'float.sty not found', then you may need to install the 'extra' package:   'sudo apt-get install texlive-latex-extra'.

Building in Windows
-------------------

- To build with LaTeX in Windows, install 'MikTex'.
- Msys2 has a bash shell that can run the 'source makedoc' script.
- Installing Git usually also installs 'Git Bash' as a right click context menu selection and Git Bash can run the 'source makedoc' script.

TeXworks
--------

- TeXworks is a LaTex editor that can be used to edit a single manual.
- TeXworks can be used in Linux and in Windows.  For Windows, installing 'MikTex' will also TeXworks.
- Select 'pdfLaTeX+MakeIndex+BibTeX' in order to build a manual.
- It is suggested to use the TeXworks dictionary 'English - United Kingdom (en-GB) for spelling checks.
