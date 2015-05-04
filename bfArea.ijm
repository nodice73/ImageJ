// vim: set filetype=javascript:
macro "bfArea" {
  //setBatchMode(true);
  bfArea();
}

function bfArea() {
  roiManager("reset");
  run("Select None");
  orig = getImageID();
  slices = nSlices();
  project_dir = File.getParent(getDirectory("image"));

  Dialog.create("Enter time info");
  Dialog.addNumber("Start time (hours)",0);
  Dialog.addNumber("Time step (hours)",1.5);
  Dialog.show();
  start = Dialog.getNumber();
  dt = Dialog.getNumber();

//print(project_dir);
  f = File.open(project_dir+"/bfArea_results.txt");
  print(f,"position\tslice\ttime\tarea");

  for (slice=1; slice<nSlices; slice++) {
    setSlice(slice);
    title = getTitle();
    flat = flatten();
    mask = makeMask(flat);
    run("Create Selection");
    List.setMeasurements;
    area = List.getValue("Area");
    time = start+(slice-1)*dt;
    print(f,title+"\t"+slice+"\t"+time+"\t"+area);
    roiManager("reset");
    run("Select None");
    close();
    close();
  }
}


function flatten() {
  run("Duplicate...", "title=flat");
  id = getImageID();
  title = getTitle();
  image_name = replace(title,'.tif',"");

  rad=50;
  selectImage(id);
  run("Duplicate...", "title=bg");
  bg_id = getImageID();

  run("Select None");
  run("Gaussian Blur...", "sigma=10");
  run("Subtract Background...", "rolling="+rad+" light parabaloid create");

  imageCalculator("Subtract create 32-bit", id, bg_id);
  rename(image_name+"_flat.tif");
  f_id = getImageID();

  selectImage(bg_id);
  close();
  selectImage(id);
  close();
  return f_id;
}

function makeMask(id) {
  run("Select None");
  selectImage(id);
  run("Duplicate...", "title=mask");
  mask = getImageID();
  run("16-bit");
  run("Gaussian Blur...", "sigma=1");
  run("8-bit");
  run("Variance...", "radius=2");
  setAutoThreshold("MaxEntropy dark");
  run("Convert to Mask","");
  run("Fill Holes");
  return mask;
}

function measureSelections(id) {
  selectImage(id);
  title = getTitle();
  nStarts = roiManager("count");
  for (sel=0;sel<nStarts;sel++) {
    roiManager("Select",sel);
    List.setMeasurements;
    area = List.getValue("Area");
    sd = List.getValue("StdDev");
    print(f,title+"\t"+slice+"\t"+(sel+1)+"\t"+area+"\t"+sd);
  }
}
