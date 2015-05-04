// Takes a stack of pictures that have been converted to binary images
// and calculates the area of the black portion.

macro "Find Areas" {
    run("Set Scale...","distance=6.250 known=1 pixel=1 unit=um");
    getVoxelSize(w,h,d,unit);
    run("Clear Results");
    run("Select None");
    setBatchMode(true);


    Dialog.create("Area Settings");
    Dialog.addString("Skip:","");
    Dialog.addNumber("Time Interval:",15);
    Dialog.show();
    num_string = Dialog.getString();
    time_inter = Dialog.getNumber();
    nums = split(num_string,',');
    //for (i=0; i<nums.length; i++) print(nums[i]);
    //exit;

    for (i=1; i<nSlices+1; i++) {
        var seen = 0;
        for (j=0; j<nums.length; j++) {
            if (i == nums[j]) seen = 1;
        }
        //print("Current i: "+i);
        if (seen == 1) {
            //print("Skipping "+i);
            i = i+1;
            //print("New i is "+i);
        }
        setSlice(i);
        //print("Set slice to "+i); 
        run("Create Selection");
        run("Fill","stack");
        getStatistics(area);
        cells = area / (pow(5/2,2)*3.1418);
        row = nResults;
        setResult("Slice",row,i);
        setResult("Time (hr)",row,(time_inter/60)*(i-1));
        setResult("Cell Count",row, cells);
        setResult("Area ("+unit+"^2)",row,area);
        updateResults();
        //print("At end of loop, i is "+i);
    }
}
