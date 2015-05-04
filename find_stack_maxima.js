// Find Stack Maxima
//
// This macro runs the Process>Binary>Find Maxima
// command on all the images in a stack.

  Dialog.create("Find Maxima");
  Dialog.addNumber("Noise Tolerance:", 5);
  Dialog.addChoice("Output Type:", newArray("Single Points", "Maxima Within Tolerance", "Segmented Particles", "Count"));
  Dialog.addCheckbox("Exclude Edge Maxima", false);
  Dialog.addCheckbox("Light Background", false);
  Dialog.show();
  tolerance = Dialog.getNumber();
  type = Dialog.getChoice();
  exclude = Dialog.getCheckbox();
  light = Dialog.getCheckbox();
  options = "";
  if (exclude) options = options + " exclude";
  if (light) options = options + " light";
  setBatchMode(true);
  input = getImageID();
  n = nSlices();
  for (i=1; i<=n; i++) {
     showProgress(i, n);
     selectImage(input);
     setSlice(i);
     run("Find Maxima...", "noise="+ tolerance +" output=["+type+"]"+options);
     if (i==1)
        output = getImageID();
    else if (type!="Count") {
       run("Select All");
       run("Copy");
       close();
       selectImage(output);
       run("Add Slice");
       run("Paste");
    }
  }
  run("Select None");
  setBatchMode(false);