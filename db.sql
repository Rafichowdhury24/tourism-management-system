
CREATE DATABASE IF NOT EXISTS tourism_management_system;
USE tourism_management_system;

CREATE TABLE admin_activity_log (
  log_id       INT           NOT NULL AUTO_INCREMENT,
  admin_id     INT           NOT NULL,
  action       VARCHAR(100)  NOT NULL,
  target_table VARCHAR(50)   DEFAULT NULL,
  target_id    INT           DEFAULT NULL,
  details      TEXT          DEFAULT NULL,
  acted_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (log_id),
  CONSTRAINT fk_log_admin FOREIGN KEY (admin_id)
    REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE VIEW admin_dashboard_view AS
SELECT
  b.booking_id,
  b.created_at,
  b.total_amount,
  b.status          AS booking_status,
  b.special_request,
  u.user_id,
  u.full_name            AS tourist_name,
  u.email           AS tourist_email,
  u.phone           AS tourist_phone,
  p.package_id,
  p.title           AS package_title,
  p.duration_days,
  p.price           AS package_price,
  d.destination_id,
  d.name            AS destination_name,
  d.city,
  d.country
FROM bookings b
JOIN users         u ON b.user_id        = u.user_id
JOIN travel_packages p ON b.package_id     = p.package_id
JOIN destinations  d ON p.destination_id = d.destination_id;


INSERT INTO admin_activity_log (admin_id, action, target_table, target_id, details)
VALUES
(1, 'CREATE', 'destinations', 1, 'Added new destination Cox''s Bazar'),
(1, 'UPDATE', 'travel_packages', 2, 'Updated price for Sundarbans package'),
(1, 'DELETE', 'hotels', 3, 'Removed inactive hotel record'),
(1, 'CREATE', 'users', 5, 'Created new staff account'),
(1, 'UPDATE', 'bookings', 4, 'Changed booking status to confirmed'),
(1, 'DELETE', 'reviews', 6, 'Deleted inappropriate review'),
(1, 'CREATE', 'transportation', 2, 'Added new flight schedule Dhaka to Cox''s Bazar'),
(1, 'UPDATE', 'hotels', 1, 'Updated hotel price and amenities'),
(1, 'CREATE', 'travel_packages', 7, 'Added Kuakata special tour package'),
(1, 'UPDATE', 'users', 3, 'Verified user email manually');


