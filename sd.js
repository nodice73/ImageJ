means = newArray(5,6,7);
mean_sum = 0;
sd_squared_sum = 0;
n = means.length;
for(j=0;j<n;j++) {
  mean_sum += means[j];
  squared_mean_sum += pow(means[j],2);
}
slice_mean = mean_sum / n;
slice_var = 1/n * squared_mean_sum - pow(slice_mean,2);
slice_sd   = sqrt(slice_var);
cv = slice_sd / slice_mean;
print(slice_mean+"\n"+slice_sd+"\n"+cv);
