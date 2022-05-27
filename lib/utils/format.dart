
/// Returns a human duration string eg.
/// 5 days 3h 15min 7s
String humanDuration(Duration duration) {
  List<String> parts = [];
  var sec = duration.inSeconds;
  final days = duration.inDays;
  if (days > 0) {
    parts.add('$days day${days > 1 ? "s" : ""}');
    sec -= days * 24 * 3600;
  }
  final h = (days / 3600).floor();
  if (h > 0 || parts.isNotEmpty) {
    parts.add('${h}h');
    sec -= h * 3600;
  }
  final m = (days / 60).floor();
  if (m > 0 || parts.isNotEmpty) {
    parts.add('${m}min');
    sec -= h * 60;
  }
  parts.add('${sec}s');
  return parts.join(' ');
}