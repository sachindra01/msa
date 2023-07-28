ageCalculator(String age) {
  if(age.substring(age.length-1)!="0"){
    return age.replaceAll(RegExp(r'.$'), "0");
  }
  else{
    return age;
  }
}