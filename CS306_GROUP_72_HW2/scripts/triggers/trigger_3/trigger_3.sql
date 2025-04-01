
DELIMITER $$
CREATE TRIGGER `TriggerReputationOnLikesandFollowUps` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  CALL UpdateUserReputation(NEW.UserID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TriggerReputationOnMark` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  CALL UpdateUserReputation(NEW.UserID);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `TriggerReputationOnReviews` AFTER INSERT ON `has_view_reviews` FOR EACH ROW BEGIN
  CALL UpdateUserReputation(NEW.UserID);
END

DELIMITER ;

