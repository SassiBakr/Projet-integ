const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
  client: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  technician: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null
  },
  deviceType: {
    type: String,
    required: [true, 'Le type d\'appareil est requis'],
    enum: ['smartphone', 'computer', 'tablet', 'appliance', 'other']
  },
  brand: {
    type: String,
    required: [true, 'La marque est requise']
  },
  model: {
    type: String,
    required: [true, 'Le modèle est requis']
  },
  issueDescription: {
    type: String,
    required: [true, 'La description du problème est requise']
  },
  photos: [{
    url: String,
    publicId: String
  }],
  preferredDate: {
    type: Date,
    required: [true, 'La date préférée est requise']
  },
  preferredTime: {
    type: String,
    enum: ['morning', 'afternoon', 'evening'],
    required: true
  },
  scheduledDate: {
    type: Date,
    default: null
  },
  address: {
    street: String,
    city: String,
    postalCode: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    }
  },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'in_progress', 'completed', 'cancelled'],
    default: 'pending'
  },
  estimatedCost: {
    type: Number,
    default: null
  },
  finalCost: {
    type: Number,
    default: null
  },
  notes: {
    type: String,
    default: ''
  },
  cancellationReason: {
    type: String,
    default: null
  },
  rating: {
    type: Number,
    min: 1,
    max: 5,
    default: null
  },
  review: {
    type: String,
    default: null
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Index pour les recherches fréquentes
appointmentSchema.index({ client: 1, status: 1 });
appointmentSchema.index({ technician: 1, status: 1 });
appointmentSchema.index({ scheduledDate: 1 });

module.exports = mongoose.model('Appointment', appointmentSchema);
