  dir = getDirectory("Save masks to...");

  ID = getImageID();
  name = getTitle();
  width = getWidth;
  height = getHeight;


  setBatchMode(true);
  n = nSlices();
  for (i=1;i<=n;i++) {
    showProgress(i,n);
    selectImage(ID);
    setSlice(i);
    out_name = getMetadata("Label");
    
    newImage(name+"_mask_"+i,"8-bit",width,height,1);
    output = getImageID();

    selectImage(ID);
    run("Select All");
    run("Copy");
    selectImage(output);
    run("Paste");
    save(dir+"mask_of_"+out_name);
    close();
  }
  setBatchMode(false);
  exit;
