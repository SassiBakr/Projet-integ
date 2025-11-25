const mysql = require('mysql2/promise');
require('dotenv').config();

// Configuration de la connexion MySQL
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'sav_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0
};

// Créer le pool de connexions
const pool = mysql.createPool(dbConfig);

// Tester la connexion
const testConnection = async () => {
  try {
    const connection = await pool.getConnection();
    console.log('✅ Connexion MySQL réussie');
    connection.release();
    return true;
  } catch (error) {
    console.error('❌ Erreur de connexion MySQL:', error.message);
    return false;
  }
};

// Fonction helper pour exécuter des requêtes
const query = async (sql, params) => {
  try {
    const [results] = await pool.execute(sql, params);
    return results;
  } catch (error) {
    console.error('❌ Erreur requête SQL:', error.message);
    throw error;
  }
};

// Fonction pour créer les utilisateurs par défaut avec hash correct
const createDefaultUsers = async () => {
  const bcrypt = require('bcryptjs');
  const hashedPassword = await bcrypt.hash('admin123', 10);
  
  try {
    // Vérifier si les utilisateurs existent déjà
    const [existing] = await pool.execute('SELECT COUNT(*) as count FROM users');
    
    if (existing[0].count === 0) {
      // Insérer les utilisateurs par défaut
      await pool.execute(
        `INSERT INTO users (first_name, last_name, email, password, phone, role, specialties) VALUES
         ('Admin', 'SAV', 'admin@sav.com', ?, '+33123456789', 'admin', NULL),
         ('Jean', 'Technicien', 'tech@sav.com', ?, '+33123456790', 'technician', ?),
         ('Marie', 'Client', 'client@sav.com', ?, '+33123456791', 'client', NULL)`,
        [hashedPassword, hashedPassword, JSON.stringify(['Électronique', 'Informatique', 'Téléphonie']), hashedPassword]
      );
      console.log('✅ Utilisateurs par défaut créés');
    }
  } catch (error) {
    console.error('❌ Erreur création utilisateurs:', error.message);
  }
};

module.exports = {
  pool,
  query,
  testConnection,
  createDefaultUsers
};
