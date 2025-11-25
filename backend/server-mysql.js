const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const { testConnection, createDefaultUsers } = require('./config/database');
const errorMiddleware = require('./middleware/error.middleware');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares de sécurité
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(morgan('dev'));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limite de 100 requêtes par IP
});
app.use('/api/', limiter);

// Middlewares de parsing
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Route de santé
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'Serveur SAV opérationnel avec MySQL',
    database: 'MySQL/XAMPP'
  });
});

// Routes API
app.use('/api/auth', require('./routes/auth.routes'));
app.use('/api/users', require('./routes/user.routes'));
app.use('/api/appointments', require('./routes/appointment.routes'));
app.use('/api/repairs', require('./routes/repair.routes'));
app.use('/api/offers', require('./routes/offer.routes'));
app.use('/api/notifications', require('./routes/notification.routes'));
app.use('/api/stats', require('./routes/stats.routes'));

// Middleware de gestion d'erreurs
app.use(errorMiddleware);

// Route 404
app.use('*', (req, res) => {
  res.status(404).json({ message: 'Route non trouvée' });
});

// Démarrage du serveur
const startServer = async () => {
  try {
    // Test de la connexion à la base de données
    const isConnected = await testConnection();
    
    if (!isConnected) {
      console.log('⚠️  Impossible de se connecter à MySQL');
      console.log('📋 Vérifiez que:');
      console.log('   1. XAMPP est démarré');
      console.log('   2. MySQL est en cours d\'exécution');
      console.log('   3. La base de données "sav_db" existe');
      console.log('   4. Les paramètres dans .env sont corrects');
      process.exit(1);
    }
    
    // Créer les utilisateurs par défaut
    await createDefaultUsers();
    
    // Démarrer le serveur
    app.listen(PORT, () => {
      console.log('╔════════════════════════════════════════╗');
      console.log('║   🚀 Serveur SAV démarré avec MySQL  ║');
      console.log('╚════════════════════════════════════════╝');
      console.log(`📍 Port: ${PORT}`);
      console.log(`🌐 URL: http://localhost:${PORT}`);
      console.log(`💾 Base de données: MySQL (XAMPP)`);
      console.log('');
      console.log('👥 Comptes de test:');
      console.log('   • Admin: admin@sav.com / admin123');
      console.log('   • Technicien: tech@sav.com / admin123');
      console.log('   • Client: client@sav.com / admin123');
      console.log('');
      console.log('📚 API Documentation: /api');
      console.log('💚 Health check: /health');
      console.log('════════════════════════════════════════');
    });
  } catch (error) {
    console.error('❌ Erreur au démarrage:', error.message);
    process.exit(1);
  }
};

// Gestion de l'arrêt propre
process.on('SIGINT', () => {
  console.log('\n👋 Arrêt du serveur...');
  process.exit(0);
});

// Démarrer l'application
startServer();

module.exports = app;
