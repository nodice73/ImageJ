    setBatchMode(true);
    run("Clear Results");
    run("Select None");
    makeRectangle(344, 0, 681, 1029);
    for (i=1; i<nSlices+1; i++) {
      run("Subtract Background...", "rolling=200 slice");
      run("Despeckle");
      run("Enhance Contrast", "saturated=0.5 normalize");
      run("Find Maxima...", "noise=35 output=Count exclude");
      updateResults();
      setSlice(i);
    }
