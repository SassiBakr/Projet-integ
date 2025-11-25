const mongoose = require('mongoose');

const repairSchema = new mongoose.Schema({
  appointment: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Appointment',
    required: true
  },
  client: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  technician: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  deviceType: {
    type: String,
    required: true
  },
  brand: String,
  model: String,
  diagnosis: {
    type: String,
    required: [true, 'Le diagnostic est requis']
  },
  repairDescription: {
    type: String,
    required: [true, 'La description de la réparation est requise']
  },
  partsUsed: [{
    name: String,
    quantity: Number,
    unitPrice: Number,
    totalPrice: Number
  }],
  laborCost: {
    type: Number,
    required: true,
    default: 0
  },
  partsCost: {
    type: Number,
    default: 0
  },
  totalCost: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['in_progress', 'completed', 'failed', 'pending_parts'],
    default: 'in_progress'
  },
  startTime: {
    type: Date,
    default: Date.now
  },
  endTime: {
    type: Date,
    default: null
  },
  beforePhotos: [{
    url: String,
    publicId: String
  }],
  afterPhotos: [{
    url: String,
    publicId: String
  }],
  warranty: {
    duration: {
      type: Number, // en jours
      default: 90
    },
    expiresAt: Date
  },
  notes: String,
  clientSignature: {
    url: String,
    signedAt: Date
  },
  invoice: {
    number: String,
    pdfUrl: String,
    generatedAt: Date
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

// Calculer le coût total avant sauvegarde
repairSchema.pre('save', function(next) {
  this.partsCost = this.partsUsed.reduce((total, part) => total + part.totalPrice, 0);
  this.totalCost = this.laborCost + this.partsCost;
  
  // Calculer la date d'expiration de la garantie
  if (this.warranty.duration && this.endTime) {
    const expiresAt = new Date(this.endTime);
    expiresAt.setDate(expiresAt.getDate() + this.warranty.duration);
    this.warranty.expiresAt = expiresAt;
  }
  
  next();
});

module.exports = mongoose.model('Repair', repairSchema);
