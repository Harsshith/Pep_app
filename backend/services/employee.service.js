const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const DATA_PATH = path.join(__dirname, '..', 'data', 'employees.json');

// Helper to read database
function readDatabase() {
  try {
    if (!fs.existsSync(DATA_PATH)) {
      // Ensure parent directories exist
      fs.mkdirSync(path.dirname(DATA_PATH), { recursive: true });
      fs.writeFileSync(DATA_PATH, JSON.stringify([]));
      return [];
    }
    const data = fs.readFileSync(DATA_PATH, 'utf8');
    return JSON.parse(data || '[]');
  } catch (error) {
    console.error('Error reading database:', error);
    return [];
  }
}

// Helper to write database
function writeDatabase(data) {
  try {
    fs.mkdirSync(path.dirname(DATA_PATH), { recursive: true });
    fs.writeFileSync(DATA_PATH, JSON.stringify(data, null, 2), 'utf8');
    return true;
  } catch (error) {
    console.error('Error writing to database:', error);
    return false;
  }
}

class EmployeeService {
  getAll(filters = {}) {
    let employees = readDatabase();
    const { search, department, status } = filters;

    if (search) {
      const searchLower = search.toLowerCase();
      employees = employees.filter(emp => 
        emp.fullName && emp.fullName.toLowerCase().includes(searchLower)
      );
    }

    if (department) {
      employees = employees.filter(emp => 
        emp.department && emp.department.toLowerCase() === department.toLowerCase()
      );
    }

    if (status) {
      employees = employees.filter(emp => 
        emp.status && emp.status.toLowerCase() === status.toLowerCase()
      );
    }

    return employees;
  }

  getById(id) {
    const employees = readDatabase();
    return employees.find(emp => emp.id === id) || null;
  }

  create(employeeData) {
    const employees = readDatabase();
    const newEmployee = {
      id: uuidv4(),
      fullName: employeeData.fullName,
      email: employeeData.email,
      mobileNumber: employeeData.mobileNumber,
      department: employeeData.department,
      designation: employeeData.designation,
      joiningDate: employeeData.joiningDate || new Date().toISOString().split('T')[0],
      status: employeeData.status || 'Active'
    };

    employees.push(newEmployee);
    writeDatabase(employees);
    return newEmployee;
  }

  update(id, employeeData) {
    const employees = readDatabase();
    const index = employees.findIndex(emp => emp.id === id);
    if (index === -1) return null;

    const updatedEmployee = {
      ...employees[index],
      fullName: employeeData.fullName ?? employees[index].fullName,
      email: employeeData.email ?? employees[index].email,
      mobileNumber: employeeData.mobileNumber ?? employees[index].mobileNumber,
      department: employeeData.department ?? employees[index].department,
      designation: employeeData.designation ?? employees[index].designation,
      joiningDate: employeeData.joiningDate ?? employees[index].joiningDate,
      status: employeeData.status ?? employees[index].status
    };

    employees[index] = updatedEmployee;
    writeDatabase(employees);
    return updatedEmployee;
  }

  delete(id) {
    const employees = readDatabase();
    const index = employees.findIndex(emp => emp.id === id);
    if (index === -1) return false;

    employees.splice(index, 1);
    writeDatabase(employees);
    return true;
  }

  getDashboardStats() {
    const employees = readDatabase();
    const totalEmployees = employees.length;
    const activeEmployees = employees.filter(emp => emp.status === 'Active').length;
    const inactiveEmployees = totalEmployees - activeEmployees;

    return {
      totalEmployees,
      activeEmployees,
      inactiveEmployees
    };
  }
}

module.exports = new EmployeeService();
