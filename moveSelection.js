// ROI Manager Move Selections
//
// This macro moves all the ROI Manager 
// selections a specified distance.
// Upper-left corner is (0,0), numbers increase towards lower-right.

  macro "Move Selections" {
      requires("1.38e");
      setBatchMode(true);
      dx = 0;
      dy = 0;
      Dialog.create("Move Selections");
      Dialog.addNumber("X Displacement:", dx);
      Dialog.addNumber("Y Displacement:", dy);
      Dialog.show();
      dx = Dialog.getNumber();
      dy = Dialog.getNumber();;
      n = roiManager("count");
      if (n==0)
          exit("The ROI Manager is empty");
      for (i=0; i<n; i++) {
          roiManager('select', i);
          getSelectionBounds(x, y, w, h);
          setSelectionLocation(x+dx, y+dy);
          roiManager('update');
      }
  }
