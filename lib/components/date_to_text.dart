String dateToText(DateTime date, {int type = 0}) {
  if(type == 0)
    return date.day.toString().padLeft(2, '0')+"/"+date.month.toString().padLeft(2, '0')+"/"+date.year.toString();
  else
    return date.year.toString()+"-"+date.month.toString().padLeft(2, '0')+"-"+date.day.toString().padLeft(2, '0');
}