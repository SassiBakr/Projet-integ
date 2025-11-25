const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { query } = require('../config/database');
const { protect } = require('../middleware/auth.middleware');
const { body, validationResult } = require('express-validator');

// @route   POST /api/auth/register
// @desc    Inscription d'un nouvel utilisateur
// @access  Public
router.post('/register', [
  body('email').isEmail().withMessage('Email invalide'),
  body('password').isLength({ min: 6 }).withMessage('Le mot de passe doit contenir au moins 6 caractères'),
  body('firstName').notEmpty().withMessage('Le prénom est requis'),
  body('lastName').notEmpty().withMessage('Le nom est requis')
], async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password, firstName, lastName, phone, role } = req.body;

    // Vérifier si l'utilisateur existe déjà
    const [existingUsers] = await query(
      'SELECT id FROM users WHERE email = ?',
      [email]
    );

    if (existingUsers && existingUsers.length > 0) {
      return res.status(400).json({ message: 'Cet email est déjà utilisé' });
    }

    // Hash du mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Créer l'utilisateur
    const result = await query(
      `INSERT INTO users (first_name, last_name, email, password, phone, role) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [firstName, lastName, email, hashedPassword, phone || null, role || 'client']
    );

    // Récupérer l'utilisateur créé
    const [users] = await query(
      'SELECT id, first_name, last_name, email, phone, role, created_at FROM users WHERE id = ?',
      [result.insertId]
    );

    const user = users[0];

    // Générer le token JWT
    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRE }
    );

    res.status(201).json({
      success: true,
      token,
      user: {
        _id: user.id.toString(),
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
        phone: user.phone,
        role: user.role
      }
    });
  } catch (error) {
    next(error);
  }
});

// @route   POST /api/auth/login
// @desc    Connexion d'un utilisateur
// @access  Public
router.post('/login', [
  body('email').isEmail().withMessage('Email invalide'),
  body('password').notEmpty().withMessage('Le mot de passe est requis')
], async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    // Trouver l'utilisateur
    const [users] = await query(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (!users || users.length === 0) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
    }

    const user = users[0];

    // Vérifier le mot de passe
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
    }

    // Générer le token JWT
    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRE }
    );

    // Parse JSON fields
    let specialties = null;
    if (user.specialties) {
      try {
        specialties = JSON.parse(user.specialties);
      } catch (e) {
        specialties = user.specialties;
      }
    }

    res.json({
      success: true,
      token,
      user: {
        _id: user.id.toString(),
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        avatar: user.avatar,
        specialties: specialties,
        rating: parseFloat(user.rating) || 0,
        totalReviews: user.total_reviews || 0
      }
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/auth/me
// @desc    Récupérer l'utilisateur connecté
// @access  Private
router.get('/me', protect, async (req, res, next) => {
  try {
    const [users] = await query(
      'SELECT id, first_name, last_name, email, phone, role, avatar, specialties, rating, total_reviews, created_at FROM users WHERE id = ?',
      [req.user.id]
    );

    if (!users || users.length === 0) {
      return res.status(404).json({ message: 'Utilisateur non trouvé' });
    }

    const user = users[0];

    // Parse JSON fields
    let specialties = null;
    if (user.specialties) {
      try {
        specialties = JSON.parse(user.specialties);
      } catch (e) {
        specialties = user.specialties;
      }
    }

    res.json({
      success: true,
      user: {
        _id: user.id.toString(),
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        avatar: user.avatar,
        specialties: specialties,
        rating: parseFloat(user.rating) || 0,
        totalReviews: user.total_reviews || 0
      }
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
