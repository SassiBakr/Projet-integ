const express = require('express');
const router = express.Router();
const User = require('../models/User');
const Appointment = require('../models/Appointment');
const Repair = require('../models/Repair');
const Offer = require('../models/Offer');
const { protect, authorize } = require('../middleware/auth.middleware');

// @route   GET /api/stats/dashboard
// @desc    Obtenir les statistiques du tableau de bord (Admin)
// @access  Private/Admin
router.get('/dashboard', protect, authorize('admin'), async (req, res, next) => {
  try {
    // Compter les utilisateurs par rôle
    const totalClients = await User.countDocuments({ role: 'client' });
    const totalTechnicians = await User.countDocuments({ role: 'technician' });
    const availableTechnicians = await User.countDocuments({ 
      role: 'technician', 
      isAvailable: true 
    });
    
    // Compter les rendez-vous par statut
    const totalAppointments = await Appointment.countDocuments();
    const pendingAppointments = await Appointment.countDocuments({ status: 'pending' });
    const confirmedAppointments = await Appointment.countDocuments({ status: 'confirmed' });
    const completedAppointments = await Appointment.countDocuments({ status: 'completed' });
    
    // Compter les réparations
    const totalRepairs = await Repair.countDocuments();
    const inProgressRepairs = await Repair.countDocuments({ status: 'in_progress' });
    const completedRepairs = await Repair.countDocuments({ status: 'completed' });
    
    // Calculer le revenu total
    const revenueData = await Repair.aggregate([
      { $match: { status: 'completed' } },
      { $group: { _id: null, total: { $sum: '$totalCost' } } }
    ]);
    const totalRevenue = revenueData.length > 0 ? revenueData[0].total : 0;
    
    // Compter les offres actives
    const activeOffers = await Offer.countDocuments({ 
      isActive: true,
      validUntil: { $gte: new Date() }
    });
    
    // Rendez-vous récents
    const recentAppointments = await Appointment.find()
      .populate('client', 'firstName lastName')
      .populate('technician', 'firstName lastName')
      .sort({ createdAt: -1 })
      .limit(5);
    
    // Statistiques mensuelles des rendez-vous
    const monthlyStats = await Appointment.aggregate([
      {
        $group: {
          _id: { 
            year: { $year: '$createdAt' },
            month: { $month: '$createdAt' }
          },
          count: { $sum: 1 }
        }
      },
      { $sort: { '_id.year': -1, '_id.month': -1 } },
      { $limit: 6 }
    ]);
    
    res.status(200).json({
      success: true,
      data: {
        users: {
          totalClients,
          totalTechnicians,
          availableTechnicians
        },
        appointments: {
          total: totalAppointments,
          pending: pendingAppointments,
          confirmed: confirmedAppointments,
          completed: completedAppointments
        },
        repairs: {
          total: totalRepairs,
          inProgress: inProgressRepairs,
          completed: completedRepairs
        },
        revenue: {
          total: totalRevenue
        },
        offers: {
          active: activeOffers
        },
        recentAppointments,
        monthlyStats
      }
    });
  } catch (error) {
    next(error);
  }
});

// @route   GET /api/stats/technician/:id
// @desc    Obtenir les statistiques d'un technicien
// @access  Private
router.get('/technician/:id', protect, async (req, res, next) => {
  try {
    const technicianId = req.params.id;
    
    // Vérifier les permissions
    if (req.user.role === 'technician' && req.user.id !== technicianId) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé'
      });
    }
    
    // Compter les rendez-vous
    const totalAppointments = await Appointment.countDocuments({ 
      technician: technicianId 
    });
    const completedAppointments = await Appointment.countDocuments({ 
      technician: technicianId,
      status: 'completed'
    });
    
    // Compter les réparations
    const totalRepairs = await Repair.countDocuments({ technician: technicianId });
    const completedRepairs = await Repair.countDocuments({ 
      technician: technicianId,
      status: 'completed'
    });
    
    // Calculer le revenu généré
    const revenueData = await Repair.aggregate([
      { 
        $match: { 
          technician: mongoose.Types.ObjectId(technicianId),
          status: 'completed'
        }
      },
      { $group: { _id: null, total: { $sum: '$totalCost' } } }
    ]);
    const totalRevenue = revenueData.length > 0 ? revenueData[0].total : 0;
    
    // Obtenir la note moyenne
    const technician = await User.findById(technicianId);
    
    res.status(200).json({
      success: true,
      data: {
        appointments: {
          total: totalAppointments,
          completed: completedAppointments
        },
        repairs: {
          total: totalRepairs,
          completed: completedRepairs
        },
        revenue: {
          total: totalRevenue
        },
        rating: technician.rating,
        totalReviews: technician.totalReviews
      }
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
