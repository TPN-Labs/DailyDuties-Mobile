import 'package:get/get.dart';
import 'package:dailyduties/controller/student/student_controller.dart';
import 'package:dailyduties/model/student/meeting_model.dart';
import 'package:dailyduties/model/student/student_model.dart';

StudentModel? getStudentOfMeeting(MeetingModel meetingModel) {
  final APIStudentController apiStudentController = Get.put(APIStudentController());
  List<StudentModel> allStudents = apiStudentController.getAllStudents();
  for (var student in allStudents) {
    if (student.id == meetingModel.student.id) {
      return student;
    }
  }
  return null;
}