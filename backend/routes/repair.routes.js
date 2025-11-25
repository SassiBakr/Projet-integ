const express = require('express');
const router = express.Router();
const Repair = require('../models/Repair');
const Appointment = require('../models/Appointment');
const { protect, authorize } = require('../middleware/auth.middleware');

// @route   POST /api/repairs
// @desc    Créer une nouvelle réparation
// @access  Private/Technician
router.post('/', protect, authorize('technician', 'admin'), async (req, res, next) => {
  try {
    const repairData = {
      ...req.body,
      technician: req.user.id
    };
    
    const repair = await Repair.create(repairData);
    
    // Mettre à jour le statut du rendez-vous
    await Appointment.findByIdAndUpdate(repair.appointment, {
      status: 'in_progress'
    });
    
    await repair.populate([
      { path: 'client', select: 'firstName lastName email phone' },
      { path: 'technician', select: 'firstName lastName email phone' },
      { path: 'appointment' }
    ]);
    
    res.status(201).json({
      success: true,
      message: 'Réparation créée avec succès',
      data: repair
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/repairs
// @desc    Obtenir toutes les réparations
// @access  Private
router.get('/', protect, async (req, res, next) => {
  try {
    const { status, page = 1, limit = 10 } = req.query;
    
    const query = {};
    
    // Filtrer selon le rôle
    if (req.user.role === 'client') {
      query.client = req.user.id;
    } else if (req.user.role === 'technician') {
      query.technician = req.user.id;
    }
    
    // Filtrer par statut
    if (status) {
      query.status = status;
    }
    
    const repairs = await Repair.find(query)
      .populate('client', 'firstName lastName email phone')
      .populate('technician', 'firstName lastName email phone')
      .populate('appointment')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });
    
    const count = await Repair.countDocuments(query);
    
    res.status(200).json({
      success: true,
      data: repairs,
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

// @route   GET /api/repairs/:id
// @desc    Obtenir une réparation par ID
// @access  Private
router.get('/:id', protect, async (req, res, next) => {
  try {
    const repair = await Repair.findById(req.params.id)
      .populate('client', 'firstName lastName email phone address')
      .populate('technician', 'firstName lastName email phone specialties')
      .populate('appointment');
    
    if (!repair) {
      return res.status(404).json({
        success: false,
        message: 'Réparation non trouvée'
      });
    }
    
    // Vérifier les permissions
    if (
      req.user.role === 'client' && repair.client._id.toString() !== req.user.id ||
      req.user.role === 'technician' && repair.technician._id.toString() !== req.user.id
    ) {
      if (req.user.role !== 'admin') {
        return res.status(403).json({
          success: false,
          message: 'Non autorisé à voir cette réparation'
        });
      }
    }
    
    res.status(200).json({
      success: true,
      data: repair
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/repairs/:id
// @desc    Mettre à jour une réparation
// @access  Private/Technician
router.put('/:id', protect, authorize('technician', 'admin'), async (req, res, next) => {
  try {
    let repair = await Repair.findById(req.params.id);
    
    if (!repair) {
      return res.status(404).json({
        success: false,
        message: 'Réparation non trouvée'
      });
    }
    
    // Vérifier que c'est le bon technicien
    if (req.user.role === 'technician' && repair.technician.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé à modifier cette réparation'
      });
    }
    
    repair = await Repair.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    )
    .populate('client', 'firstName lastName email phone')
    .populate('technician', 'firstName lastName email phone')
    .populate('appointment');
    
    // Si la réparation est terminée, mettre à jour le rendez-vous
    if (req.body.status === 'completed') {
      await Appointment.findByIdAndUpdate(repair.appointment._id, {
        status: 'completed',
        finalCost: repair.totalCost
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Réparation mise à jour avec succès',
      data: repair
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/repairs/:id/complete
// @desc    Marquer une réparation comme terminée
// @access  Private/Technician
router.put('/:id/complete', protect, authorize('technician', 'admin'), async (req, res, next) => {
  try {
    const repair = await Repair.findById(req.params.id);
    
    if (!repair) {
      return res.status(404).json({
        success: false,
        message: 'Réparation non trouvée'
      });
    }
    
    repair.status = 'completed';
    repair.endTime = new Date();
    await repair.save();
    
    // Mettre à jour le rendez-vous
    await Appointment.findByIdAndUpdate(repair.appointment, {
      status: 'completed',
      finalCost: repair.totalCost
    });
    
    res.status(200).json({
      success: true,
      message: 'Réparation terminée avec succès',
      data: repair
    });
  } catch (error) {
    next(error);
  }
});

// @route   DELETE /api/repairs/:id
// @desc    Supprimer une réparation
// @access  Private/Admin
router.delete('/:id', protect, authorize('admin'), async (req, res, next) => {
  try {
    const repair = await Repair.findByIdAndDelete(req.params.id);
    
    if (!repair) {
      return res.status(404).json({
        success: false,
        message: 'Réparation non trouvée'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Réparation supprimée avec succès'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
