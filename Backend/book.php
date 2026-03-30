<?php

// ==============================
// 1. READ ENVIRONMENT VARIABLES
// ==============================

$host = getenv("DB_HOST");
$user = getenv("DB_USER");
$pass = getenv("DB_PASS");
$db   = getenv("DB_NAME");

// ==============================
// 2. VALIDATE ENV VARIABLES
// ==============================

if (!$host || !$user || !$db) {
    die("Environment variables not set properly.");
}

// ==============================
// 3. CREATE DATABASE CONNECTION
// ==============================

$conn = new mysqli($host, $user, $pass, $db);

// Check connection
if ($conn->connect_error) {
    die("Database Connection Failed: " . $conn->connect_error);
}

// ==============================
// 4. GET FORM DATA
// ==============================

$name  = $_POST['name'] ?? '';
$email = $_POST['email'] ?? '';

// Validate input
if (empty($name) || empty($email)) {
    die("Invalid input. Name and Email are required.");
}

// ==============================
// 5. INSERT DATA INTO DATABASE
// ==============================

$sql = "INSERT INTO users (name, email) VALUES (?, ?)";

// Use prepared statement (SECURE)
$stmt = $conn->prepare($sql);

if (!$stmt) {
    die("SQL Error: " . $conn->error);
}

$stmt->bind_param("ss", $name, $email);

if ($stmt->execute()) {
    echo "<h2>✅ Ticket Booked Successfully!</h2>";
} else {
    echo "Error: " . $stmt->error;
}

// ==============================
// 6. CLOSE CONNECTION
// ==============================

$stmt->close();
$conn->close();

?>