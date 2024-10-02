
extension StringExtension on String {
  String toFormattedBrlCurrency({bool isNegative = false}) {
    return '${isNegative ? '- ' : ''}R\$${double.parse(this).toStringAsFixed(2).toString().replaceAll('.', ',')}';
  }
}
