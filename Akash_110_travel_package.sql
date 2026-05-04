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
INSERT INTO travel_packages (destination_id, title, price, duration_days, inclusions) VALUES
(1, "Cox's Bazar 3 Days Tour",   7500.00, 3, 'Hotel, Breakfast, Guide, Transport'),
(2, 'Sundarbans Adventure 4D3N', 12000.00, 4, 'Boat, Hotel, All Meals, Guide'),
(3, 'Sajek Valley 2 Days Trip',  6500.00, 2, 'Hotel, Dinner, Guide'),
(4, 'Kuakata Sunrise Package',   5000.00, 2, 'Hotel, Breakfast, Transport');