const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

async function setupDatabase() {
  console.log('🔧 Configuration de la base de données MySQL...\n');

  try {
    // Connexion sans spécifier la base de données
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      multipleStatements: true
    });

    console.log('✅ Connexion à MySQL réussie');

    // Lire le fichier SQL
    const sqlFile = fs.readFileSync(path.join(__dirname, 'database.sql'), 'utf8');

    console.log('📄 Lecture du fichier database.sql...');
    
    // Exécuter le script SQL
    await connection.query(sqlFile);
    
    console.log('✅ Base de données créée avec succès!');
    console.log('✅ Tables créées:');
    console.log('   - users');
    console.log('   - appointments');
    console.log('   - repairs');
    console.log('   - offers');
    console.log('   - notifications');
    console.log('   - reviews');
    console.log('');
    console.log('👥 Utilisateurs par défaut créés:');
    console.log('   • admin@sav.com / admin123 (Admin)');
    console.log('   • tech@sav.com / admin123 (Technicien)');
    console.log('   • client@sav.com / admin123 (Client)');
    console.log('');
    console.log('🎉 Configuration terminée! Vous pouvez maintenant démarrer le serveur:');
    console.log('   npm run start:mysql');

    await connection.end();

  } catch (error) {
    console.error('❌ Erreur lors de la configuration:', error.message);
    console.log('\n📋 Vérifications:');
    console.log('   1. XAMPP est-il démarré?');
    console.log('   2. MySQL est-il en cours d\'exécution?');
    console.log('   3. Les paramètres dans .env sont-ils corrects?');
    console.log('   4. Le port MySQL (3306) est-il disponible?');
    process.exit(1);
  }
}

setupDatabase();
