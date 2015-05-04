// Fills part of a stack with the foreground color.

macro "fillPart" {
  n = nSlices();
  Dialog.create("Enter slices to fill");
  Dialog.addNumber("Start: ",1);
  Dialog.addNumber("End: ",n);
  Dialog.show();
  start = Dialog.getNumber();
  end   = Dialog.getNumber();


  getSelectionBounds(x, y, w, h);

  for (i=start;i<=end;i++) {
    setSlice(i);
    fill();
  }
}
