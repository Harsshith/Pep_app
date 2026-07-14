const employeeService = require('../services/employee.service');

class EmployeeController {
  getEmployees(req, res) {
    try {
      const { search, department, status } = req.query;
      const employees = employeeService.getAll({ search, department, status });
      return res.status(200).json(employees);
    } catch (error) {
      console.error('Error getting employees:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }

  getEmployee(req, res) {
    try {
      const { id } = req.params;
      const employee = employeeService.getById(id);
      if (!employee) {
        return res.status(404).json({ message: 'Employee not found' });
      }
      return res.status(200).json(employee);
    } catch (error) {
      console.error('Error getting employee:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }

  createEmployee(req, res) {
    try {
      const { fullName, email, mobileNumber, department, designation, joiningDate, status } = req.body;

      // Request validations
      if (!fullName) return res.status(400).json({ message: 'Full name is required' });
      if (!email) return res.status(400).json({ message: 'Email address is required' });
      if (!mobileNumber) return res.status(400).json({ message: 'Mobile number is required' });
      if (!department) return res.status(400).json({ message: 'Department is required' });
      if (!designation) return res.status(400).json({ message: 'Designation is required' });

      // Validate email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        return res.status(400).json({ message: 'Invalid email address format' });
      }

      // Validate mobile number format (10 digits)
      const mobileRegex = /^\d{10}$/;
      if (!mobileRegex.test(mobileNumber)) {
        return res.status(400).json({ message: 'Mobile number must be exactly 10 digits' });
      }

      const newEmployee = employeeService.create({
        fullName,
        email,
        mobileNumber,
        department,
        designation,
        joiningDate,
        status
      });

      return res.status(201).json(newEmployee);
    } catch (error) {
      console.error('Error creating employee:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }

  updateEmployee(req, res) {
    try {
      const { id } = req.params;
      const { fullName, email, mobileNumber, department, designation, joiningDate, status } = req.body;

      // Validations if updating
      if (fullName === '') return res.status(400).json({ message: 'Full name cannot be empty' });
      if (email === '') return res.status(400).json({ message: 'Email address cannot be empty' });
      if (mobileNumber === '') return res.status(400).json({ message: 'Mobile number cannot be empty' });
      if (department === '') return res.status(400).json({ message: 'Department cannot be empty' });
      if (designation === '') return res.status(400).json({ message: 'Designation cannot be empty' });

      if (email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
          return res.status(400).json({ message: 'Invalid email address format' });
        }
      }

      if (mobileNumber) {
        const mobileRegex = /^\d{10}$/;
        if (!mobileRegex.test(mobileNumber)) {
          return res.status(400).json({ message: 'Mobile number must be exactly 10 digits' });
        }
      }

      const updated = employeeService.update(id, {
        fullName,
        email,
        mobileNumber,
        department,
        designation,
        joiningDate,
        status
      });

      if (!updated) {
        return res.status(404).json({ message: 'Employee not found' });
      }

      return res.status(200).json(updated);
    } catch (error) {
      console.error('Error updating employee:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }

  deleteEmployee(req, res) {
    try {
      const { id } = req.params;
      const isDeleted = employeeService.delete(id);
      if (!isDeleted) {
        return res.status(404).json({ message: 'Employee not found' });
      }
      return res.status(200).json({ message: 'Employee deleted successfully' });
    } catch (error) {
      console.error('Error deleting employee:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }

  getDashboard(req, res) {
    try {
      const stats = employeeService.getDashboardStats();
      return res.status(200).json(stats);
    } catch (error) {
      console.error('Error getting dashboard stats:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }
}

module.exports = new EmployeeController();
