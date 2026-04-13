class AppFormatters {
  static const List<String> _weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String currencyMad(double amount) {
    final bool wholeNumber = amount == amount.roundToDouble();
    final String formatted = wholeNumber
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
    return '$formatted MAD';
  }

  static String reservationDate(DateTime date) {
    return '${_weekdays[date.weekday - 1]}, ${_months[date.month - 1]} ${date.day}';
  }

  static String compactDate(DateTime date) {
    return '${_months[date.month - 1].substring(0, 3)} ${date.day}';
  }

  static String compactDateTime(DateTime date) {
    final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${compactDate(date)} • $hour:$minute $suffix';
  }
}
