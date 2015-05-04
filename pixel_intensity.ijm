// This macro finds the pixel intensities for a region of interest.

w= getWidth() ; h = getHeight();
getSelectionBounds(xmin, ymin, selwidth, selheight);
run("Create Mask");
m=newArray(w*h);
for(x=0;x<w;x++){
        for(y=0;y<h;y++){
                m[y*w+x]=getPixel(x,y);
        }
}
close(); //close mask
for(x=xmin;(x<=xmin+selwidth);x++){
        for(y=ymin;(y<=ymin+selheight);y++){
                if (m[y*w+x]!=0) print (x,y,getPixel(x,y));
        }
} 
