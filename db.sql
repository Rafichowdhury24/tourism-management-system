-- ============================================================
--  Tourism Management System - Database Schema
--  Southeast University | CSE384.9 | Group 3
-- ============================================================

CREATE DATABASE IF NOT EXISTS tourism_management_system;
USE tourism_management_system;

-- ============================================================
-- 1. USERS TABLE
-- ============================================================
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100)        NOT NULL,
    email         VARCHAR(150)        NOT NULL UNIQUE,
    password_hash VARCHAR(255)        NOT NULL,
    phone         VARCHAR(20),
    address       TEXT,
    profile_pic   VARCHAR(255),
    role          ENUM('tourist','admin','staff') NOT NULL DEFAULT 'tourist',
    is_verified   TINYINT(1)          NOT NULL DEFAULT 0,
    created_at    DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. DESTINATIONS TABLE
-- ============================================================
CREATE TABLE destinations (
    destination_id   INT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(150)  NOT NULL,
    country          VARCHAR(100)  NOT NULL,
    city             VARCHAR(100),
    description      TEXT,
    image_url        VARCHAR(255),
    best_season      VARCHAR(100),
    avg_rating       DECIMAL(3,2)  DEFAULT 0.00,
    is_active        TINYINT(1)    NOT NULL DEFAULT 1,
    created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 3. TRAVEL PACKAGES TABLE
-- ============================================================
CREATE TABLE travel_packages (
    package_id      INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT            NOT NULL,
    title           VARCHAR(200)   NOT NULL,
    description     TEXT,
    price           DECIMAL(10,2)  NOT NULL,
    duration_days   INT            NOT NULL,
    max_capacity    INT            NOT NULL DEFAULT 20,
    inclusions      TEXT,          -- e.g., meals, guide, transport
    image_url       VARCHAR(255),
    is_active       TINYINT(1)     NOT NULL DEFAULT 1,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pkg_dest FOREIGN KEY (destination_id)
        REFERENCES destinations(destination_id) ON DELETE CASCADE
);

-- ============================================================
-- 4. HOTELS TABLE
-- ============================================================
CREATE TABLE hotels (
    hotel_id        INT AUTO_INCREMENT PRIMARY KEY,
    destination_id  INT            NOT NULL,
    name            VARCHAR(150)   NOT NULL,
    address         TEXT,
    star_rating     TINYINT        CHECK (star_rating BETWEEN 1 AND 5),
    price_per_night DECIMAL(10,2)  NOT NULL,
    total_rooms     INT            NOT NULL DEFAULT 10,
    amenities       TEXT,
    image_url       VARCHAR(255),
    contact_phone   VARCHAR(20),
    contact_email   VARCHAR(150),
    is_active       TINYINT(1)     NOT NULL DEFAULT 1,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_hotel_dest FOREIGN KEY (destination_id)
        REFERENCES destinations(destination_id) ON DELETE CASCADE
);

-- ============================================================
-- 5. TRANSPORTATION TABLE
-- ============================================================
CREATE TABLE transportation (
    transport_id    INT AUTO_INCREMENT PRIMARY KEY,
    type            ENUM('bus','train','flight','boat','car') NOT NULL,
    provider_name   VARCHAR(150)   NOT NULL,
    origin          VARCHAR(150)   NOT NULL,
    destination     VARCHAR(150)   NOT NULL,
    departure_time  DATETIME       NOT NULL,
    arrival_time    DATETIME       NOT NULL,
    price           DECIMAL(10,2)  NOT NULL,
    available_seats INT            NOT NULL DEFAULT 50,
    is_active       TINYINT(1)     NOT NULL DEFAULT 1,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 6. BOOKINGS TABLE
-- ============================================================
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

-- ============================================================
-- 7. PAYMENTS TABLE
-- ============================================================
CREATE TABLE payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT            NOT NULL,
    user_id         INT            NOT NULL,
    amount          DECIMAL(10,2)  NOT NULL,
    method          ENUM('credit_card','debit_card','mobile_banking','cash') NOT NULL,
    transaction_ref VARCHAR(100)   UNIQUE,
    status          ENUM('pending','success','failed','refunded') NOT NULL DEFAULT 'pending',
    paid_at         DATETIME,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pay_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_pay_user    FOREIGN KEY (user_id)    REFERENCES users(user_id)       ON DELETE CASCADE
);

-- ============================================================
-- 8. REVIEWS TABLE
-- ============================================================
CREATE TABLE reviews (
    review_id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT            NOT NULL,
    destination_id  INT,
    package_id      INT,
    hotel_id        INT,
    rating          TINYINT        NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         TEXT,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rev_user    FOREIGN KEY (user_id)       REFERENCES users(user_id)              ON DELETE CASCADE,
    CONSTRAINT fk_rev_dest    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id) ON DELETE SET NULL,
    CONSTRAINT fk_rev_pkg     FOREIGN KEY (package_id)    REFERENCES travel_packages(package_id) ON DELETE SET NULL,
    CONSTRAINT fk_rev_hotel   FOREIGN KEY (hotel_id)      REFERENCES hotels(hotel_id)            ON DELETE SET NULL
);

-- ============================================================
-- 9. NOTIFICATIONS TABLE
-- ============================================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT            NOT NULL,
    title           VARCHAR(200)   NOT NULL,
    message         TEXT           NOT NULL,
    type            ENUM('booking','payment','promo','update') NOT NULL DEFAULT 'update',
    is_read         TINYINT(1)     NOT NULL DEFAULT 0,
    created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- 10. STAFF ROLES TABLE
-- ============================================================
CREATE TABLE staff_roles (
    role_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT            NOT NULL UNIQUE,
    role_name       VARCHAR(100)   NOT NULL,
    permissions     TEXT,          -- JSON string or comma-separated list
    assigned_at     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_staff_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================
CREATE INDEX idx_bookings_user    ON bookings(user_id);
CREATE INDEX idx_bookings_status  ON bookings(status);
CREATE INDEX idx_payments_booking ON payments(booking_id);
CREATE INDEX idx_reviews_dest     ON reviews(destination_id);
CREATE INDEX idx_pkg_dest         ON travel_packages(destination_id);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Admin user (password: admin123 - hashed)
INSERT INTO users (full_name, email, password_hash, role, is_verified)
VALUES ('Admin', 'admin@tourism.com', SHA2('admin123', 256), 'admin', 1);

-- Sample destinations
INSERT INTO destinations (name, country, city, description, best_season) VALUES
('Cox''s Bazar',     'Bangladesh', 'Cox''s Bazar', 'World''s longest natural sea beach.',          'October - March'),
('Sundarbans',       'Bangladesh', 'Khulna',       'Largest mangrove forest, home of Royal Bengal Tiger.', 'November - February'),
('Sajek Valley',     'Bangladesh', 'Rangamati',    'Beautiful hill track valley with scenic views.', 'October - April'),
('Kuakata',          'Bangladesh', 'Patuakhali',   'Panoramic sea beach; see both sunrise and sunset.', 'November - March');

-- Sample travel packages
INSERT INTO travel_packages (destination_id, title, price, duration_days, inclusions) VALUES
(1, "Cox's Bazar 3 Days Tour",   7500.00, 3, 'Hotel, Breakfast, Guide, Transport'),
(2, 'Sundarbans Adventure 4D3N', 12000.00, 4, 'Boat, Hotel, All Meals, Guide'),
(3, 'Sajek Valley 2 Days Trip',  6500.00, 2, 'Hotel, Dinner, Guide'),
(4, 'Kuakata Sunrise Package',   5000.00, 2, 'Hotel, Breakfast, Transport');

-- Sample hotels
INSERT INTO hotels (destination_id, name, star_rating, price_per_night, total_rooms) VALUES
(1, 'Ocean Pearl Hotel',      4, 3500.00, 50),
(1, 'Sea Crown Guest House',  3, 1500.00, 30),
(2, 'Sundarban Eco Resort',   3, 2500.00, 20),
(3, 'Sajek Cloud Valley Inn', 3, 2000.00, 25);

-- Sample transportation
INSERT INTO transportation (type, provider_name, origin, destination, departure_time, arrival_time, price, available_seats) VALUES
('bus',    'Green Line',    'Dhaka',   'Cox''s Bazar', '2025-06-01 22:00:00', '2025-06-02 07:00:00',  900.00, 40),
('flight', 'Biman BD',     'Dhaka',   'Cox''s Bazar', '2025-06-01 08:00:00', '2025-06-01 09:00:00', 4500.00, 120),
('bus',    'Hanif Express', 'Dhaka',   'Khulna',       '2025-06-05 07:00:00', '2025-06-05 14:00:00',  700.00, 45),
('boat',   'BIWTC',        'Khulna',  'Sundarbans',   '2025-06-06 08:00:00', '2025-06-06 12:00:00',  500.00, 60);

-- ============================================================
-- USEFUL VIEWS
-- ============================================================

-- View: Full booking details
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

-- View: Revenue report
CREATE VIEW v_revenue_report AS
SELECT
    DATE(p.paid_at)   AS payment_date,
    COUNT(p.payment_id) AS total_transactions,
    SUM(p.amount)     AS total_revenue,
    p.method          AS payment_method
FROM payments p
WHERE p.status = 'success'
GROUP BY DATE(p.paid_at), p.method;

-- View: Popular destinations by bookings
CREATE VIEW v_popular_destinations AS
SELECT
    d.name             AS destination,
    d.country,
    COUNT(b.booking_id) AS total_bookings,
    AVG(r.rating)       AS avg_rating
FROM destinations d
LEFT JOIN travel_packages tp ON d.destination_id = tp.destination_id
LEFT JOIN bookings b          ON tp.package_id    = b.package_id
LEFT JOIN reviews r           ON d.destination_id = r.destination_id
GROUP BY d.destination_id
ORDER BY total_bookings DESC;
