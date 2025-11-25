const { body, validationResult } = require('express-validator');

// Middleware pour vérifier les erreurs de validation
exports.validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      errors: errors.array().map(err => ({
        field: err.param,
        message: err.msg
      }))
    });
  }
  next();
};

// Validation pour l'inscription
exports.registerValidation = [
  body('firstName').trim().notEmpty().withMessage('Le prénom est requis'),
  body('lastName').trim().notEmpty().withMessage('Le nom est requis'),
  body('email').isEmail().withMessage('Email invalide'),
  body('password')
    .isLength({ min: 6 })
    .withMessage('Le mot de passe doit contenir au moins 6 caractères'),
  body('phone').notEmpty().withMessage('Le numéro de téléphone est requis'),
  body('role')
    .optional()
    .isIn(['client', 'technician', 'admin'])
    .withMessage('Rôle invalide')
];

// Validation pour la connexion
exports.loginValidation = [
  body('email').isEmail().withMessage('Email invalide'),
  body('password').notEmpty().withMessage('Le mot de passe est requis')
];

// Validation pour créer un rendez-vous
exports.appointmentValidation = [
  body('deviceType')
    .isIn(['smartphone', 'computer', 'tablet', 'appliance', 'other'])
    .withMessage('Type d\'appareil invalide'),
  body('brand').trim().notEmpty().withMessage('La marque est requise'),
  body('model').trim().notEmpty().withMessage('Le modèle est requis'),
  body('issueDescription')
    .trim()
    .notEmpty()
    .withMessage('La description du problème est requise'),
  body('preferredDate').isISO8601().withMessage('Date invalide'),
  body('preferredTime')
    .isIn(['morning', 'afternoon', 'evening'])
    .withMessage('Créneau horaire invalide')
];

// Validation pour créer une offre
exports.offerValidation = [
  body('title').trim().notEmpty().withMessage('Le titre est requis'),
  body('description').trim().notEmpty().withMessage('La description est requise'),
  body('originalPrice')
    .isNumeric()
    .withMessage('Le prix original doit être un nombre'),
  body('discountedPrice')
    .isNumeric()
    .withMessage('Le prix réduit doit être un nombre'),
  body('validUntil').isISO8601().withMessage('Date de fin invalide')
];
