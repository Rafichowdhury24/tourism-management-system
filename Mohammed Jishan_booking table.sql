CREATE TABLE bookings (
    booking_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT            NOT NULL,
    package_id      INT,
    hotel_id        INT,
    transport_id    INT,
    booking_date    DATE           NOT NULL,
    check_in_date   DATE,
    check_out_date  DATE,
    num_persons     INT            NOT NULL DEFAULT 1,
    total_amount    DECIMAL(10,2)  NOT NULL,
    status          ENUM('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
    special_request TEXT,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_user      FOREIGN KEY (user_id)      REFERENCES users(user_id)               ON DELETE CASCADE,
    CONSTRAINT fk_booking_package   FOREIGN KEY (package_id)   REFERENCES travel_packages(package_id)  ON DELETE SET NULL,
    CONSTRAINT fk_booking_hotel     FOREIGN KEY (hotel_id)     REFERENCES hotels(hotel_id)             ON DELETE SET NULL,
    CONSTRAINT fk_booking_transport FOREIGN KEY (transport_id) REFERENCES transportation(transport_id) ON DELETE SET NULL
);
CREATE VIEW v_booking_details AS
SELECT
    b.booking_id,
    u.full_name        AS tourist_name,
    u.email            AS tourist_email,
    tp.title           AS package_name,
    h.name             AS hotel_name,
    t.type             AS transport_type,
    t.provider_name    AS transport_provider,
    b.check_in_date,
    b.check_out_date,
    b.num_persons,
    b.total_amount,
    b.status,
    b.created_at
FROM bookings b
JOIN users u           ON b.user_id      = u.user_id
LEFT JOIN travel_packages tp ON b.package_id  = tp.package_id
LEFT JOIN hotels h     ON b.hotel_id     = h.hotel_id
LEFT JOIN transportation t ON b.transport_id = t.transport_id;
