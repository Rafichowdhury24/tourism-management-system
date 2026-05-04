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

INSERT INTO destinations (name, country, city, description, best_season) VALUES
('Cox''s Bazar',     'Bangladesh', 'Cox''s Bazar', 'World''s longest natural sea beach.',          'October - March'),
('Sundarbans',       'Bangladesh', 'Khulna',       'Largest mangrove forest, home of Royal Bengal Tiger.', 'November - February'),
('Sajek Valley',     'Bangladesh', 'Rangamati',    'Beautiful hill track valley with scenic views.', 'October - April'),
('Kuakata',          'Bangladesh', 'Patuakhali',   'Panoramic sea beach; see both sunrise and sunset.', 'November - March');
