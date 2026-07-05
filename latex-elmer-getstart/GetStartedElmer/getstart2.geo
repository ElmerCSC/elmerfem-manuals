// Gmsh project created on Sun Jun 21 11:12:31 2026
SetFactory("OpenCASCADE");
//+
Box(1) = {0, 0, 0, 300, 200, 200};
//+
Box(2) = {0, 0, 0, 200, 300, 200};
//+
Coherence;
