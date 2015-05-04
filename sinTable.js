// Sine Cosine Table
//
// This macro displays a sine/cosine table in a TextWindow.

  requires("1.38m");
  title1 = "Sine/Cosine Table";
  title2 = "["+title1+"]";
  f = title2;
  if (isOpen(title1))
     print(f, "\\Clear");
  else {
    run("New... ", "name="+title2+" type=Table width=250 height=600");
  }
  print(f, "\\Headings:n\tSine\tCosine");
  for (n=0; n<=2*PI; n += 0.1)
     print(f, n + "\t" + sin(n) + "\t" + cos(n));

