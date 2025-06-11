String timeToText (DateTime date) {
  return '${date.year.toString()}년 '
      '${date.month.toString().padLeft(2, '0')}월 '
      '${date.day.toString().padLeft(2, '0')}일';
}