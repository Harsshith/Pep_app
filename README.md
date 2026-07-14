# Employee Management App

A simple, clean, production-ready Employee Management Application. Built with a **Flutter** frontend for multiple platforms (Web, Windows, Android) and a **Node.js + Express** backend persisting data to a local JSON database file.

---

## Tech Stack

### Frontend
- **Flutter** (Latest Stable) & **Dart**
- State Management: **Provider**
- HTTP Client: **http** package for REST API calls
- Architecture: Modular and layered (Constants, Models, Services, Providers, Screens, Widgets)

### Backend
- **Node.js** & **Express.js**
- CORS enabled for cross-origin client requests
- **UUID** package for robust Employee ID generation
- Local File Storage: JSON file (`employees.json`) serving as the database layer

---

## Features
- **Dashboard Summary**: Modern card layouts showing Total Employees, Active Employees, and Inactive Employees.
- **Employee Directory**: Renders all employees in a clean list format with search-by-name query input and filtering dropdowns for Department and Status (Active / Inactive).
- **Employee Details Page**: Clean overview showing contact details (Email, Phone) and work details (Department, Joining Date, unique Employee ID).
- **Add Employee**: Simple entry form with input validation (Name Required, Email format check, 10-digit Phone check, Department/Designation selection).
- **Edit Employee**: Form prefilled with current profile data, allowing details updates via PUT API.
- **Delete Employee**: Instantly remove records with a confirmation prompt window to prevent accidents.

---

## Folder Structure

### Backend
```text
backend/
  controllers/
    employee.controller.js  # Request validation and query param mapping
  data/
    employees.json         # Mock database JSON store
  routes/
    employee.routes.js      # Endpoint routing rules
  services/
    employee.service.js     # Reads/writes JSON files, filters data
  app.js                    # Express setup, middleware, listener
  package.json              # Node dependencies definition
```

### Flutter Frontend
```text
lib/
  core/
    constants/
      colors.dart           # Vibrant blue theme palette
      strings.dart          # Localized copy text and API base URL
      theme.dart            # Unified light MaterialApp3 styles
  models/
    employee_model.dart     # Serialization & copyWith methods
  providers/
    employee_provider.dart  # Provider state controller, error handling
  screens/
    add_employee/           # Create form page
    dashboard/              # Home stats screen
    edit_employee/          # Edit form page
    employee_detail/        # Profile details cards
    employee_list/          # Searchable list with filters
  services/
    api_service.dart        # Reusable HTTP client calls
  widgets/
    custom_button.dart      # Standardized rounded action button
    custom_textfield.dart   # Styled form inputs with prefix icons
    dashboard_card.dart     # Gradient statistics display cards
    employee_card.dart      # Directory listing card
    empty_widget.dart       # Filter reset & empty state fallback
    loading_widget.dart     # Centered loading spinner
  main.dart                 # MultiProvider bootstrap
```

---

## API Documentation

The server runs by default on `http://localhost:3000`.

### Endpoints

#### 1. GET `/dashboard`
Returns total counts for dashboard cards.
- **Response Format**: `200 OK`
```json
{
  "totalEmployees": 5,
  "activeEmployees": 3,
  "inactiveEmployees": 2
}
```

#### 2. GET `/employees`
Fetch list of all employees. Supports filters via URL query parameters.
- **Query Params**:
  - `search`: filters `fullName` (case-insensitive substring)
  - `department`: filters by department category (e.g. `HR`, `Engineering`)
  - `status`: filters status (`Active`, `Inactive`)
- **Example Call**: `/employees?search=john&department=Engineering&status=Active`
- **Response Format**: `200 OK`
```json
[
  {
    "id": "111e4567-e89b-12d3-a456-426614174000",
    "fullName": "John Doe",
    "email": "john.doe@example.com",
    "mobileNumber": "9876543210",
    "department": "Engineering",
    "designation": "Senior Developer",
    "joiningDate": "2025-01-15",
    "status": "Active"
  }
]
```

#### 3. GET `/employees/:id`
Retrieves a specific employee record.
- **Response Format**: `200 OK` or `404 Not Found` if missing.

#### 4. POST `/employees`
Creates a new employee.
- **Body Requirement**:
```json
{
  "fullName": "Alice Smith",
  "email": "alice@example.com",
  "mobileNumber": "9988776655",
  "department": "HR",
  "designation": "Recruiter",
  "joiningDate": "2026-07-13",
  "status": "Active"
}
```
- **Response Format**: `201 Created` returning the saved employee object.

#### 5. PUT `/employees/:id`
Updates fields on an existing employee.
- **Body Requirement**: A JSON map containing fields to modify.
- **Response Format**: `200 OK` containing the updated employee.

#### 6. DELETE `/employees/:id`
Deletes the employee from `employees.json`.
- **Response Format**: `200 OK` with JSON success message.

---

## Setup & Running Instructions

Ensure you have **Flutter SDK** and **Node.js** installed on your system.

### 1. Run the Backend Server
1. Navigate to the `backend` folder:
   ```bash
   cd backend
   ```
2. Install npm packages:
   ```bash
   npm install
   ```
3. Start the server:
   ```bash
   npm start
   ```
   *The console should output: `Server is running on: http://localhost:3000`*

### 2. Run the Flutter Frontend
1. Navigate back to the project root directory:
   ```bash
   cd ..
   ```
2. Fetch Dart dependencies:
   ```bash
   flutter pub get
   ```
3. Start the application on your desired device:
   - **For Chrome (Web)**:
     ```bash
     flutter run -d chrome
     ```
   - **For Windows (Desktop)**:
     ```bash
     flutter run -d windows
     ```
   - **For Android Emulator**:
     *Make sure the emulator is active*
     ```bash
     flutter run
     ```

---

## Application Flow

1. **Dashboard Home**: User lands on the Dashboard showing statistics loaded from `/dashboard`. Action buttons link to the listing or add screen.
2. **Browsing Directory**: Clicking "View All Employees" leads to the list screen (loads `/employees`). User can type to search or select filters. If a search yields no results, the `EmptyWidget` shows up with a reset button.
3. **Registration Form**: Tapping "+" or "Add Employee" opens a form. Fields are checked for formatting. Tapping submit makes a `POST /employees` call. On success, user is navigated back and list auto-refreshes.
4. **Details Inspection**: Tapping the View eye icon on a card loads the `/employees/:id` endpoint and displays the details.
5. **Editing Profiles**: Editing launches a prefilled form. Tapping save calls `PUT /employees/:id` and updates the view.
6. **Deletion dialog**: Deleting triggers a warning alert. Confirming calls `DELETE /employees/:id` and removes the card.

---

## Development Assumptions & Rules
- **Fallback URL**: If running in an Android Emulator, the app routes requests to `10.0.2.2:3000` (which redirects loopback to host localhost), while web/desktop targets default to `localhost:3000`.
- **Data Persistence**: If the JSON database `backend/data/employees.json` is missing or deleted, the backend automatically initializes an empty database list `[]` to prevent crashes.
