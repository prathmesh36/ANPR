function imgn=clip(imagen)

if ~islogical(imagen)
    %imagen=im2bw(imagen,0.99);
    imagen=im2bw(imagen,0.4);
end
a=~imagen;
[f c]=find(a);
lmaxc=max(c);lminc=min(c);
lmaxf=max(f);lminf=min(f);
imgn=a(lminf:lmaxf,lminc:lmaxc);%Crops image

