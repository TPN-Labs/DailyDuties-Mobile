import 'package:dailyduties/model/student/student_model.dart';

class MeetingModel {
  final String id;
  final StudentModelShort student;
  final DateTime startAt;
  final DateTime endAt;
  final bool firstInMonth;

  MeetingModel({
    required this.id,
    required this.student,
    required this.startAt,
    required this.endAt,
    required this.firstInMonth,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> parsedJson) {
    return MeetingModel(
      id: parsedJson['id'],
      student: StudentModelShort(
        id: parsedJson['student']['id'],
        fullName: parsedJson['student']['fullName'],
        totalMeetings: parsedJson['student']['totalMeetings'],
      ),
      firstInMonth: parsedJson['firstInMonth'],
      startAt: DateTime(
        parsedJson['startAt'][0],
        parsedJson['startAt'][1],
        parsedJson['startAt'][2],
        parsedJson['startAt'][3],
        parsedJson['startAt'][4],
      ),
      endAt: DateTime(
        parsedJson['endAt'][0],
        parsedJson['endAt'][1],
        parsedJson['endAt'][2],
        parsedJson['endAt'][3],
        parsedJson['endAt'][4],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'firstInMonth': firstInMonth,
      'startAt': [
        startAt.year,
        startAt.month,
        startAt.day,
        startAt.hour,
        startAt.minute,
      ],
      'endAt': [
        endAt.year,
        endAt.month,
        endAt.day,
        endAt.hour,
        endAt.minute,
      ],
    };
  }

  @override
  String toString() {
    return '{id: $id, student: $student, startAt: $startAt}\n';
  }
}
