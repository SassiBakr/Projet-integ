const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Base de données en mémoire (pour développement sans MongoDB)
const db = {
  users: [],
  appointments: [],
  repairs: [],
  offers: [],
  notifications: []
};

// Créer un utilisateur admin par défaut
const createDefaultUsers = async () => {
  const hashedPassword = await bcrypt.hash('admin123', 10);
  
  db.users.push({
    _id: '1',
    firstName: 'Admin',
    lastName: 'SAV',
    email: 'admin@sav.com',
    password: hashedPassword,
    phone: '0612345678',
    role: 'admin',
    createdAt: new Date(),
    avatar: null,
    isAvailable: true
  });

  db.users.push({
    _id: '2',
    firstName: 'Technicien',
    lastName: 'Pro',
    email: 'tech@sav.com',
    password: hashedPassword,
    phone: '0612345679',
    role: 'technician',
    specialties: ['smartphones', 'computers'],
    isAvailable: true,
    rating: 4.5,
    totalReviews: 10,
    createdAt: new Date()
  });

  db.users.push({
    _id: '3',
    firstName: 'Client',
    lastName: 'Test',
    email: 'client@sav.com',
    password: hashedPassword,
    phone: '0612345670',
    role: 'client',
    createdAt: new Date()
  });

  console.log('👥 Utilisateurs par défaut créés');
};

createDefaultUsers();

// Middleware de sécurité
app.use(helmet());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Trop de requêtes depuis cette IP'
});
app.use('/api/', limiter);

// CORS
app.use(cors({
  origin: '*',
  credentials: true
}));

// Body parser
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Compression
app.use(compression());

// Logger
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

// Fonction pour générer un JWT
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET || 'secret', {
    expiresIn: '30d'
  });
};

// Middleware d'authentification
const protect = (req, res, next) => {
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  }

  if (!token) {
    return res.status(401).json({ success: false, message: 'Non autorisé' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    req.user = db.users.find(u => u._id === decoded.id);
    if (!req.user) {
      return res.status(401).json({ success: false, message: 'Utilisateur non trouvé' });
    }
    next();
  } catch (error) {
    return res.status(401).json({ success: false, message: 'Token invalide' });
  }
};

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'API SAV App - Backend Node.js (In-Memory DB)',
    version: '1.0.0',
    status: 'running',
    dbMode: 'in-memory'
  });
});

// AUTH ROUTES
app.post('/api/auth/register', async (req, res) => {
  try {
    const { firstName, lastName, email, password, phone, role } = req.body;

    const userExists = db.users.find(u => u.email === email);
    if (userExists) {
      return res.status(400).json({ success: false, message: 'Email déjà utilisé' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = {
      _id: String(db.users.length + 1),
      firstName,
      lastName,
      email,
      password: hashedPassword,
      phone,
      role: role || 'client',
      createdAt: new Date(),
      avatar: null,
      isAvailable: role === 'technician' ? true : undefined,
      specialties: role === 'technician' ? [] : undefined,
      rating: role === 'technician' ? 0 : undefined,
      totalReviews: role === 'technician' ? 0 : undefined
    };

    db.users.push(user);
    const token = generateToken(user._id);

    const { password: _, ...userWithoutPassword } = user;
    res.status(201).json({
      success: true,
      message: 'Inscription réussie',
      data: { user: userWithoutPassword, token }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = db.users.find(u => u.email === email);
    if (!user) {
      return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
    }

    const token = generateToken(user._id);
    const { password: _, ...userWithoutPassword } = user;

    res.json({
      success: true,
      message: 'Connexion réussie',
      data: { user: userWithoutPassword, token }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

app.get('/api/auth/me', protect, (req, res) => {
  const { password, ...userWithoutPassword } = req.user;
  res.json({ success: true, data: userWithoutPassword });
});

// USER ROUTES
app.get('/api/users/technicians', protect, (req, res) => {
  const technicians = db.users.filter(u => u.role === 'technician');
  res.json({ success: true, data: technicians });
});

// APPOINTMENT ROUTES
app.post('/api/appointments', protect, (req, res) => {
  const appointment = {
    _id: String(db.appointments.length + 1),
    ...req.body,
    client: req.user._id,
    status: 'pending',
    createdAt: new Date()
  };
  db.appointments.push(appointment);
  res.status(201).json({ success: true, data: appointment });
});

app.get('/api/appointments', protect, (req, res) => {
  let appointments = db.appointments;
  
  if (req.user.role === 'client') {
    appointments = appointments.filter(a => a.client === req.user._id);
  } else if (req.user.role === 'technician') {
    appointments = appointments.filter(a => a.technician === req.user._id);
  }

  // Peupler les données
  appointments = appointments.map(a => ({
    ...a,
    client: db.users.find(u => u._id === a.client),
    technician: a.technician ? db.users.find(u => u._id === a.technician) : null
  }));

  res.json({ success: true, data: appointments });
});

app.get('/api/appointments/:id', protect, (req, res) => {
  const appointment = db.appointments.find(a => a._id === req.params.id);
  if (!appointment) {
    return res.status(404).json({ success: false, message: 'Rendez-vous non trouvé' });
  }

  const populatedAppointment = {
    ...appointment,
    client: db.users.find(u => u._id === appointment.client),
    technician: appointment.technician ? db.users.find(u => u._id === appointment.technician) : null
  };

  res.json({ success: true, data: populatedAppointment });
});

app.put('/api/appointments/:id', protect, (req, res) => {
  const index = db.appointments.findIndex(a => a._id === req.params.id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Rendez-vous non trouvé' });
  }

  db.appointments[index] = { ...db.appointments[index], ...req.body };
  res.json({ success: true, data: db.appointments[index] });
});

// REPAIR ROUTES
app.get('/api/repairs', protect, (req, res) => {
  let repairs = db.repairs;
  
  if (req.user.role === 'client') {
    repairs = repairs.filter(r => r.client === req.user._id);
  } else if (req.user.role === 'technician') {
    repairs = repairs.filter(r => r.technician === req.user._id);
  }

  res.json({ success: true, data: repairs });
});

// OFFER ROUTES
app.get('/api/offers', (req, res) => {
  const activeOffers = db.offers.filter(o => o.isActive && new Date(o.validUntil) >= new Date());
  res.json({ success: true, data: activeOffers });
});

app.post('/api/offers', protect, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ success: false, message: 'Non autorisé' });
  }

  const offer = {
    _id: String(db.offers.length + 1),
    ...req.body,
    createdBy: req.user._id,
    currentRedemptions: 0,
    createdAt: new Date()
  };
  db.offers.push(offer);
  res.status(201).json({ success: true, data: offer });
});

// NOTIFICATION ROUTES
app.get('/api/notifications', protect, (req, res) => {
  const notifications = db.notifications.filter(n => n.recipient === req.user._id);
  const unreadCount = notifications.filter(n => !n.isRead).length;
  res.json({ success: true, data: notifications, unreadCount });
});

app.put('/api/notifications/:id/read', protect, (req, res) => {
  const index = db.notifications.findIndex(n => n._id === req.params.id && n.recipient === req.user._id);
  if (index === -1) {
    return res.status(404).json({ success: false, message: 'Notification non trouvée' });
  }

  db.notifications[index].isRead = true;
  db.notifications[index].readAt = new Date();
  res.json({ success: true, data: db.notifications[index] });
});

// STATS ROUTES
app.get('/api/stats/dashboard', protect, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ success: false, message: 'Non autorisé' });
  }

  const stats = {
    users: {
      totalClients: db.users.filter(u => u.role === 'client').length,
      totalTechnicians: db.users.filter(u => u.role === 'technician').length,
      availableTechnicians: db.users.filter(u => u.role === 'technician' && u.isAvailable).length
    },
    appointments: {
      total: db.appointments.length,
      pending: db.appointments.filter(a => a.status === 'pending').length,
      confirmed: db.appointments.filter(a => a.status === 'confirmed').length,
      completed: db.appointments.filter(a => a.status === 'completed').length
    },
    repairs: {
      total: db.repairs.length,
      inProgress: db.repairs.filter(r => r.status === 'in_progress').length,
      completed: db.repairs.filter(r => r.status === 'completed').length
    },
    revenue: {
      total: db.repairs.filter(r => r.status === 'completed').reduce((sum, r) => sum + (r.totalCost || 0), 0)
    },
    offers: {
      active: db.offers.filter(o => o.isActive && new Date(o.validUntil) >= new Date()).length
    }
  };

  res.json({ success: true, data: stats });
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`🚀 Serveur démarré sur le port ${PORT}`);
  console.log(`📍 Environnement: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🌐 API disponible sur: http://localhost:${PORT}`);
  console.log(`💾 Mode: Base de données en mémoire`);
  console.log(`\n👥 Comptes de test:`);
  console.log(`   Admin: admin@sav.com / admin123`);
  console.log(`   Technicien: tech@sav.com / admin123`);
  console.log(`   Client: client@sav.com / admin123`);
});

module.exports = app;
