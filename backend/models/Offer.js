const mongoose = require('mongoose');

const offerSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Le titre est requis'],
    trim: true
  },
  description: {
    type: String,
    required: [true, 'La description est requise']
  },
  deviceType: {
    type: String,
    enum: ['smartphone', 'computer', 'tablet', 'appliance', 'all'],
    default: 'all'
  },
  originalPrice: {
    type: Number,
    required: [true, 'Le prix original est requis']
  },
  discountedPrice: {
    type: Number,
    required: [true, 'Le prix réduit est requis']
  },
  discountPercentage: {
    type: Number,
    default: 0
  },
  image: {
    url: String,
    publicId: String
  },
  validFrom: {
    type: Date,
    default: Date.now
  },
  validUntil: {
    type: Date,
    required: [true, 'La date de fin est requise']
  },
  termsAndConditions: {
    type: String,
    default: ''
  },
  isActive: {
    type: Boolean,
    default: true
  },
  maxRedemptions: {
    type: Number,
    default: null // null = illimité
  },
  currentRedemptions: {
    type: Number,
    default: 0
  },
  promoCode: {
    type: String,
    unique: true,
    sparse: true,
    uppercase: true
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
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

// Calculer le pourcentage de réduction avant sauvegarde
offerSchema.pre('save', function(next) {
  if (this.originalPrice && this.discountedPrice) {
    this.discountPercentage = Math.round(
      ((this.originalPrice - this.discountedPrice) / this.originalPrice) * 100
    );
  }
  next();
});

// Méthode pour vérifier si l'offre est valide
offerSchema.methods.isValid = function() {
  const now = new Date();
  const isDateValid = now >= this.validFrom && now <= this.validUntil;
  const hasRedemptionsLeft = !this.maxRedemptions || 
    this.currentRedemptions < this.maxRedemptions;
  
  return this.isActive && isDateValid && hasRedemptionsLeft;
};

module.exports = mongoose.model('Offer', offerSchema);
