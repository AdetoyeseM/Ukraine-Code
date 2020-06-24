  
String bigNumberConvert(int number) {
  double value = 0;
  String suffix = '';
  if (number >= 1000000) {
    value = (number / 100000).floor() / 10;
    suffix = 'M';
  } else if (number >= 10000) {
    value = (number / 100).floor() / 10;
    suffix = 'K';
  } else {
    value = number.toDouble();
  }

  final strValue = value.toString();
  return '${value.toStringAsFixed(strValue[strValue.length - 1] == '0' ? 0 : 1)}$suffix';
}
