-- Base de données SAV (Service Après-Vente)
-- Compatible avec XAMPP MySQL/MariaDB

-- Créer la base de données
CREATE DATABASE IF NOT EXISTS sav_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sav_db;

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('client', 'technician', 'admin') NOT NULL DEFAULT 'client',
    avatar TEXT,
    specialties JSON,
    rating DECIMAL(2,1) DEFAULT 0,
    total_reviews INT DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des rendez-vous
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    technician_id INT,
    scheduled_date DATETIME NOT NULL,
    status ENUM('pending', 'confirmed', 'in_progress', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    service_type VARCHAR(100) NOT NULL,
    description TEXT,
    address TEXT,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    estimated_duration INT,
    notes TEXT,
    cancellation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (technician_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_client (client_id),
    INDEX idx_technician (technician_id),
    INDEX idx_status (status),
    INDEX idx_date (scheduled_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des réparations
CREATE TABLE IF NOT EXISTS repairs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    client_id INT NOT NULL,
    technician_id INT,
    device_type VARCHAR(100) NOT NULL,
    device_brand VARCHAR(100),
    device_model VARCHAR(100),
    serial_number VARCHAR(100),
    issue_description TEXT NOT NULL,
    diagnosis TEXT,
    status ENUM('pending', 'diagnosed', 'in_progress', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    estimated_cost DECIMAL(10, 2),
    final_cost DECIMAL(10, 2),
    parts_used JSON,
    warranty_until DATE,
    images JSON,
    started_at DATETIME,
    completed_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (technician_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_client (client_id),
    INDEX idx_technician (technician_id),
    INDEX idx_status (status),
    INDEX idx_priority (priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des offres
CREATE TABLE IF NOT EXISTS offers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    discount_percentage INT DEFAULT 0,
    final_price DECIMAL(10, 2) NOT NULL,
    estimated_duration INT,
    is_available BOOLEAN DEFAULT TRUE,
    image TEXT,
    features JSON,
    terms TEXT,
    valid_from DATE,
    valid_until DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_available (is_available),
    INDEX idx_valid (valid_from, valid_until)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des notifications
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'success', 'warning', 'error', 'appointment', 'repair', 'offer') NOT NULL DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    related_id INT,
    related_type VARCHAR(50),
    action_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_read (is_read),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des avis/évaluations
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    technician_id INT NOT NULL,
    client_id INT NOT NULL,
    repair_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (technician_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (repair_id) REFERENCES repairs(id) ON DELETE SET NULL,
    INDEX idx_technician (technician_id),
    INDEX idx_client (client_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insérer les utilisateurs par défaut
INSERT INTO users (first_name, last_name, email, password, phone, role, specialties) VALUES
('Admin', 'SAV', 'admin@sav.com', '$2a$10$YourHashedPasswordHere', '+33123456789', 'admin', NULL),
('Jean', 'Technicien', 'tech@sav.com', '$2a$10$YourHashedPasswordHere', '+33123456790', 'technician', '["Électronique", "Informatique", "Téléphonie"]'),
('Marie', 'Client', 'client@sav.com', '$2a$10$YourHashedPasswordHere', '+33123456791', 'client', NULL);

-- Insérer quelques offres par défaut
INSERT INTO offers (title, description, category, price, discount_percentage, final_price, estimated_duration, features) VALUES
('Réparation écran smartphone', 'Remplacement professionnel de votre écran cassé', 'Téléphonie', 89.99, 10, 80.99, 60, '["Écran d\'origine", "Garantie 6 mois", "Intervention rapide"]'),
('Diagnostic gratuit', 'Analyse complète de votre appareil', 'Tous appareils', 0, 0, 0, 30, '["Sans engagement", "Devis détaillé", "Conseils d\'expert"]'),
('Nettoyage ordinateur', 'Nettoyage complet + optimisation système', 'Informatique', 49.99, 0, 49.99, 90, '["Suppression virus", "Optimisation", "Sauvegarde"]');

-- Vue pour les statistiques des techniciens
CREATE OR REPLACE VIEW technician_stats AS
SELECT 
    u.id,
    u.first_name,
    u.last_name,
    u.email,
    u.rating,
    u.total_reviews,
    COUNT(DISTINCT r.id) as total_repairs,
    COUNT(DISTINCT CASE WHEN r.status = 'completed' THEN r.id END) as completed_repairs,
    COUNT(DISTINCT a.id) as total_appointments,
    AVG(r.final_cost) as avg_repair_cost
FROM users u
LEFT JOIN repairs r ON u.id = r.technician_id
LEFT JOIN appointments a ON u.id = a.technician_id
WHERE u.role = 'technician'
GROUP BY u.id, u.first_name, u.last_name, u.email, u.rating, u.total_reviews;

-- Vue pour les statistiques des clients
CREATE OR REPLACE VIEW client_stats AS
SELECT 
    u.id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(DISTINCT r.id) as total_repairs,
    COUNT(DISTINCT a.id) as total_appointments,
    SUM(r.final_cost) as total_spent
FROM users u
LEFT JOIN repairs r ON u.id = r.client_id
LEFT JOIN appointments a ON u.id = a.client_id
WHERE u.role = 'client'
GROUP BY u.id, u.first_name, u.last_name, u.email;

-- Procédure stockée pour calculer le rating d'un technicien
DELIMITER //
CREATE PROCEDURE update_technician_rating(IN tech_id INT)
BEGIN
    DECLARE avg_rating DECIMAL(2,1);
    DECLARE review_count INT;
    
    SELECT AVG(rating), COUNT(*) 
    INTO avg_rating, review_count
    FROM reviews 
    WHERE technician_id = tech_id;
    
    UPDATE users 
    SET rating = COALESCE(avg_rating, 0),
        total_reviews = review_count
    WHERE id = tech_id;
END //
DELIMITER ;

-- Trigger pour mettre à jour automatiquement le rating après un avis
DELIMITER //
CREATE TRIGGER after_review_insert
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    CALL update_technician_rating(NEW.technician_id);
END //
DELIMITER ;

-- Trigger pour mettre à jour le rating après modification d'un avis
DELIMITER //
CREATE TRIGGER after_review_update
AFTER UPDATE ON reviews
FOR EACH ROW
BEGIN
    CALL update_technician_rating(NEW.technician_id);
END //
DELIMITER ;

-- Afficher les tables créées
SHOW TABLES;
