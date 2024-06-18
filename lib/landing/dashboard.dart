import 'dart:core';

import 'package:comp_flutter/ui/exam/subject_search.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:sgela_services/data/sgela_user.dart';
import 'package:sgela_services/sgela_util/functions.dart';
import 'package:sgela_services/sgela_util/navigation_util.dart';
import 'package:sgela_services/sgela_util/prefs.dart';
import 'package:sgela_shared_widgets/util/gaps.dart';
import 'package:sgela_shared_widgets/util/styles.dart';
import 'package:sgela_shared_widgets/widgets/org_logo_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalRequests = 0;
  int totalPromptTokens = 0;
  int totalResponseTokens = 0;
  int totalModels = 0;

  SgelaUser? sgelaUser;
  Prefs prefs = GetIt.instance<Prefs>();

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    sgelaUser = prefs.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const OrgLogoWidget(),
        actions: [
          PopupMenuButton<int>(
            onSelected: (int item) {
              // Handle menu item selection
              pp('............ Selected: $item');
              switch (item) {
                case 0:
                  _navigateToSubjectSearch();
                  break;
                case 2:
                  _navigateToSettings();
                  break;
                case 1:
                  _refreshData();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.blue),
                      gapW8, // Add an icon
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Subjects'),
                      ),
                    ],
                  ),
                ),

                const PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.upcoming, color: Colors.red),
                      gapW8, // Add an icon// Add an icon
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Upcoming')),
                    ],
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.grey),
                      gapW8, // Add an icon// Add an icon
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Settings'),
                      ),
                    ],
                  ),
                ),

              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gapH32,

                  sgelaUser == null
                      ? Text('Dashboard User', style: myTextStyleSmall(context))
                      : Text(
                          '${sgelaUser!.firstName} ${sgelaUser!.lastName}',
                          style: myTextStyle(
                              context,
                              Theme.of(context).primaryColorLight,
                              16,
                              FontWeight.normal),
                        ),
                  gapH32,
                  gapH32,
                  Expanded(
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
                      children: [
                        NumberCard(
                            height: 200,
                            width: 200,
                            total: totalPromptTokens,
                            caption: 'Prompt Tokens',
                            onTap: () {
                              pp('$mm tapped prompt tokens');
                            }),
                        NumberCard(
                            height: 200,
                            width: 200,
                            total: totalResponseTokens,
                            caption: 'Response Tokens',
                            onTap: () {
                              pp('$mm tapped response tokens');
                            }),
                        NumberCard(
                            height: 200,
                            width: 200,
                            total: totalRequests,
                            caption: 'Total Requests',
                            onTap: () {
                              pp('$mm tapped total requests');
                            }),
                        NumberCard(
                            height: 200,
                            width: 200,
                            total: totalModels,
                            caption: 'Models Used',
                            onTap: () {
                              pp('$mm tapped models used');
                            }),
                      ],
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset('assets/sgela_logo2_clear.png', height: 72, width: 72),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings, color: Colors.grey),
          ),
          BottomNavigationBarItem(
            label: 'Upcoming',
            icon: Icon(Icons.upcoming, color: Colors.red),
          ),
          BottomNavigationBarItem(
            label: 'Subjects',
            icon: Icon(Icons.search, color: Colors.blue),
          ),
        ],
        elevation: 16,
        onTap: (m) {
          switch (m) {
            case 2:
              _navigateToSubjectSearch();
              break;
            case 0:
              _navigateToSettings();
              break;
            case 1:
              _refreshData();
              break;
          }
        },
      ),
    );
  }

  static const mm = '🛂🛂🛂Dashboard 🛂';

  void _navigateToSubjectSearch() {
    pp('$mm ... _navigateToSubjectSearch');
    NavigationUtils.navigateToPage(context: context, widget: const SubjectSearch());
  }

  void _navigateToSettings() {
    pp('$mm ... _navigateToSettings');
  }

  void _refreshData() {
    pp('$mm ... _refreshData');
  }
}

class NumberCard extends StatelessWidget {
  const NumberCard(
      {super.key,
      required this.height,
      required this.width,
      required this.total,
      required this.caption,
      required this.onTap});

  final double height, width;
  final int total;
  final String caption;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var nf = NumberFormat('###,###,###');
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Card(
        elevation: 8,
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                nf.format(total),
                style: myTextStyle(
                    context, Theme.of(context).primaryColor, 28, FontWeight.w900),
              ),
              gapH16,
              Text(caption),
            ],
          ),
        ),
      ),
    );
  }
}
