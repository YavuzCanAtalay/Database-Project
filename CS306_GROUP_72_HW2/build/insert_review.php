<?php

$servername = "localhost";       
$username = "root";              
$password = "*****"; //I deleted         
$dbname = "cs306";  

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$UserID = $_POST['UserID'];
$RestaurantID = $_POST['RestaurantID'];
$ReviewID = $_POST['reviewID'];
$view_date = $_POST['view_date'];
$rating = $_POST['rating'];
$likes = $_POST['likes'];
$FollowUps = $_POST['FollowUps'];

$sql = "INSERT INTO has_view_reviews (UserID, RestaurantID, reviewID, view_date, rating, likes, FollowUps)
        VALUES (?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("ssissii", $UserID, $RestaurantID, $ReviewID, $view_date, $rating, $likes, $FollowUps);


if ($stmt->execute()) {
    echo "<h3>Review submitted successfully!</h3>";
    echo "<a href='insert_review.html'>Submit another review</a>";
} else {
    echo "<h3>Error: " . $stmt->error . "</h3>";
}

$stmt->close();
$conn->close();
?>
