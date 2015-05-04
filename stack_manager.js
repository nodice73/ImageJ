// ROI Manager Stack Demo
//
// This macro demonstrates how to use the "count"
// "reset", "add", "select" and "deselect" options of 
// the roiManager() function. It creates a 100 slice 
// stack, creates an oval selection for each slice
// and adds it to the ROI Manager, then it restores
// each of the 100 selections and measures the
// area and mean.

  requires("1.34k");
  saveSettings();
  newImage("Test Stack", "8-bit black", 500, 500, 100);
  restoreSettings();
  if (roiManager("count")>0) roiManager("reset");
  for (i=1; i<=nSlices; i++) {
      setSlice(i);
      makeOval(i*2, i*2, i*4, i*4);
      roiManager("add");
      setColor(i+99); fill();
  }
  n = roiManager("count");
  for (i=0; i<n; i++) {
      roiManager("select", i);
      getStatistics(area, mean);
      setResult("Area",  i, area);
      setResult("Mean", i, mean);
  }
  updateResults();
  roiManager("deselect");
