name = "[Table Test]";
run("New... ", "name="+name+" type=Table");
f = name;

print(f, "\\Headings:A\tB");
print(f, 1+"\t"+2);
