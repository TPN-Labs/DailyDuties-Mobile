import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getFirebaseErrorMessages(AppLocalizations l10n, String error) {
  switch (error) {
    case 'invalid-email':
      return l10n.firebase_auth_error_invalid_email;
    case 'user-not-found':
      return l10n.firebase_auth_error_user_not_found;
    case 'wrong-password':
      return l10n.firebase_auth_error_wrong_password;
    case 'email-already-in-use':
      return l10n.firebase_auth_error_email_already_in_use;
    case 'weak-password':
      return l10n.firebase_auth_error_weak_password;
    case 'user-disabled':
      return l10n.firebase_auth_error_user_disabled;
    case 'invalid-credential':
      return l10n.firebase_auth_error_invalid_credential;
    default:
      return '${l10n.firebase_auth_error_unknown}: $error';
  }
}