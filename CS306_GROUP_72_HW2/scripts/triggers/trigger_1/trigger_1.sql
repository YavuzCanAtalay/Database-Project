
DELIMITER $$
CREATE TRIGGER `update_avg_rating` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  UPDATE restaurants
  SET AverageRating = (
    SELECT ROUND(AVG(rating), 1)
    FROM has_view_reviews
    WHERE RestaurantID = NEW.RestaurantID
  )
  WHERE RestaurantID = NEW.RestaurantID;
END
$$
DELIMITER ;


