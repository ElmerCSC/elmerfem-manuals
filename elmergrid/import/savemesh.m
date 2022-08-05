% Femlab to Elmer mesh export utility
% In Femlab choose: Export to Workspace -> Mesh
% Then save the mesh by 'savemesh(meshname)
% In quickmesh choose 
% 'quickmesh 9 4 meshname' for viewing in ElmerPost
% 'quickmesh 9 2 meshname' for computing with the mesh

function [] = savemesh(mesh)

% Save the node coordinates
dim=size(mesh.p,1);
nocoords=size(mesh.p,2);
coords=mesh.p';
if dim==2
  coords=[coords zeros(size(mesh.p,2),1)];
end
save FemlabMesh.node coords -ascii
clear coords;

% Save the element topology
noelements=size(mesh.t,2);

% If there are no bulk elements the side elements are treated 
% as bulk elements. This enables the saving of surface meshes.
if(noelements > 0) 
  nonodes=size(mesh.t,1)-1;
  elements=mesh.t';
  save FemlabMesh.elem elements -ascii
  clear elements;

  % Save the boundary conditions
  nobounds=size(mesh.e,2);
  if(dim==2) 
    bounds=[mesh.e(1:2,:)' mesh.e(5,:)'];
  else 
    bounds=[mesh.e(1:3,:)' mesh.e(10,:)'];
  end
  save FemlabMesh.boundary bounds -ascii
  clear bounds;
else
  noelements=size(mesh.e,2);
  nonodes=3;
  elements=[mesh.e(1:3,:)' mesh.e(10,:)'];
  save FemlabMesh.elem elements -ascii
  clear elements;

  % Save the boundary conditions (have to be lines)
  nobounds=size(mesh.eg,2);
  bounds=[mesh.eg(1:2,:)' mesh.eg(5,:)'];

  save FemlabMesh.boundary bounds -ascii
  clear bounds;  
end

% Save the header information
save FemlabMesh.header dim nocoords noelements nobounds nonodes -ascii
