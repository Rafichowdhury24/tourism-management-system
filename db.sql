
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
)

CREATE VIEW admin_dashboard_view AS
SELECT
  b.booking_id,
  b.booked_at,
  b.travel_date,
  b.num_travelers,
  b.total_price,
  b.status          AS booking_status,
  b.special_request,
  u.user_id,
  u.name            AS tourist_name,
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
JOIN tour_packages p ON b.package_id     = p.package_id
JOIN destinations  d ON p.destination_id = d.destination_id;

