    <?php
    // Database credentials
    $host = "localhost";
    $username = "";
    $password = "";
    $database = "";
    // Create connection
    $conn = new mysqli($host, $username, $password, $database);
    // Check connection
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }
    // Example query
    $sql = "SELECT * FROM your_table";
    $result = $conn->query($sql);
    $data = array();
    if ($result->num_rows > 0) {
      // Fetch data
      while($row = $result->fetch_assoc()) {
        $data[] = $row;
      }
    }
    // Close connection
    $conn->close();
    // Encode data as JSON
    header('Content-Type: application/json');
    echo json_encode($data);
    ?>