import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:work_calendar/models/api_models/department/get_all_departments_model.dart';
import 'package:work_calendar/models/api_models/employee/get_all_employees_model.dart';
import 'package:work_calendar/models/api_models/event/list_departments.dart';
import 'package:work_calendar/models/api_models/event/list_employees.dart';
import 'package:work_calendar/models/api_models/event/list_events.dart';
import 'package:work_calendar/models/api_models/venue/get_all_venues_model.dart';
import 'package:work_calendar/models/api_models/venue/list_venues.dart';
import 'package:work_calendar/modules/admin/view_event_page.dart';
import 'package:work_calendar/shared/app_colors.dart';
import 'package:work_calendar/view_models/department/get_all_departments_view_model.dart';
import 'package:work_calendar/view_models/employee/get_all_employees_view_model.dart';
import 'package:work_calendar/view_models/event/edit_event_view_model.dart';
import 'package:work_calendar/view_models/venue/get_all_venues_view_model.dart';

class EditEventPage extends StatefulWidget {
  final ListEvents editedEvent;
  const EditEventPage({Key? key, required this.editedEvent}) : super(key: key);

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final TextEditingController _txtTitleController = TextEditingController();
  final TextEditingController _txtGuestController = TextEditingController();
  final TextEditingController _txtNoteController = TextEditingController();
  final TextEditingController _txtStartTimeController = TextEditingController();
  final TextEditingController _txtEndTimeController = TextEditingController();
  FilePickerResult? _contentFile;
  bool _isGeneral = false;
  String? _contentFileName;

  String? _errorTitleText = '';
  String? _errorStartTimeText = '';
  String? _errorEndTimeText = '';

  final List<dynamic> _employeesList = [];

  final List<dynamic> _departmentsList = [];

  final List<dynamic> _venuesList = [];

  List<dynamic>? _selectedEmployeesList = [];
  List<dynamic>? _selectedDepartmentsList = [];
  ListVenues? _selectedVenues;

  String _previousEmployeesList = '';
  String _previousDepartmentsList = '';

  var getAllEmployeesModel = GetAllEmployeesModel();
  var getAllDepartmentsModel = GetAllDepartmentsModel();
  var getAllVenuesModel = GetAllVenuesModel();

  @override
  void initState() {
    super.initState();

    init();

    _errorTitleText = null;
    _errorStartTimeText = null;
    _errorEndTimeText = null;
  }

  Future<void> init() async {
    var getAllEmployeesViewModel = GetAllEmployeesViewModel();
    await getAllEmployeesViewModel.getAllEmployees();
    getAllEmployeesModel = getAllEmployeesViewModel.getAllEmployeesModel;

    var getAllDepartmentsViewModel = GetAllDepartmentsViewModel();
    await getAllDepartmentsViewModel.getAllDepartments();
    getAllDepartmentsModel = getAllDepartmentsViewModel.getAllDepartmentsModel;

    var getAllVenuesViewModel = GetAllVenuesViewModel();
    await getAllVenuesViewModel.getAllVenues();
    getAllVenuesModel = getAllVenuesViewModel.getAllVenuesModel;

    setState(() {
      getAllEmployeesModel.listEmployees?.forEach((element) {
        _employeesList.add(element);
      });

      getAllDepartmentsModel.listDepartments?.forEach((element) {
        _departmentsList.add(element);
      });

      getAllVenuesModel.listVenues?.forEach((element) {
        _venuesList.add(element);
      });

      _txtTitleController.text = widget.editedEvent.title!;
      _txtGuestController.text = widget.editedEvent.guest ?? '';
      _txtNoteController.text = widget.editedEvent.note ?? '';
      if(widget.editedEvent.content!.isNotEmpty) {
        _contentFileName = widget.editedEvent.content?.substring(7, widget.editedEvent.content?.length);
      }
      dynamic index = _venuesList.firstWhere((element) => element.venueId == widget.editedEvent.venueId);
      _selectedVenues = index;
      _selectedEmployeesList = widget.editedEvent.listEmployees;
      _selectedEmployeesList?.forEach((element) {
        _previousEmployeesList += ' ' + element.fullname!;
      });

      _selectedDepartmentsList = widget.editedEvent.listDepartments;
      _selectedDepartmentsList?.forEach((element) {
        _previousDepartmentsList += ' ' + element.name;
      });

      var formatter = DateFormat('dd-MM-yyyy HH:mm');
      _txtStartTimeController.text = formatter.format(widget.editedEvent.startAt!);
      _txtEndTimeController.text = formatter.format(widget.editedEvent.endAt!);

    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.editedEvent.toJson());

    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            //color: Colors.cyan,
            padding: EdgeInsets.only(
              top: widthScreen * 0.05,
              left: widthScreen * 0.05,
              right: widthScreen * 0.05
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Text(
                  'Edit Event',
                  style: TextStyle(
                    fontSize: 28,
                    color: AppColors.bluePrimary,
                  ),
                ),
                _getTextFormFieldWidget(textController: _txtTitleController, errorText: _errorTitleText, lableText: 'Title'),
                SizedBox(height: widthScreen * 0.04),

                _getTextFormFieldWidget(textController: _txtGuestController, maxLenght: 80, lableText: 'Guest'),
                SizedBox(height: widthScreen * 0.04),

                _getTextFormFieldWidget(textController: _txtNoteController, maxLenght: 80, lableText: 'Note'),
                SizedBox(height: widthScreen * 0.04),

                _getFilePickerWidget(),
                SizedBox(height: widthScreen * 0.04),

                _getIsGeneralWidget(),
                SizedBox(height: widthScreen * 0.04),

                _getVenueSelectWidget(_venuesList),
                SizedBox(height: widthScreen * 0.04),

                _getMultiSelectWidget(_employeesList, 'Select Emloyees List', 'Employees'),
                SizedBox(height: widthScreen * 0.04),

                _getMultiSelectWidget(_departmentsList, 'Select Departments List', 'Departments'),
                SizedBox(height: widthScreen * 0.04),

                Row(
                  children: [
                    Expanded(
                      child: _getDateTimePickerWidget('Start Datetime', _txtStartTimeController, _errorStartTimeText, 'StartAt'),
                    ),
                    SizedBox(width: widthScreen * 0.02),
                    Expanded(
                      child: _getDateTimePickerWidget('End Datetime', _txtEndTimeController, _errorEndTimeText, 'EndAt'),
                    ),
                  ],
                ),
                 _getEditButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIsGeneralWidget() {
    return Row(
      children: [
        const Text(
          'General',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Switch(
            value: widget.editedEvent.isGeneral ?? false,
            onChanged: (value) {
              setState(() {
                _isGeneral = value;
              });
            }
        )
      ],
    );
  }

  Widget _getDateTimePickerWidget(String hintText, TextEditingController timeController, String? errorText, String? lableText) {
    return DateTimeField(
      controller: timeController,
      decoration: InputDecoration(
        labelText: lableText,
        errorText: errorText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.bluePrimary,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.bluePrimary,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.titleText,
        ),
        suffixIcon: const Icon(Icons.date_range),
      ),
      format: DateFormat('dd-MM-yyyy HH:mm'),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          print(DateTimeField.combine(date, time).toString());
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }


  Widget _getTextFormFieldWidget({required TextEditingController textController, int? maxLine, int? maxLenght, String? errorText, String? lableText}) {
    return TextFormField(
      controller: textController,
      keyboardType: TextInputType.multiline,
      maxLines: maxLine,
      maxLength: maxLenght,
      decoration: InputDecoration(
        labelText: lableText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorText: errorText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.bluePrimary,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.bluePrimary,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        hintStyle: const TextStyle(
            fontSize: 15,
            color: AppColors.titleText
        ),
      ),
    );
  }

  Widget _getVenueSelectWidget(List<dynamic> venuesList) {
    print(widget.editedEvent.venueName);
    if (venuesList.isNotEmpty) {
      return (
        DropdownButtonFormField(
          value: _selectedVenues,
          onChanged: (ListVenues? newValue) {
            setState(() {
              _selectedVenues = newValue!;
            });
          },
          items: venuesList.map((item) => DropdownMenuItem<ListVenues>(value: item, child: Text(item.name))).toList(),
          decoration: const InputDecoration(
            labelText: 'Venue',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: widget.editedEvent.venueName,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.bluePrimary,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.bluePrimary,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        )
      );
    } else {
      return const Text('Loading...');
    }
  }

  Widget _getMultiSelectWidget(List<dynamic> itemsList, String title, String buttonText) {
    // print(itemsList[0]);
    return (itemsList.isNotEmpty) ? (
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiSelectDialogField(
              buttonText: Text(
                buttonText,
                style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.titleText
                ),
              ),
              title: Text(title),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: AppColors.bluePrimary,
                  width: 1,
                ),
              ),
              chipDisplay: MultiSelectChipDisplay(
                chipColor: AppColors.background,
                textStyle: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              items: (itemsList[0] is ListEmployees)
                  ? itemsList.map((item) => MultiSelectItem<ListEmployees>(item, item.fullname)).toList()
                  : itemsList.map((item) => MultiSelectItem<ListDepartments>(item, item.name)).toList(),
              onConfirm: (results) {
                if(itemsList[0] is ListEmployees) {
                  setState(() {
                    _previousEmployeesList = '';
                    _selectedEmployeesList = results ?? [];
                  });
                } else {
                  setState(() {
                    _previousDepartmentsList = '';
                    _selectedDepartmentsList = results ?? [];
                  });
                }
              },
            ),
            itemsList[0] is ListEmployees
            ? Text(_previousEmployeesList, textAlign: TextAlign.left,)
            : Text(_previousDepartmentsList, textAlign: TextAlign.left,),
          ],
        )
    ) : const Text('Loading...');
  }

  Widget _getFilePickerWidget() {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          onTap: _onPickFilePressed,
          decoration: const InputDecoration(
            hintText: 'Choose content file',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.bluePrimary,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.bluePrimary,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _contentFileName == null
                      ? 'No file choosen'
                      : _contentFileName ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              _contentFileName == null
                  ? Container()
                  : GestureDetector(
                child: const Icon(
                  Icons.close,
                  color: AppColors.red,
                ),
                onTap: () {
                  setState(() {
                    _contentFileName = null;
                    _contentFile = null;
                  });
                },
              )
            ]
          ),
        )
      ],
    );
  }

  void _onPickFilePressed() async {
    _contentFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );
    if(_contentFile == null) {
      return;
    } else {
      print(_contentFile?.files.first.name);
      setState(() {
        _contentFileName  = _contentFile?.files.first.name;
      });
    }
  }

  Widget _getEditButtonWidget() {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.05,
        bottom: MediaQuery.of(context).size.width * 0.05,
      ),
      child: ElevatedButton(
          onPressed: _onEditEventPressed,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.07,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
              bottom: MediaQuery.of(context).size.width * 0.04,
            ),
            child: const Text(
              'Edit Event',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          )
      ),
    );
  }

  bool validate() {
    bool isValid = true;

    if(_txtTitleController.text.isEmpty) {
      setState(() {
        _errorTitleText = 'Title is required';
      });
      isValid = false;
    }

    if(_txtStartTimeController.text.isEmpty) {
      setState(() {
        _errorStartTimeText = 'Required field';
      });
      isValid = false;
    }

    if(_txtEndTimeController.text.isEmpty) {
      setState(() {
        _errorEndTimeText = 'Required field';
      });
      isValid = false;
    }

    if(DateFormat('dd-MM-yyyy HH:mm').parse(_txtEndTimeController.text).compareTo(DateFormat('dd-MM-yyyy HH:mm').parse(_txtStartTimeController.text)) == -1) {
      setState(() {
        _errorEndTimeText = 'Invalid value';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _onEditEventPressed() async {
    var editEventViewModel = EditEventViewModel();
    String title = _txtTitleController.text;
    String guest = _txtGuestController.text;
    String note = _txtNoteController.text;
    String startAt = _txtStartTimeController.text;
    String endAt = _txtEndTimeController.text;

    print(title + guest + note + startAt + endAt + _selectedEmployeesList.toString() + _selectedDepartmentsList.toString());

    if(validate()) {await editEventViewModel.editEvent(widget.editedEvent.scheduleId, title, guest, note, _isGeneral, startAt, endAt, _selectedEmployeesList!, _selectedDepartmentsList!, _contentFile, _selectedVenues!.venueId ?? 0);

      if(editEventViewModel.error == ''){
        Navigator.pop(context);
      }
    }
  }
}
