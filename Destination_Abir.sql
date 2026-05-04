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

INSERT INTO destinations (name, country, city, description, best_season) VALUES
('Cox''s Bazar',     'Bangladesh', 'Cox''s Bazar', 'World''s longest natural sea beach.',          'October - March'),
('Sundarbans',       'Bangladesh', 'Khulna',       'Largest mangrove forest, home of Royal Bengal Tiger.', 'November - February'),
('Sajek Valley',     'Bangladesh', 'Rangamati',    'Beautiful hill track valley with scenic views.', 'October - April'),
('Kuakata',          'Bangladesh', 'Patuakhali',   'Panoramic sea beach; see both sunrise and sunset.', 'November - March');
