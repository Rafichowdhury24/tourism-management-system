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
