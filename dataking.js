// A method for extracting cell fluorescence data from a stack of images.

ID = getImageID();
// First, you need to convert your 8-bit grayscale images to binary, 
// with the cells white, background black.
//
// I find the following series of manipulations work well:
//    1. Process -> Subtract Background...
//      Don't use this if you are analyzine a field full of cells.
run("Subtract Background...");

//    2. Process -> FFT -> Bandpass Filter...
//      The default settings (40, 3, none, 5, check, check) have worked well
//      so far, but might be worth playing around with them.
run("Bandpass Filter..."); 
//
//    3. Image -> Adjust -> Threshold
//      Play around with this until cells are red and background is not.
//      Error on side of cell overlap, as that will be handled by the next
//      step and reduces the chance that a cell will be split due to a dark
//      vacuole or something like that.
run("Threshold...");
title = "Wait...";
msg = "If necessary, use the \"Threshold\" tool to\nadjust the threshold, then click \"OK\".";
waitForUser(title, msg);
selectImage(ID);  //make sure we still have the same image
getThreshold(lower, upper);
if (lower==-1)
    exit("Threshold was not set");


//    4. Process -> Binary -> Fill Holes
// run("Fill Holes", "stack"):

//    5. Process -> Binary -> Watershed
run("Watershed", "stack");


//  Now you have a nice stack of images in binary format!  Next, run
//
//    6. Analyze -> Analyze Particles...
roiManager("Reset");
Dialog.create("Particle Parameters");
Dialog.addNumber("Minimum area",100);
Dialog.addNumber("Minimum circularity",0.53);
Dialog.show();
a = Dialog.getNumber();
c = Dialog.getNumber();
run("Analyze Particles...", "size="+a+"-Infinity circularity="+c+"-1.00 show=Outlines exclude clear include summarize record add stack");


