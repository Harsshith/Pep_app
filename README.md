 # 👨‍💼 Employee Management System

A modern **Employee Management System** built using **Flutter** and **Node.js + Express**. The application allows organizations to manage employee records with a clean UI, RESTful APIs, and JSON-based local storage.

---

# 🚀 Tech Stack

## 🎨 Frontend
- Flutter (Latest Stable)
- Dart
- Provider (State Management)
- HTTP Package (REST API)
- Material 3 UI

## ⚙️ Backend
- Node.js
- Express.js
- UUID
- CORS
- JSON File Database

---

# ✨ Features

## 📊 Dashboard
- Total Employees
- Active Employees
- Inactive Employees
- Beautiful Dashboard Cards

## 👥 Employee Management
- View Employee List
- Add Employee
- Edit Employee
- Delete Employee
- Employee Details Page

## 🔍 Search & Filter
- Search by Employee Name
- Filter by Department
- Filter by Status
- Reset Filters

## ✅ Form Validation
- Required Name
- Valid Email
- 10-Digit Mobile Number
- Department Selection
- Designation Selection
- Joining Date
- Employee Status

---

# 📂 Project Structure

## Backend

```text
backend/
│
├── controllers/
│   └── employee.controller.js
│
├── routes/
│   └── employee.routes.js
│
├── services/
│   └── employee.service.js
│
├── data/
│   └── employees.json
│
├── app.js
└── package.json
```

## Flutter

```text
lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
│
├── models/
│
├── providers/
│
├── services/
│
├── screens/
│   ├── dashboard/
│   ├── employee_list/
│   ├── employee_detail/
│   ├── add_employee/
│   └── edit_employee/
│
├── widgets/
│
└── main.dart
```

---

# 🌐 REST API

## Dashboard

### GET `/dashboard`

Returns dashboard statistics.

```json
{
  "totalEmployees": 15,
  "activeEmployees": 12,
  "inactiveEmployees": 3
}
```

---

## Get All Employees

### GET `/employees`

Supports:

- search
- department
- status

Example

```
GET /employees?search=John&department=HR&status=Active
```

---

## Get Employee

### GET `/employees/:id`

Returns employee details.

---

## Add Employee

### POST `/employees`

```json
{
  "fullName": "John Doe",
  "email": "john@gmail.com",
  "mobileNumber": "9876543210",
  "department": "Engineering",
  "designation": "Developer",
  "joiningDate": "2026-07-13",
  "status": "Active"
}
```

---

## Update Employee

### PUT `/employees/:id`

Updates employee information.

---

## Delete Employee

### DELETE `/employees/:id`

Deletes an employee.

---

# ▶️ Installation

## Clone Repository

```bash
git clone https://github.com/yourusername/employee-management-system.git
```

```bash
cd employee-management-system
```

---

# 🔹 Backend Setup

Move to backend

```bash
cd backend
```

Install packages

```bash
npm install
```

Start server

```bash
npm start
```

Server

```
http://localhost:3000
```

---

# 🔹 Flutter Setup

Move to project root

```bash
cd ..
```

Install packages

```bash
flutter pub get
```

Run for Chrome

```bash
flutter run -d chrome
```

Run for Windows

```bash
flutter run -d windows
```

Run for Android

```bash
flutter run
```

---

# 📱 Application Workflow

### Dashboard
Displays

- Total Employees
- Active Employees
- Inactive Employees

↓

### Employee List

- Search Employees
- Filter Employees
- View Employee Details

↓

### Add Employee

- Fill Form
- Validation
- Save Employee

↓

### Employee Details

- View Complete Information

↓

### Edit Employee

- Update Information

↓

### Delete Employee

- Confirmation Dialog
- Delete Record

---

# 📌 Development Notes

- Uses localhost on Web & Windows.
- Uses 10.0.2.2 for Android Emulator.
- Automatically creates `employees.json` if it does not exist.
- Data is stored locally in JSON format.

---

# 📸 Screenshots

Add screenshots here.

```
assets/screenshots/dashboard.png
assets/screenshots/list.png
assets/screenshots/details.png
assets/screenshots/add.png
```

---

# 📈 Future Enhancements

- MongoDB Integration
- Authentication (JWT)
- Role-Based Access
- Pagination
- Export PDF
- Excel Export
- Dark Mode
- Image Upload
- Notifications

---

# 👨‍💻 Author

**Harsshhi**

Flutter Developer | Full Stack Developer

---

# ⭐ If you like this project, don't forget to Star the Repository.
