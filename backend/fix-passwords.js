const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
require('dotenv').config();

async function updatePasswords() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'sav_db'
    });

    console.log('✅ Connexion MySQL réussie\n');
    console.log('🔐 Mise à jour des mots de passe...\n');

    const hashedPassword = await bcrypt.hash('admin123', 10);
    console.log(`Hash généré: ${hashedPassword.substring(0, 20)}...\n`);

    // Mettre à jour tous les utilisateurs
    await connection.execute(
      'UPDATE users SET password = ? WHERE email IN (?, ?, ?)',
      [hashedPassword, 'admin@sav.com', 'tech@sav.com', 'client@sav.com']
    );

    console.log('✅ Mots de passe mis à jour!\n');

    // Vérifier
    const [users] = await connection.execute(
      'SELECT email, role FROM users WHERE email IN (?, ?, ?)',
      ['admin@sav.com', 'tech@sav.com', 'client@sav.com']
    );

    console.log('✅ Comptes prêts:');
    users.forEach(user => {
      console.log(`   • ${user.email} / admin123 (${user.role})`);
    });

    // Test de login
    console.log('\n🔐 Test de connexion...');
    const [testUsers] = await connection.execute(
      'SELECT email, password FROM users WHERE email = ?',
      ['admin@sav.com']
    );

    if (testUsers.length > 0) {
      const isMatch = await bcrypt.compare('admin123', testUsers[0].password);
      console.log(`   admin@sav.com / admin123: ${isMatch ? '✅ VALIDE' : '❌ INVALIDE'}`);
    }

    await connection.end();
    console.log('\n🎉 Terminé! Vous pouvez maintenant vous connecter.');

  } catch (error) {
    console.error('❌ Erreur:', error.message);
    process.exit(1);
  }
}

updatePasswords();
