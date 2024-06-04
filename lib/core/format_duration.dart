// Umwandle milliseconds in hh:mm:ss
String formatedDuration(Duration duration) {
  String hours = duration.inHours.toString().padLeft(2, '0');
  String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  if (hours == "00") {
    return '$minutes:$seconds';
  }
  return '$hours:$minutes:$seconds';
}

int unformatedDuration(Duration duration){
  String formattedDuration = duration.toString();
  List<String> parts = formattedDuration.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = double.parse(parts[2]).toInt();

  DateTime zeroTime = DateTime.utc(1970, 1, 1);
  DateTime formattedTime = zeroTime.add(Duration(hours: hours, minutes: minutes, seconds: seconds));
  int milliseconds = formattedTime.millisecondsSinceEpoch;

  return milliseconds;

}