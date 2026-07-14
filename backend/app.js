const express = require('express');
const cors = require('cors');
const employeeRoutes = require('./routes/employee.routes');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for all requests (important for Flutter Web / Desktop communication)
app.use(cors());

// Parse JSON request bodies
app.use(express.json());

// Log incoming API requests
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Root check endpoint
app.get('/', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Employee Management API is running' });
});

// Register routes (mount at root directory or API root - we will mount directly at root '/' as requested by the API paths e.g. GET /dashboard, GET /employees)
app.use('/', employeeRoutes);

// Global Error Handler
app.use((err, req, res, next) => {
  console.error('Unhandled Server Error:', err);
  res.status(500).json({ message: 'Something went wrong on the server!' });
});

// Start Server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`=============================================`);
  console.log(` Employee Management Backend Server Started `);
  console.log(` Server is running on: http://localhost:${PORT}`);
  console.log(`=============================================`);
});
