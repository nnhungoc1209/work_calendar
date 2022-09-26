class Event {
  final int id;
  final String title;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String content;
  final String? guest;
  final String? note;
  final bool isGeneral;
  final List<String>? employeeList;
  final List<String>? departmentList;

  Event(
      {
        required this.id,
        required this.title,
        required this.startDateTime,
        required this.endDateTime,
        required this.content,
        this.guest,
        this.note,
        required this.isGeneral,
        this.employeeList,
        this.departmentList,
      }
      );
}