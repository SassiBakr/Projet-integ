# API Documentation - SAV App Backend

## Base URL
```
http://localhost:3000/api
```

## Response Format

Toutes les réponses suivent ce format :

### Success Response
```json
{
  "success": true,
  "message": "Message de succès",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Message d'erreur",
  "errors": [ ... ] // Optionnel
}
```

## Authentication Endpoints

### Register
```http
POST /auth/register
Content-Type: application/json

{
  "firstName": "Jean",
  "lastName": "Dupont",
  "email": "jean@example.com",
  "password": "password123",
  "phone": "0612345678",
  "role": "client" // client | technician | admin
}
```

### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "jean@example.com",
  "password": "password123"
}
```

Response:
```json
{
  "success": true,
  "message": "Connexion réussie",
  "data": {
    "user": {
      "id": "...",
      "firstName": "Jean",
      "lastName": "Dupont",
      "email": "jean@example.com",
      "role": "client"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Get Current User
```http
GET /auth/me
Authorization: Bearer <token>
```

## User Endpoints

### Get All Users (Admin)
```http
GET /users?role=client&search=jean&page=1&limit=10
Authorization: Bearer <token>
```

### Get Technicians
```http
GET /users/technicians?specialty=smartphones&available=true
Authorization: Bearer <token>
```

### Get User by ID
```http
GET /users/:id
Authorization: Bearer <token>
```

### Update User
```http
PUT /users/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "firstName": "Jean",
  "phone": "0612345678",
  "isAvailable": true // Pour les techniciens
}
```

### Delete User (Admin)
```http
DELETE /users/:id
Authorization: Bearer <token>
```

## Appointment Endpoints

### Create Appointment
```http
POST /appointments
Authorization: Bearer <token>
Content-Type: application/json

{
  "deviceType": "smartphone",
  "brand": "iPhone",
  "model": "13 Pro",
  "issueDescription": "Écran cassé",
  "preferredDate": "2024-01-15T10:00:00.000Z",
  "preferredTime": "afternoon",
  "address": {
    "street": "10 rue de la Paix",
    "city": "Paris",
    "postalCode": "75001"
  }
}
```

### Get Appointments
```http
GET /appointments?status=pending&page=1&limit=10
Authorization: Bearer <token>
```

### Get Appointment by ID
```http
GET /appointments/:id
Authorization: Bearer <token>
```

### Update Appointment
```http
PUT /appointments/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "confirmed",
  "scheduledDate": "2024-01-15T14:00:00.000Z"
}
```

### Assign Technician
```http
PUT /appointments/:id/assign
Authorization: Bearer <token>
Content-Type: application/json

{
  "technicianId": "..."
}
```

### Cancel Appointment
```http
PUT /appointments/:id/cancel
Authorization: Bearer <token>
Content-Type: application/json

{
  "cancellationReason": "Client non disponible"
}
```

## Repair Endpoints

### Create Repair
```http
POST /repairs
Authorization: Bearer <token>
Content-Type: application/json

{
  "appointment": "appointment_id",
  "client": "client_id",
  "deviceType": "smartphone",
  "brand": "iPhone",
  "model": "13 Pro",
  "diagnosis": "Écran LCD défectueux",
  "repairDescription": "Remplacement de l'écran LCD",
  "partsUsed": [
    {
      "name": "Écran LCD iPhone 13 Pro",
      "quantity": 1,
      "unitPrice": 150,
      "totalPrice": 150
    }
  ],
  "laborCost": 50
}
```

### Get Repairs
```http
GET /repairs?status=completed&page=1&limit=10
Authorization: Bearer <token>
```

### Get Repair by ID
```http
GET /repairs/:id
Authorization: Bearer <token>
```

### Update Repair
```http
PUT /repairs/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "completed",
  "notes": "Réparation effectuée avec succès"
}
```

### Complete Repair
```http
PUT /repairs/:id/complete
Authorization: Bearer <token>
```

## Offer Endpoints

### Create Offer (Admin)
```http
POST /offers
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Réparation écran -30%",
  "description": "30% de réduction sur toutes les réparations d'écran",
  "deviceType": "smartphone",
  "originalPrice": 150,
  "discountedPrice": 105,
  "validFrom": "2024-01-01T00:00:00.000Z",
  "validUntil": "2024-01-31T23:59:59.000Z",
  "promoCode": "ECRAN30",
  "maxRedemptions": 100
}
```

### Get Offers
```http
GET /offers?deviceType=smartphone&active=true&page=1&limit=10
```

### Get Offer by ID
```http
GET /offers/:id
```

### Get Offer by Promo Code
```http
GET /offers/code/ECRAN30
```

### Update Offer (Admin)
```http
PUT /offers/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "isActive": false
}
```

### Redeem Offer
```http
PUT /offers/:id/redeem
Authorization: Bearer <token>
```

## Notification Endpoints

### Create Notification
```http
POST /notifications
Authorization: Bearer <token>
Content-Type: application/json

{
  "recipient": "user_id",
  "type": "appointment_confirmed",
  "title": "Rendez-vous confirmé",
  "message": "Votre rendez-vous a été confirmé pour le 15/01/2024",
  "data": {
    "appointmentId": "..."
  }
}
```

### Get Notifications
```http
GET /notifications?isRead=false&page=1&limit=20
Authorization: Bearer <token>
```

### Mark as Read
```http
PUT /notifications/:id/read
Authorization: Bearer <token>
```

### Mark All as Read
```http
PUT /notifications/read-all
Authorization: Bearer <token>
```

### Delete Notification
```http
DELETE /notifications/:id
Authorization: Bearer <token>
```

## Statistics Endpoints

### Get Dashboard Stats (Admin)
```http
GET /stats/dashboard
Authorization: Bearer <token>
```

Response:
```json
{
  "success": true,
  "data": {
    "users": {
      "totalClients": 1234,
      "totalTechnicians": 45,
      "availableTechnicians": 32
    },
    "appointments": {
      "total": 567,
      "pending": 12,
      "confirmed": 23,
      "completed": 450
    },
    "repairs": {
      "total": 450,
      "inProgress": 15,
      "completed": 435
    },
    "revenue": {
      "total": 125000
    },
    "recentAppointments": [...],
    "monthlyStats": [...]
  }
}
```

### Get Technician Stats
```http
GET /stats/technician/:id
Authorization: Bearer <token>
```

## Error Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request (validation error) |
| 401 | Unauthorized (token missing/invalid) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 429 | Too Many Requests (rate limit) |
| 500 | Internal Server Error |

## Rate Limiting

- 100 requêtes par 15 minutes par IP
- Header `X-RateLimit-Remaining` indique le nombre de requêtes restantes

## Pagination

Les endpoints avec pagination retournent :
```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "total": 150,
    "page": 1,
    "pages": 15
  }
}
```

## Device Types

- `smartphone`
- `computer`
- `tablet`
- `appliance`
- `other`

## Appointment Status

- `pending` - En attente
- `confirmed` - Confirmé
- `in_progress` - En cours
- `completed` - Terminé
- `cancelled` - Annulé

## Repair Status

- `in_progress` - En cours
- `completed` - Terminée
- `failed` - Échec
- `pending_parts` - En attente de pièces

## User Roles

- `client` - Client
- `technician` - Technicien
- `admin` - Administrateur
