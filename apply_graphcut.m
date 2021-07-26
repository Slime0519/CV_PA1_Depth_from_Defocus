function [GCO_resultlabel] = apply_graphcut(Datapath)
%apply_graphcut  Apply graphcut method to costvolume
%   To apply GraphCut method, this function require parameter
%   "Datapath", this is absolute path of dataset.
%   I implemented Graphcut method with Potts model.

folderpath = strcat(Datapath,'\measured_image\');
costvolume = zeros(30,512,512);

for i = 1:30
    filepath = strcat(folderpath, num2str(i,'%02d'),'.png');
    costvolume(i,:,:) = imread(filepath);
end
costvolume = -1*costvolume;
img = costvolume(2,:,:);
colormap(gray);
imagesc(squeeze(img));
ht = 512;
wd = 512;

flat_costvolume = reshape(costvolume,30,[]);
disp(size(flat_costvolume))

neighbor = sparse(wd*ht,wd*ht);
for y=1:ht % set up neighborhood matrix
    for x=1:wd
        if (x < wd), neighbor((y-1)*wd+x,(y-1)*wd+x+1) = 1; end
        if (y < ht), neighbor((y-1)*wd+x, y   *wd+x  ) = 1; end
    end
end
disp("finish make neighbor")

GCO_grid= GCO_Create(wd*ht,size(costvolume,1));
GCO_SetDataCost(GCO_grid,flat_costvolume);
GCO_SetNeighbors(GCO_grid,neighbor);
disp("start expansion")
GCO_Expansion(GCO_grid);
disp("finish expansion")

GCO_resultlabel = GCO_GetLabeling(GCO_grid);
GCO_Delete(GCO_grid);

return
end


