import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:dailyduties/config/constants.dart';
import 'package:dailyduties/config/textstyle.dart';
import 'package:dailyduties/controller/student/meeting_controller.dart';
import 'package:dailyduties/controller/student/student_controller.dart';
import 'package:dailyduties/controller/user/auth_controller.dart';
import 'package:dailyduties/model/student/meeting_model.dart';
import 'package:dailyduties/model/student/student_model.dart';
import 'package:dailyduties/utils/transform_models.dart';
import 'package:dailyduties/view/settings/settings_screen.dart';
import 'package:dailyduties/view/student/meeting/all_meetings_screen.dart';
import 'package:dailyduties/view/student/all_students_screen.dart';
import 'package:dailyduties/widget/custom_meeting_list.dart';
import 'package:dailyduties/widget/custom_quick.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final APIStudentController _apiStudentController =
      Get.put(APIStudentController());
  final APIMeetingController _apiMeetingController =
      Get.put(APIMeetingController());
  final APIAuthController _apiAuthController = Get.put(APIAuthController());

  List<StudentModel>? _allStudents;
  List<MeetingModel>? _allMeetings;

  void loadStudentsAndMeetings() async {
    await _apiStudentController.userGetAll();
    await _apiMeetingController.userGetAll();

    List<StudentModel> allStudents = _apiStudentController.getAllStudents();
    List<MeetingModel> upcomingMeetings =
        List<MeetingModel>.empty(growable: true);
    for (var student in allStudents) {
      MeetingModel? latestMeeting =
          _apiMeetingController.getLatestMeeting(student.id);
      if (latestMeeting != null) {
        upcomingMeetings.add(latestMeeting);
      }
    }

    setState(() {
      _allStudents = allStudents;
      _allMeetings = upcomingMeetings
        ..sort((a, b) => b.startAt.toString().compareTo(a.startAt.toString()));
    });
  }

  @override
  void initState() {
    loadStudentsAndMeetings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: Get.width,
            color: HexColor(AppTheme.primaryColorString),
            child: Padding(
              padding: Constants.defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.home_title},',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: Get.width - 110,
                            child: Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    strutStyle:
                                        const StrutStyle(fontSize: 12.0),
                                    text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                            fontSize: 32,
                                            color: Colors.white,
                                          ),
                                      text: _apiAuthController
                                          .getUsernameFromToken(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => const SettingsScreen(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(
                              milliseconds: Constants.transitionDuration,
                            ),
                          );
                        },
                        child: Container(
                          height: 72,
                          width: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).bottomAppBarTheme.color,
                            border: Border.all(
                              color: HexColor(AppTheme.primaryColorString),
                              width: 2,
                            ),
                          ),
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(72),
                              child: Icon(
                                Icons.person,
                                color: Theme.of(context).shadowColor,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const AllMeetingsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(
                                  milliseconds: Constants.transitionDuration,
                                ),
                              );
                            },
                            child: quickAccessContainer(
                              context,
                              l10n.home_quick_1,
                              Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).shadowColor,
                                size: 36,
                              ),
                              null,
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const AllStudentsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(
                                  milliseconds: Constants.transitionDuration,
                                ),
                              );
                            },
                            child: quickAccessContainer(
                              context,
                              l10n.home_quick_3,
                              Icon(
                                Icons.person,
                                color: Theme.of(context).shadowColor,
                                size: 36,
                              ),
                              null,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Theme.of(context).bottomAppBarTheme.color,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: Constants.defaultScreenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          l10n.home_upcoming,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 18,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            if (_allStudents != null) ...[
                              for (var i = 0; i < _allMeetings!.length; i++)
                                meetingList(
                                  context: context,
                                  meetingData: _allMeetings!.elementAt(i),
                                  isOnHomeScreen: true,
                                  studentModel: getStudentOfMeeting(
                                    _allMeetings!.elementAt(i),
                                  ),
                                  refreshList: loadStudentsAndMeetings,
                                ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget circleCard(
  BuildContext context,
  IconData icon,
  String text,
  Color color,
) {
  return SizedBox(
    width: (Get.width - 50) / 4,
    child: Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Icon(
              icon,
              size: 40,
              color: HexColor(AppTheme.secondaryColorString),
            ),
          ),
        ),
        const SizedBox(height: DefaultMargins.smallMargin),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
