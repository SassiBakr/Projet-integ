const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
require('dotenv').config();

async function checkAndCreateUsers() {
  try {
    // Connexion à MySQL
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'sav_db'
    });

    console.log('✅ Connexion MySQL réussie\n');

    // Vérifier les utilisateurs existants
    const [users] = await connection.execute('SELECT id, email, first_name, last_name, role FROM users');
    
    console.log(`📊 Nombre d'utilisateurs: ${users.length}`);
    if (users.length > 0) {
      console.log('\n👥 Utilisateurs existants:');
      users.forEach(user => {
        console.log(`   • ${user.email} (${user.role}) - ${user.first_name} ${user.last_name}`);
      });
    }

    // Si aucun utilisateur, créer les utilisateurs par défaut
    if (users.length === 0) {
      console.log('\n🔨 Création des utilisateurs par défaut...');
      
      const hashedPassword = await bcrypt.hash('admin123', 10);
      
      await connection.execute(
        `INSERT INTO users (first_name, last_name, email, password, phone, role, specialties) VALUES
         ('Admin', 'SAV', 'admin@sav.com', ?, '+33123456789', 'admin', NULL),
         ('Jean', 'Technicien', 'tech@sav.com', ?, '+33123456790', 'technician', ?),
         ('Marie', 'Client', 'client@sav.com', ?, '+33123456791', 'client', NULL)`,
        [
          hashedPassword, 
          hashedPassword, 
          JSON.stringify(['Électronique', 'Informatique', 'Téléphonie']), 
          hashedPassword
        ]
      );

      console.log('✅ Utilisateurs créés avec succès!\n');
      console.log('👥 Comptes de test:');
      console.log('   • admin@sav.com / admin123 (Admin)');
      console.log('   • tech@sav.com / admin123 (Technicien)');
      console.log('   • client@sav.com / admin123 (Client)');
    }

    // Vérifier un login pour tester
    console.log('\n🔐 Test de connexion avec admin@sav.com...');
    const [testUsers] = await connection.execute(
      'SELECT id, email, password FROM users WHERE email = ?',
      ['admin@sav.com']
    );

    if (testUsers.length > 0) {
      const testUser = testUsers[0];
      const isMatch = await bcrypt.compare('admin123', testUser.password);
      console.log(`   Mot de passe correct: ${isMatch ? '✅ OUI' : '❌ NON'}`);
    }

    await connection.end();
    console.log('\n✨ Vérification terminée!');

  } catch (error) {
    console.error('❌ Erreur:', error.message);
    process.exit(1);
  }
}

checkAndCreateUsers();
