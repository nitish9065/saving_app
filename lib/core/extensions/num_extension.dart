extension NumDurationExtension on num {
  Duration get microseconds => Duration(microseconds: round());
  Duration get ms => (this * 1000).microseconds;
  Duration get milliseconds => (this * 1000).microseconds;
  Duration get seconds => (this * 1000 * 1000).microseconds;
  Duration get minutes => (this * 1000 * 1000 * 60).microseconds;
  Duration get hours => (this * 1000 * 1000 * 60 * 60).microseconds;
  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).microseconds;
}

extension DoubleExtension on double {
  String toCommaSeparated() {
    String formatted =
        toStringAsFixed(1); // Convert to string with one decimal place
    if (formatted.endsWith('.0')) {
      formatted = formatted.substring(0, formatted.length - 2); // Remove ".0"
    }
    return formatted.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }
}
