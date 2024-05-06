import 'package:dailyduties/utils/l10_utils.dart';
import 'package:dailyduties/view/home/home_screen.dart';
import 'package:dailyduties/widget/snackbar_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dailyduties/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dailyduties/view/auth/signin_screen.dart';
import 'package:dailyduties/view/welcome_screen.dart';

class SignUpController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  RxBool isVisible = false.obs;
  RxBool isAgree = false.obs;
}

class LoginController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  RxBool isVisible = false.obs;
}

class APIAuthController {
  String getUsernameFromToken() {
    return FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  void deleteUserStorage() {
    GetStorage().remove(StorageKeys.appWeekStart);
    GetStorage().remove(StorageKeys.appThemeMode);
    GetStorage().remove(StorageKeys.appLanguage);

    GetStorage().remove(StorageKeys.allStudents);
    GetStorage().remove(StorageKeys.allMeetings);
    GetStorage().remove(StorageKeys.allSessions);
  }

  void sendLogout(BuildContext context) async {
    deleteUserStorage();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const WelcomeScreen());
  }

  void sendLogin(BuildContext context, String user, String password) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user,
        password: password,
      );
      Get.to(
        () => const HomeScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: Constants.transitionDuration),
      );
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, getFirebaseErrorMessages(l10n, e.code));
    } catch (e) {
      print(e);
    }
  }

  void sendRegister(BuildContext context, String username, String email, String password) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user?.updateDisplayName(username);
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, getFirebaseErrorMessages(l10n, e.code));
    } catch (e) {
      print(e);
    }
  }

  void sendDelete(BuildContext context) async {
    deleteUserStorage();
    Get.offAll(() => const SignInScreen());
  }
}
