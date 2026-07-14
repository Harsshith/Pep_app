const express = require('express');
const router = express.Router();
const employeeController = require('../controllers/employee.controller');

// Dashboard statistics
router.get('/dashboard', employeeController.getDashboard);

// Employee CRUD routes
router.get('/employees', employeeController.getEmployees);
router.get('/employees/:id', employeeController.getEmployee);
router.post('/employees', employeeController.createEmployee);
router.put('/employees/:id', employeeController.updateEmployee);
router.delete('/employees/:id', employeeController.deleteEmployee);

module.exports = router;
