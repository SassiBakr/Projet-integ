const express = require('express');
const router = express.Router();
const Appointment = require('../models/Appointment');
const User = require('../models/User');
const { protect, authorize } = require('../middleware/auth.middleware');
const { appointmentValidation, validate } = require('../middleware/validation.middleware');

// @route   POST /api/appointments
// @desc    Créer un nouveau rendez-vous
// @access  Private/Client
router.post('/', protect, authorize('client'), appointmentValidation, validate, async (req, res, next) => {
  try {
    const appointmentData = {
      ...req.body,
      client: req.user.id
    };
    
    const appointment = await Appointment.create(appointmentData);
    
    // Peupler les données du client
    await appointment.populate('client', 'firstName lastName email phone');
    
    res.status(201).json({
      success: true,
      message: 'Rendez-vous créé avec succès',
      data: appointment
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/appointments
// @desc    Obtenir tous les rendez-vous (filtré selon le rôle)
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
    
    const appointments = await Appointment.find(query)
      .populate('client', 'firstName lastName email phone')
      .populate('technician', 'firstName lastName email phone specialties rating')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });
    
    const count = await Appointment.countDocuments(query);
    
    res.status(200).json({
      success: true,
      data: appointments,
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

// @route   GET /api/appointments/:id
// @desc    Obtenir un rendez-vous par ID
// @access  Private
router.get('/:id', protect, async (req, res, next) => {
  try {
    const appointment = await Appointment.findById(req.params.id)
      .populate('client', 'firstName lastName email phone address')
      .populate('technician', 'firstName lastName email phone specialties rating');
    
    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Rendez-vous non trouvé'
      });
    }
    
    // Vérifier les permissions
    if (
      req.user.role === 'client' && appointment.client._id.toString() !== req.user.id ||
      req.user.role === 'technician' && appointment.technician && appointment.technician._id.toString() !== req.user.id
    ) {
      if (req.user.role !== 'admin') {
        return res.status(403).json({
          success: false,
          message: 'Non autorisé à voir ce rendez-vous'
        });
      }
    }
    
    res.status(200).json({
      success: true,
      data: appointment
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/appointments/:id
// @desc    Mettre à jour un rendez-vous
// @access  Private
router.put('/:id', protect, async (req, res, next) => {
  try {
    let appointment = await Appointment.findById(req.params.id);
    
    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Rendez-vous non trouvé'
      });
    }
    
    // Vérifier les permissions
    if (
      req.user.role === 'client' && appointment.client.toString() !== req.user.id ||
      req.user.role === 'technician' && appointment.technician && appointment.technician.toString() !== req.user.id
    ) {
      if (req.user.role !== 'admin') {
        return res.status(403).json({
          success: false,
          message: 'Non autorisé à modifier ce rendez-vous'
        });
      }
    }
    
    appointment = await Appointment.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    )
    .populate('client', 'firstName lastName email phone')
    .populate('technician', 'firstName lastName email phone specialties rating');
    
    res.status(200).json({
      success: true,
      message: 'Rendez-vous mis à jour avec succès',
      data: appointment
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/appointments/:id/assign
// @desc    Assigner un technicien à un rendez-vous
// @access  Private/Admin
router.put('/:id/assign', protect, authorize('admin', 'technician'), async (req, res, next) => {
  try {
    const { technicianId } = req.body;
    
    // Vérifier que le technicien existe
    const technician = await User.findOne({ _id: technicianId, role: 'technician' });
    if (!technician) {
      return res.status(404).json({
        success: false,
        message: 'Technicien non trouvé'
      });
    }
    
    const appointment = await Appointment.findByIdAndUpdate(
      req.params.id,
      { 
        technician: technicianId,
        status: 'confirmed'
      },
      { new: true }
    )
    .populate('client', 'firstName lastName email phone')
    .populate('technician', 'firstName lastName email phone specialties rating');
    
    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Rendez-vous non trouvé'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Technicien assigné avec succès',
      data: appointment
    });
  } catch (error) {
    next(error);
  }
});

// @route   PUT /api/appointments/:id/cancel
// @desc    Annuler un rendez-vous
// @access  Private
router.put('/:id/cancel', protect, async (req, res, next) => {
  try {
    const { cancellationReason } = req.body;
    
    const appointment = await Appointment.findById(req.params.id);
    
    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Rendez-vous non trouvé'
      });
    }
    
    appointment.status = 'cancelled';
    appointment.cancellationReason = cancellationReason;
    await appointment.save();
    
    res.status(200).json({
      success: true,
      message: 'Rendez-vous annulé avec succès',
      data: appointment
    });
  } catch (error) {
    next(error);
  }
});

// @route   DELETE /api/appointments/:id
// @desc    Supprimer un rendez-vous
// @access  Private/Admin
router.delete('/:id', protect, authorize('admin'), async (req, res, next) => {
  try {
    const appointment = await Appointment.findByIdAndDelete(req.params.id);
    
    if (!appointment) {
      return res.status(404).json({
        success: false,
        message: 'Rendez-vous non trouvé'
      });
    }
    
    res.status(200).json({
      success: true,
      message: 'Rendez-vous supprimé avec succès'
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
