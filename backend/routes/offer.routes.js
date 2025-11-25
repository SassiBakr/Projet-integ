const express = require('express');
const router = express.Router();
const Offer = require('../models/Offer');
const { protect, authorize } = require('../middleware/auth.middleware');
const { offerValidation, validate } = require('../middleware/validation.middleware');

// @route   POST /api/offers
// @desc    Créer une nouvelle offre
// @access  Private/Admin
router.post('/', protect, authorize('admin'), offerValidation, validate, async (req, res, next) => {
  try {
    const offerData = {
      ...req.body,
      createdBy: req.user.id
    };
    
    const offer = await Offer.create(offerData);
    
    res.status(201).json({
      success: true,
      message: 'Offre créée avec succès',
      data: offer
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/offers
// @desc    Obtenir toutes les offres actives
// @access  Public
router.get('/', async (req, res, next) => {
  try {
    const { deviceType, active, page = 1, limit = 10 } = req.query;
    
    const query = {};
    
    // Filtrer par type d'appareil
    if (deviceType) {
      query.$or = [
        { deviceType: deviceType },
        { deviceType: 'all' }
      ];
    }
    
    // Filtrer par statut actif
    if (active === 'true') {
      query.isActive = true;
      query.validUntil = { $gte: new Date() };
    }
    
    const offers = await Offer.find(query)
      .populate('createdBy', 'firstName lastName')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });
    
    const count = await Offer.countDocuments(query);
    
    res.status(200).json({
      success: true,
      data: offers,
      pagination: {
        total: count,
        page: parseInt(page),
        pages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/offers/:id
// @desc    Obtenir une offre par ID
// @access  Public
router.get('/:id', async (req, res, next) => {
  try {
    const offer = await Offer.findById(req.params.id)
      .populate('createdBy', 'firstName lastName');
    
    if (!offer) {
      return res.status(404).json({
        success: false,
        message: 'Offre non trouvée'
      });
    }
    
    res.status(200).json({
      success: true,
      data: offer
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/offers/code/:promoCode
// @desc    Obtenir une offre par code promo
// @access  Public
router.get('/code/:promoCode', async (req, res, next) => {
  try {
    const offer = await Offer.findOne({ 
      promoCode: req.params.promoCode.toUpperCase(),
      isActive: true,
      validUntil: { $gte: new Date() }
    });
    
    if (!offer) {
      return res.status(404).json({
        success: false,
        message: 'Code promo invalide ou expiré'
      });
    }
    
    // Vérifier si l'offre est valide
    if (!offer.isValid()) {
      return res.status(400).json({
        success: false,
        message: 'Cette offre n\'est plus disponible'
      });
    }
    
    res.status(200).json({
      success: true,
      data: offer
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/offers/:id
// @desc    Mettre à jour une offre
// @access  Private/Admin
router.put('/:id', protect, authorize('admin'), async (req, res, next) => {
  try {
    const offer = await Offer.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    
    if (!offer) {
      return res.status(404).json({
        success: false,
        message: 'Offre non trouvée'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Offre mise à jour avec succès',
      data: offer
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/offers/:id/redeem
// @desc    Utiliser une offre (incrémenter le compteur)
// @access  Private
router.put('/:id/redeem', protect, async (req, res, next) => {
  try {
    const offer = await Offer.findById(req.params.id);
    
    if (!offer) {
      return res.status(404).json({
        success: false,
        message: 'Offre non trouvée'
      });
    }
    
    // Vérifier si l'offre est valide
    if (!offer.isValid()) {
      return res.status(400).json({
        success: false,
        message: 'Cette offre n\'est plus disponible'
      });
    }
    
    offer.currentRedemptions += 1;
    await offer.save();
    
    res.status(200).json({
      success: true,
      message: 'Offre utilisée avec succès',
      data: offer
    });
  } catch (error) {
    next(error);
  }
});

// @route   DELETE /api/offers/:id
// @desc    Supprimer une offre
// @access  Private/Admin
router.delete('/:id', protect, authorize('admin'), async (req, res, next) => {
  try {
    const offer = await Offer.findByIdAndDelete(req.params.id);
    
    if (!offer) {
      return res.status(404).json({
        success: false,
        message: 'Offre non trouvée'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Offre supprimée avec succès'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
