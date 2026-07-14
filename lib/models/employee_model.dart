class Employee {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String department;
  final String designation;
  final String joiningDate;
  final String status;

  Employee({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.department,
    required this.designation,
    required this.joiningDate,
    required this.status,
  });

  // Factory constructor to parse JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      joiningDate: json['joiningDate'] ?? '',
      status: json['status'] ?? 'Active',
    );
  }

  // Convert Employee to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'mobileNumber': mobileNumber,
      'department': department,
      'designation': designation,
      'joiningDate': joiningDate,
      'status': status,
    };
  }

  // Create a copy of Employee with some updated fields
  Employee copyWith({
    String? id,
    String? fullName,
    String? email,
    String? mobileNumber,
    String? department,
    String? designation,
    String? joiningDate,
    String? status,
  }) {
    return Employee(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      joiningDate: joiningDate ?? this.joiningDate,
      status: status ?? this.status,
    );
  }
}
