// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dailyduties/config/constants.dart';
import 'package:dailyduties/model/student/student_model.dart';
import 'package:dailyduties/widget/snackbar_containers.dart';

class StudentController extends GetxController {
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> totalMeetingsController = TextEditingController().obs;
  RxBool isVisible = false.obs;
}

class APIStudentController {
  List<StudentModel> getAllStudents() {
    List storageStudents = GetStorage().read(StorageKeys.allStudents) ?? List.empty();
    return storageStudents.map((element) => StudentModel.fromJson(element)).toList();
  }

  void syncStorage(
    APIMethods method,
    String studentId,
    Map<String, dynamic> formInput,
  ) {
    List<StudentModel> storageStudents = getAllStudents();
    switch (method) {
      case APIMethods.create:
        StudentModel newStudent = StudentModel(
          id: studentId,
          fullName: formInput['fullName'],
          gender: formInput['gender'],
          totalMeetings: formInput['totalMeetings'],
        );
        storageStudents.add(newStudent);
        break;
      case APIMethods.update:
        int currentStudentIdx = storageStudents.indexWhere((student) => student.id == studentId);
        storageStudents[currentStudentIdx] = StudentModel(
          id: studentId,
          fullName: formInput['fullName'],
          gender: formInput['gender'],
          totalMeetings: formInput['totalMeetings'],
        );
        break;
      case APIMethods.delete:
        int currentStudentIdx = storageStudents.indexWhere((student) => student.id == studentId);
        storageStudents.removeAt(currentStudentIdx);
        break;
      default:
        break;
    }
    GetStorage().remove(StorageKeys.allStudents);
    GetStorage().write(
      StorageKeys.allStudents,
      json.decode(json.encode(storageStudents)),
    );
  }

  Future<void> userGetAll() async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.get(
      Uri.parse('${Constants.apiEndpoint}/students/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      print("eroare");
      print(responseBody['message']);
    } else {
      GetStorage().write(StorageKeys.allStudents, responseBody);
    }
  }

  void userUpdate(
    BuildContext context,
    String studentId,
    String fullName,
    int gender,
    int totalMeetings,
    Function refreshList,
    Function refreshDetails,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'id': studentId,
      'fullName': fullName,
      'gender': gender,
      'totalMeetings': totalMeetings,
    };
    final response = await http.put(
      Uri.parse('${Constants.apiEndpoint}/students/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: jsonEncode(formInput),
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      Navigator.of(context).pop();
      syncStorage(
        APIMethods.update,
        studentId,
        formInput,
      );
      refreshList();
      refreshDetails();
      showSuccessSnackBar(context, 'Student updated successfully');
    }
  }

  void userDelete(
    BuildContext context,
    String id,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'id': id,
    };
    final response = await http.delete(
      Uri.parse('${Constants.apiEndpoint}/students/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: jsonEncode(formInput),
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      syncStorage(
        APIMethods.delete,
        id,
        formInput,
      );
      refreshList();
      showSuccessSnackBar(context, 'Student deleted successfully');
    }
  }

  void userCreate(
    BuildContext context,
    String fullName,
    int gender,
    int totalMeetings,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'fullName': fullName,
      'gender': gender,
      'totalMeetings': totalMeetings,
    };
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/students/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: jsonEncode(formInput),
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      Navigator.of(context).pop();
      syncStorage(
        APIMethods.create,
        responseBody['id'],
        formInput,
      );
      refreshList();
      showSuccessSnackBar(context, 'Student created successfully');
    }
  }
}
