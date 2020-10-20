#
# a large ball with four circular holes 
#
algebraic3d

solid smallballs = sphere (-1.0, 0.0, 0.0; 0.5)
           or sphere (1.0, 0.0, 0.0; 0.5);

solid bigball = sphere (0.0, 0.0, 0.0; 5.0);

solid rest = bigball and not smallballs;

# two sub-domains
tlo smallballs -col=[1,0,0];
tlo rest -col=[0,0,1] -transparent;
