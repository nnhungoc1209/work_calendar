import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:work_calendar/models/api_models/event/list_events.dart';

import 'package:work_calendar/models/api_models/event/get_all_events_model.dart';
import 'package:work_calendar/modules/admin/add_new_event_page.dart';
import 'package:work_calendar/modules/admin/edit_event_page.dart';
import 'package:work_calendar/services/download_and_open_file.dart';
import 'package:work_calendar/shared/app_colors.dart';
import 'package:work_calendar/shared/delete_alert.dart';
import 'package:work_calendar/view_models/event/delete_event_view_model.dart';
import 'package:work_calendar/view_models/event/get_all_events_view_model.dart';

class ViewEventPage extends StatefulWidget {

  const ViewEventPage({Key? key}) : super(key: key);

  @override
  State<ViewEventPage> createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {
  ValueNotifier<List<ListEvents>>? _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();

  var getAllEventsModel = GetAllEventsModel();

  // mang event se duoc lay thong qua API
  final List<ListEvents> _events = [];

  @override
  void initState() {
    super.initState();

    init();

  }

  Future<void> init() async {
    var getAllEventsViewModel = GetAllEventsViewModel();
    await getAllEventsViewModel.getAllEvents();

    getAllEventsModel = getAllEventsViewModel.getAllEventsModel;

    //Để _selectedEvents ở đây thì bị null khi render do chưa lấy kịp DL
    // _selectedEvents = ValueNotifier(_getEventsForWeek(_focusedDay));

      setState(() {
      getAllEventsModel.listEvents?.forEach((element) {
        _events.add(element);
      });
    });
  }

  void _startAddNewEvent(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(18.0),
            topLeft: Radius.circular(18.0),
          ),
        ),
        context: context,
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
          ),
          child: const AddNewEventPage(),
        )
    );
  }

  List<ListEvents> _getEventsForWeek(DateTime date){
    //print(date);
    List<ListEvents> events = [];
    DateTime mostRecentMonday = DateTime(date.year, date.month, date.day - (date.weekday - 1));
    //print(mostRecentMonday);
    for(int i = 0; i <= 6; i++) {
      for(var element in _events) {
        if(element.startAt!.year == mostRecentMonday.add(Duration(days: i)).year &&
            element.startAt!.month == mostRecentMonday.add(Duration(days: i)).month &&
            element.startAt!.day == mostRecentMonday.add(Duration(days: i)).day
        ) {
          events.add(element);
        }
      }
    }
    //events.toSet().toList(); giúp loại bỏ các phần tử trùng nhau
    return events;//.toSet().toList();
  }

  List<ListEvents> _getEventsForDay(DateTime date) {
    //print(day);
    // Implementation example
    List<ListEvents> events = [];
    for (var element in _events) {
      //print(element.startDateTime);
      if (element.startAt!.year == date.year && element.startAt!.month == date.month && element.startAt!.day == date.day) {
        events.add(element);
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    _selectedEvents = ValueNotifier(_getEventsForWeek(_focusedDay));
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.24,
            child: TableCalendar<ListEvents>(
              daysOfWeekHeight: 20.0,
              firstDay: DateTime(2010),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              //selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              // rangeStartDay: _rangeStart,
              // rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                headerPadding: EdgeInsets.only(top: 20.0, bottom: 8.0),
                formatButtonVisible: false,
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: AppColors.bluePrimary,
                  shape: BoxShape.circle,
                ),
                markerSize: 4.0,
                markersMaxCount: 6,
                markerMargin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
                markerDecoration: BoxDecoration(
                  color: AppColors.bluePrimary,
                  shape: BoxShape.circle
                )
              ),
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                setState(() {
                  _selectedEvents = ValueNotifier(_getEventsForWeek(focusedDay));
                });
              },
            ),
          ),
          _getEventsForWeek(_focusedDay).isEmpty
          ? Column(
            children: [
              const Text(''
                'No event yet!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400
                ),
              ),
              Image.asset('assets/image/empty.png', width: 280.0, height: 280.0,)
            ],
          )
          : Expanded(
            child: ValueListenableBuilder<List<ListEvents>>(
              valueListenable: _selectedEvents!,
              builder: (context, listEvents, _) {
                return ListView.builder(
                  itemCount: listEvents.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          top: 4.0,
                          bottom: 4.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14.0,
                                      ),
                                      const SizedBox(width: 10.0,),
                                      listEvents[index].startAt?.day != listEvents[index].endAt?.day
                                      ? Text(
                                        '${DateFormat.yMd().format(listEvents[index].startAt ?? DateTime.now())} - '
                                        '${DateFormat.yMd().format(listEvents[index].endAt ?? DateTime.now())} ',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      )
                                      : Text(
                                        '${DateFormat.Hm().format(listEvents[index].startAt ?? DateTime.now())} - '
                                        '${DateFormat.Hm().format(listEvents[index].endAt ?? DateTime.now())} ('
                                        '${(DateFormat.yMd().format(listEvents[index].endAt ?? DateTime.now()))})',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    listEvents[index].title ?? '',
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.place_outlined,
                                        size: 14.0,
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(listEvents[index].venueName.toString())
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.sticky_note_2_outlined,
                                        size: 14.0,
                                      ),
                                      const SizedBox(width: 10.0,),
                                      Text(listEvents[index].note ?? '')
                                    ],
                                  ),
                                ],
                              ),
                              DateTime.now().compareTo(listEvents[index].endAt ?? DateTime.now()) == -1
                                ? Row(
                                children: [
                                  ElevatedButton(
                                    child: const Icon(
                                      Icons.edit,
                                      size: 24,
                                      color: Colors.black87,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                                    ),
                                    // onPressed: () => Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (_) => EditEventPage(editedEvent: listEvents[index]),
                                    //     )
                                    // ),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditEventPage(editedEvent: listEvents[index]),
                                        )
                                      );
                                      print('Init');
                                      init();
                                    }
                                  ),

                                  ElevatedButton(
                                    child: const Icon(
                                      Icons.delete,
                                      size: 24,
                                      color: AppColors.red,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                                    ),
                                    onPressed: () => _showDeleteAlert(listEvents[index].scheduleId ?? 0),
                                  ),
                                ],
                              )
                              : Container()
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.people_alt_outlined,
                                  size: 14.0,
                                ),
                                const SizedBox(width: 10.0,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    listEvents[index].isGeneral == true
                                    ? 'General'
                                    : _getParticipants(listEvents[index].scheduleId ?? 0),
                                  )
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: listEvents[index].content.toString().contains('upload') == true
                                 ? const Text('View content file')
                                 : Container(),
                              onTap: () => DownloadAndOpenFile().openFile(
                               url: 'http://192.168.1.14:8000/api/schedules/' + listEvents[index].scheduleId.toString() + '/download-file',
                               fileName: listEvents[index].content?.substring(8, listEvents[index].content?.length)
                               ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewEvent(context),
      ),
    );
  }

  String _getParticipants(int id) {
    final List<String> participants = [];
    dynamic event = _events.firstWhere((event) => event.scheduleId == id);

    if (event.listEmployees!.isNotEmpty) {
      event.listEmployees?.forEach((element) {
        participants.add(element.fullname.toString());
      });
    }

    if (event.listDepartments!.isNotEmpty) {
      event.listDepartments?.forEach((element) {
        participants.add(element.name.toString());
      });
    }

    String result = participants.toString().substring(participants.toString().lastIndexOf('[') + 1, participants.toString().lastIndexOf(']'));

    return result;
  }

  _showDeleteAlert(int id) {
    CustomDeleteAlert().deleteAlert(
      context: context,
      item: 'event',
      cancelFunction: () {
        Navigator.pop(context);
      },
      yesFunction: () => _onDeleteEventPressed(id));
  }

  Future<void> _onDeleteEventPressed(int id) async {
    Navigator.pop(context);
    var deleteEventViewModel = DeleteEventViewModel();
    await deleteEventViewModel.deleteEvent(id);
    setState(() {
      _events.removeWhere((event) => event.scheduleId == id);
    });
  }
}


