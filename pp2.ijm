// vim: set filetype=javascript shiftwidth=2 tabstop=2 expandtab :
macro "pp2" {
    setBatchMode(true);
    pp2();
}

function pp2() {
  run("Clear Results");
  run("Set Measurements...", " redirect=None decimal=9");
  run("Line Width...", "line=3");
  setForegroundColor(0,0,0);
  setBackgroundColor(255,255,255);

  FS = File.separator();

  MIN_AREA = 5;
  COUNT_THRESH = 0.60
  AREA_THRESH  = 0.60
  MULTI_THRESH = 0.60
  COUNT_NAME = "counts";
  AREA_NAME  = "areas";
  MULTI_NAME = "multi";
  COMP_NAME  = "comp";
  RADIUS = 200;

  Dialog.create("Circularity Threshold Parameters");
  Dialog.addNumber("Minimum area:",MIN_AREA);
  Dialog.addMessage("Choose minimum circularity values to...");
  Dialog.addNumber("Count:",COUNT_THRESH);
  Dialog.addNumber("Consider area:",AREA_THRESH);
  Dialog.addNumber("Consider a single colony:", MULTI_THRESH);
  Dialog.show();

  MIN_AREA = Dialog.getNumber();
  COUNT_THRESH = Dialog.getNumber(); 
  AREA_THRESH  = Dialog.getNumber(); 
  MULTI_THRESH = Dialog.getNumber(); 

  title = getTitle();
  image_path = getDirectory("image");
  close();

  image_name = replace(title,".tif","");
  match_string = image_name+"\.zip\|roi";
  path_to_selections = image_path+getSels(image_path,match_string);
  data_path    = image_path +  'data' + FS;
  outline_path = image_path + 'outlines' + FS;
  mkdir(data_path);
  mkdir(outline_path);

  roiManager("open", path_to_selections);
  nsels = roiManager("count");
  roiManager("reset");
  for (z=0;z<nsels;z++) {
    roiManager("open", path_to_selections);
    open(image_path+title);
    run("Set Scale...", "distance=0 known=1 pixel=1 unit=pixel");
    orig = getImageID();
    roiManager("Select",z);
    sel_name = image_name+'-'+selectionName;
    path_to_count_selections = data_path+sel_name+"_count_selections.zip";
    path_to_measurements     = data_path+sel_name+"_measurements.txt";
    path_to_outlines         = outline_path+sel_name+"_outlines.png";

    run("Crop");
    roiManager("Reset");
    roiManager("Add");
    roiManager("Select",0);
    roiManager("Rename",sel_name);

    run("Select None");
    run("Enhance Contrast", "saturated=0.1 normalize");
    run("Duplicate...", "title=mask");
    cid = getImageID();
    run("Duplicate...", "title="+COMP_NAME);
    gray_comp = getImageID();
    roiManager("Select",0);
    roiManager("Draw");
    run("8-bit");

    getDimensions(width,height,channels,slices,frames);

    selectImage(cid);
    run("Gaussian Blur...", "sigma=1.00");
    roiManager("Select",0);
    run("Clear Outside");
    run("Select None");
    setAutoThreshold("MaxEntropy apply");
    run("Convert to Mask");
    run("Options...", "iterations=3 count=4 edm=Overwrite do=Erode");
    run("Watershed");
    run("Watershed");

    // Run with low threshold to get as many counts as possible.
    roiManager("Reset");
    run("Analyze Particles...", "size="+MIN_AREA+"-7000 circularity="+COUNT_THRESH+"-1.00 show=Outlines add");
    count_drawing = getImageID();
    rename(COUNT_NAME);
    prep_drawing(count_drawing);
    roiManager("save",path_to_count_selections);
    roiManager("Reset");


    // Select multiple colonies that might have been counted as singles.
    selectImage(cid);
    run("Analyze Particles...", "size="+MIN_AREA+"-7000 circularity="+COUNT_THRESH+"-"+AREA_THRESH+" show=Outlines add");
    mult_drawing = getImageID();
    rename(MULTI_NAME);
    prep_drawing(mult_drawing);
    roiManager("Reset");

    // Run again with a more strict circularity requirement to improve
    // area estimates (This will bias against larger colonies).
    selectImage(cid);
    run("Analyze Particles...", "size="+MIN_AREA+"-7000 circularity="+AREA_THRESH+"-1.00 show=Outlines exclude add");
    area_drawing = getImageID();
    rename(AREA_NAME);
    prep_drawing(area_drawing);
    
    run("Merge Channels...", " red="+AREA_NAME+" green="+MULTI_NAME+" blue="+COUNT_NAME+" gray="+COMP_NAME+" create keep");
    run("Stack to RGB");

    saveAs("PNG", path_to_outlines);

    closer(6);


    selectImage(orig);
    f = File.open(path_to_measurements);
    print(f, "label\tarea\tmedian\tmean\tsd\tmin\tmax\tcirc\tround");
    csels = roiManager("count");
    for (i=0; i<csels; i++) {
      roiManager("select",i);
      roiManager("rename",i+1);
      List.setMeasurements;
      print(f,sel_name+"\t"+
              List.getValue("Area")  +"\t"+
              List.getValue("Median")+"\t"+
              List.getValue("Mean")  +"\t"+
              List.getValue("StdDev")+"\t"+
              List.getValue("Min")   +"\t"+
              List.getValue("Max")   +"\t"+
              List.getValue("Circ.") +"\t"+
              List.getValue("Round"));
    }
    File.close(f);
    close();
    roiManager("reset");
  }
  closer(2);
}

function getSels(path,match) {
  contents = getFileList(path);
  ret = ""
  for (i=0; i<contents.length; i++) {
    if ( matches(contents[i], match) ) {
      ret = contents[i];
    }
  }
  if (ret == "") {
    exit("Didn't find a matching selection file.");
  } else {
    return ret;
  }
}

function printa(arr) {
  for (i=0; i<arr.length; i++) {
    print(arr[i]);
  }
}

function prep_drawing(id) {
  selectImage(id);
  run("8-bit");
  run("Invert");
}
function closer(n) {
  for (i=0;i<n;i++) {
    close();
  }
}
function mkdir(dir) {
  if (File.exists(dir) ==0)
    File.makeDirectory(dir);
}
