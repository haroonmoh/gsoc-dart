import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_info.dart';
import 'package:gsoc_application/classes/fc_user.dart';
import 'package:gsoc_application/classes/github_issue.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class FlutterCommunityCalendar extends StatefulWidget {
  FlutterCommunityCalendar({ Key? key, required this.fcInfo, required this.fcAdminUser }) : super(key: key);

  FCInfo fcInfo;
  final FCAdminUser fcAdminUser;

  @override
  State<FlutterCommunityCalendar> createState() => _FlutterCommunityCalendarState();
}

class _FlutterCommunityCalendarState extends State<FlutterCommunityCalendar> {

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final f = new DateFormat('MM/dd/yyyy');

  List<dynamic> _getEvents(DateTime date) {
    List<GithubIssue> issues = [];
    for (final repo in widget.fcInfo.fcRepos) {
      for(final issue in repo.fcIssues) {
        if (f.format(issue.createdAt) == f.format(date)) {
          issues.add(issue);
        }
      }
    }
    return issues;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Calendar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              selectedDayPredicate: (day) =>isSameDay(day, _selectedDay),
              eventLoader: _getEvents,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
            ),
            const SizedBox(height: 20,),
            for(final GithubIssue issue in _getEvents(_selectedDay))
              InkWell(
                onTap: () async {
                  print(issue.over30Days);
                  if (!await launch(issue.htmlUrl)) throw 'Could not launch ${issue.htmlUrl}';
                },
                child: Card(
                  color: issue.over30Days ? Colors.red.withOpacity(0.4) : Colors.teal.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(issue.title, maxLines: 1, overflow: TextOverflow.ellipsis,),
                      subtitle: Text('Repo: ${issue.repo}'),
                      trailing: Text("State: ${issue.state}"),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}