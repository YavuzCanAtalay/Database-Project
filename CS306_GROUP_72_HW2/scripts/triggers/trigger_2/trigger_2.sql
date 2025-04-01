
DELIMITER $$
CREATE TRIGGER `flag_low_rated_restaurants` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  DECLARE avg_rating DECIMAL(4,2);

  -- Calculate the updated average
  SELECT ROUND(AVG(rating), 2)
  INTO avg_rating
  FROM has_view_reviews
  WHERE RestaurantID = NEW.RestaurantID;

  -- Update the flag based on threshold
  UPDATE restaurants
  SET 
    AverageRating = avg_rating,
    IsFlagged = (avg_rating < 4.0)
  WHERE RestaurantID = NEW.RestaurantID;
END
$$
DELIMITER ;

