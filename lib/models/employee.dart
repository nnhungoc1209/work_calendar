class Employee {
  final int id;
  final String fullName;
  final String? username;
  final String? phoneNumber;

  Employee({required this.id, required this.fullName, this.username, this.phoneNumber});
}