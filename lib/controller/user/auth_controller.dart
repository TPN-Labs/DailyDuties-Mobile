import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dailyduties/config/constants.dart';
import 'package:dailyduties/utils/storage_utils.dart';
import 'package:dailyduties/view/auth/signin_screen.dart';
import 'package:dailyduties/view/home/home_screen.dart';
import 'package:dailyduties/view/welcome_screen.dart';
import 'package:dailyduties/widget/snackbar_containers.dart';

class SignUpController extends GetxController {
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  RxBool isVisible = false.obs;
  RxBool isAgree = false.obs;
}

class LoginController extends GetxController {
  Rx<TextEditingController> userInputController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  RxBool isVisible = false.obs;
}

class APIAuthController {
  String getUsernameFromToken() {
    final authKey = GetStorage().read('authKey') ?? '';
    return parseJwt(authKey)['username'];
  }

  void deleteUserStorage() {
    GetStorage().remove(StorageKeys.authKey);
    GetStorage().remove(StorageKeys.appWeekStart);
    GetStorage().remove(StorageKeys.appThemeMode);
    GetStorage().remove(StorageKeys.appLanguage);

    GetStorage().remove(StorageKeys.allStudents);
    GetStorage().remove(StorageKeys.allMeetings);
    GetStorage().remove(StorageKeys.allSessions);
  }

  void sendLogout(BuildContext context) async {
    deleteUserStorage();
    Get.offAll(() => const WelcomeScreen());
  }

  void sendLogin(BuildContext context, String user, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
      },
      body: jsonEncode(<String, String>{
        'user': user.trim(),
        'password': password,
      }),
    );
    if (response.statusCode != 200) {
      // ignore: use_build_context_synchronously
      showErrorSnackBar(context, response.body);
    } else {
      var responseBody = json.decode(response.body);
      GetStorage().write(StorageKeys.authKey, responseBody['authKey']);

      Get.to(
        () => const HomeScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: Constants.transitionDuration),
      );
    }
  }

  void sendRegister(BuildContext context, String user, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
      },
      body: jsonEncode(<String, String>{
        'username': user,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode != 201) {
      // ignore: use_build_context_synchronously
      showErrorSnackBar(context, response.body);
    } else {
      Get.to(
        () => const SignInScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: Constants.transitionDuration),
      );
    }
  }

  void sendDelete(BuildContext context) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/auth/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: '',
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      // ignore: use_build_context_synchronously
      showErrorSnackBar(context, response.body);
    } else {
      deleteUserStorage();
      Get.offAll(() => const SignInScreen());
    }
  }
}
