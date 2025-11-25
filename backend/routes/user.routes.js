const express = require('express');
const router = express.Router();
const User = require('../models/User');
const { protect, authorize } = require('../middleware/auth.middleware');

// @route   GET /api/users
// @desc    Obtenir tous les utilisateurs (Admin only)
// @access  Private/Admin
router.get('/', protect, authorize('admin'), async (req, res, next) => {
  try {
    const { role, search, page = 1, limit = 10 } = req.query;
    
    const query = {};
    
    // Filtrer par rôle
    if (role) {
      query.role = role;
    }
    
    // Recherche par nom ou email
    if (search) {
      query.$or = [
        { firstName: { $regex: search, $options: 'i' } },
        { lastName: { $regex: search, $options: 'i' } },
        { email: { $regex: search, $options: 'i' } }
      ];
    }
    
    const users = await User.find(query)
      .select('-password')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });
    
    const count = await User.countDocuments(query);
    
    res.status(200).json({
      success: true,
      data: users,
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

// @route   GET /api/users/technicians
// @desc    Obtenir tous les techniciens disponibles
// @access  Private
router.get('/technicians', protect, async (req, res, next) => {
  try {
    const { specialty, available } = req.query;
    
    const query = { role: 'technician' };
    
    if (specialty) {
      query.specialties = specialty;
    }
    
    if (available === 'true') {
      query.isAvailable = true;
    }
    
    const technicians = await User.find(query)
      .select('-password')
      .sort({ rating: -1 });
    
    res.status(200).json({
      success: true,
      data: technicians
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/users/:id
// @desc    Obtenir un utilisateur par ID
// @access  Private
router.get('/:id', protect, async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Utilisateur non trouvé'
      });
    }
    
    res.status(200).json({
      success: true,
      data: user
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/users/:id
// @desc    Mettre à jour un utilisateur
// @access  Private
router.put('/:id', protect, async (req, res, next) => {
  try {
    // Vérifier que l'utilisateur peut modifier (lui-même ou admin)
    if (req.user.id !== req.params.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à modifier cet utilisateur'
      });
    }
    
    const { firstName, lastName, phone, address, specialties, isAvailable, avatar } = req.body;
    
    const updateData = {};
    if (firstName) updateData.firstName = firstName;
    if (lastName) updateData.lastName = lastName;
    if (phone) updateData.phone = phone;
    if (address) updateData.address = address;
    if (avatar) updateData.avatar = avatar;
    
    // Uniquement pour les techniciens
    if (req.user.role === 'technician') {
      if (specialties) updateData.specialties = specialties;
      if (isAvailable !== undefined) updateData.isAvailable = isAvailable;
    }
    
    const user = await User.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true, runValidators: true }
    ).select('-password');
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Utilisateur non trouvé'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Profil mis à jour avec succès',
      data: user
    });
  } catch (error) {
    next(error);
  }
});

// @route   DELETE /api/users/:id
// @desc    Supprimer un utilisateur
// @access  Private/Admin
router.delete('/:id', protect, authorize('admin'), async (req, res, next) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Utilisateur non trouvé'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Utilisateur supprimé avec succès'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
