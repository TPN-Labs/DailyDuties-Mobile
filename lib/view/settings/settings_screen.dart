import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dailyduties/config/constants.dart';
import 'package:dailyduties/controller/user/auth_controller.dart';
import 'package:dailyduties/utils/storage_utils.dart';
import 'package:dailyduties/view/settings/language_dialog.dart';
import 'package:dailyduties/view/settings/theme_dialog.dart';
import 'package:dailyduties/view/settings/week_starts_dialog.dart';
import 'package:dailyduties/widget/custom_settings_row.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final APIAuthController _apiAuthController = Get.put(APIAuthController());

  late String _currentThemeMode;
  late String _currentWeekBeginsOn;
  late String _currentLanguage;

  void _setWeekBeginsOn(String weekStart) {
    setState(() {
      _currentWeekBeginsOn = weekStart.capitalize!;
    });
  }

  void _setThemeMode(ThemeMode themeMode) {
    setState(() {
      _currentThemeMode = themeMode
          .toString()
          .replaceFirst('ThemeMode.', '')
          .capitalize!;
    });
  }

  void _setLanguage(String language) {
    setState(() {
      _currentLanguage = language.capitalize!;
    });
  }

  @override
  void initState() {
    var storageThemeMode = GetStorage().read(StorageKeys.appThemeMode);
    var storageWeekStart = GetStorage().read(StorageKeys.appWeekStart);
    var storageAppLanguage = GetStorage().read(StorageKeys.appLanguage);
    setState(() {
      _currentThemeMode = (storageThemeMode == null) ? 'System' : capitalize(storageThemeMode.toString().replaceFirst('ThemeMode.', ''));
      _currentWeekBeginsOn = (storageWeekStart == null) ? 'Monday' : capitalize(storageWeekStart);
      _currentLanguage = (storageAppLanguage == null) ? 'System' : capitalize(storageAppLanguage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .bottomAppBarTheme
            .color,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme
                .of(context)
                .textTheme
                .titleLarge!
                .color,
          ),
        ),
        title: Text(
          l10n.settings_title,
          style: Theme
              .of(context)
              .textTheme
              .titleLarge!
              .copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            color: Theme
                .of(context)
                .bottomAppBarTheme
                .color,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 36),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          ThemeDialogWidget(_setThemeMode),
                        );
                      },
                      child: settingsRow(context, l10n.settings_theme, Icons.dark_mode, _currentThemeMode, null),
                    ),
                    const SizedBox(height: 48),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          WeekStartsDialogWidget(_setWeekBeginsOn),
                        );
                      },
                      child: settingsRow(context, l10n.settings_week_starts_on, Icons.date_range, _currentWeekBeginsOn, null),
                    ),
                    const SizedBox(height: 48),
                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          LanguageDialogWidget(_setLanguage),
                        );
                      },
                      child: settingsRow(context, l10n.settings_language, Icons.language, _currentLanguage, null),
                    ),
                    const SizedBox(height: 48),
                    InkWell(
                      onTap: () {
                        _apiAuthController.sendLogout(context);
                      },
                      child: settingsRow(context, l10n.settings_logout, Icons.logout, null, null),
                    ),
                    const SizedBox(height: 48),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext contextDialog) {
                            return AlertDialog(
                              title: Text(l10n.settings_delete_title),
                              icon: const Icon(Icons.warning_amber_rounded),
                              backgroundColor: Theme.of(contextDialog).appBarTheme.backgroundColor,
                              content: SingleChildScrollView(
                                child: Text(
                                  l10n.settings_delete_body,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(l10n.settings_delete_close),
                                  onPressed: () {
                                    Navigator.of(contextDialog).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    l10n.settings_delete_confirm,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    _apiAuthController.sendDelete(context);
                                    Navigator.of(contextDialog).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: settingsRow(context, l10n.settings_delete_account, Icons.delete, null, Colors.red),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
