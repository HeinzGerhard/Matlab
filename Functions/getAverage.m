function average = getAverage(array,numberOfIterations)

temp = array(end-numberOfIterations+1:end);
average = mean(temp);

end