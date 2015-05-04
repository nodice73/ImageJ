run("Clear Results");
for(i=1;i<nSlices+1;i++) {
  setSlice(i);
  rep = 1;
  for (j=0;j<rep;j++) {
    run("Measure");
  }
}


