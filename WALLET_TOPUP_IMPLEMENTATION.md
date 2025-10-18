# Wallet Top-Up Implementation

## Overview
Complete wallet top-up feature integrated with payment gateway support for FPX online banking, Touch 'n Go eWallet, and GrabPay.

## Features Implemented

### 1. **Wallet Service** (`lib/app/data/services/wallet_service.dart`)
- **Initiate Top-Up**: POST `/api/wallet/top-up`
  - Parameters: `amount`, `paymentMethod`, `bankCode` (optional)
  - Returns: `transactionId`, `paymentId`, `paymentUrl`, `requiresRedirect`
  
- **Confirm Top-Up**: POST `/api/wallet/top-up/confirm`
  - Parameters: `paymentId`, `gatewayTransactionId`, `amount`, `status`
  - Returns: `status`, `processed`

### 2. **Controller** (`lib/app/modules/wallet_topup/controllers/wallet_topup_controller.dart`)
Features:
- **Predefined amounts**: RM 50, 100, 200, 500, 1000, 2000
- **Custom amount input** with minimum RM 10 validation
- **Payment methods**:
  - FPX Online Banking (with bank selection)
  - Touch 'n Go eWallet
  - GrabPay
- **Bank selection** for FPX (8 major Malaysian banks)
- **Payment gateway integration**:
  - Opens payment URL in external browser
  - Waiting dialog with "Cancel" and "I've Paid" options
  - Automatic confirmation flow
  - Success dialog with amount display
- **Error handling** with user-friendly messages

### 3. **View** (`lib/app/modules/wallet_topup/views/wallet_topup_view.dart`)
UI Components:
- **Amount Selection Section**:
  - Grid of predefined amount chips
  - Custom amount input field with prefix icon
  
- **Payment Method Section**:
  - Radio-style selection cards
  - Bank selection dropdown for FPX
  - Icons for each payment method
  
- **Bottom Action Bar**:
  - "Proceed to Payment" button
  - Fixed position with safe area padding
  - Loading state support

- **Design**:
  - Dark theme (0xFF0A0A0A background)
  - Gold accents (0xFFD4AF37)
  - Smooth animations and feedback

### 4. **Integration**
- **Routes**: Added `/wallet-topup` route to `app_routes.dart` and `app_pages.dart`
- **Booking Error Dialog**: "Top Up Wallet" button navigates to wallet page on insufficient balance error
- **Dependencies**: Added `url_launcher: ^6.3.1` for payment gateway redirect

## User Flow

### Top-Up Flow:
1. User encounters "Insufficient Balance" error during booking
2. Clicks "Top Up Wallet" button in error dialog
3. Redirected to wallet top-up page
4. Selects amount (predefined or custom)
5. Selects payment method
6. For FPX: Selects bank
7. Clicks "Proceed to Payment"
8. Opens payment gateway in browser
9. Completes payment
10. Returns to app and clicks "I've Paid"
11. Backend confirms payment
12. Success dialog shows
13. Returns to previous page

### Payment Confirmation Flow:
- **With Redirect**: Opens external browser → User pays → Returns → Confirms
- **Without Redirect**: Auto-confirmation for testing/specific methods

## Files Created/Modified

### New Files:
- `lib/app/data/services/wallet_service.dart` - API integration
- `lib/app/modules/wallet_topup/controllers/wallet_topup_controller.dart` - Business logic
- `lib/app/modules/wallet_topup/views/wallet_topup_view.dart` - UI
- `lib/app/modules/wallet_topup/bindings/wallet_topup_binding.dart` - Dependency injection
- `lib/app/modules/wallet_topup/wallet_topup_module.dart` - Module exports

### Modified Files:
- `pubspec.yaml` - Added url_launcher dependency
- `lib/app/routes/app_routes.dart` - Added WALLET_TOPUP route
- `lib/app/routes/app_pages.dart` - Added wallet top-up page configuration
- `lib/app/modules/booking_create/controllers/booking_create_controller.dart` - Updated error dialog to navigate to wallet

## API Specifications

### Initiate Top-Up
```dart
POST /api/wallet/top-up
{
  "amount": 100.0,
  "paymentMethod": "fpx",
  "bankCode": "MBB"  // Optional, required for FPX
}

Response:
{
  "transactionId": "txn_123",
  "paymentId": "pay_456",
  "amount": 100.0,
  "method": "fpx",
  "status": "pending",
  "requiresRedirect": true,
  "paymentUrl": "https://payment-gateway.example.com/..."
}
```

### Confirm Top-Up
```dart
POST /api/wallet/top-up/confirm
{
  "paymentId": "pay_456",
  "gatewayTransactionId": "txn_123",
  "amount": 100.0,
  "status": "success"
}

Response:
{
  "status": "OK",
  "processed": true
}
```

## Validation Rules

1. **Minimum Amount**: RM 10
2. **Payment Method**: Required selection
3. **Bank Selection**: Required for FPX payment method
4. **Custom Amount**: Must be numeric digits only

## Error Handling

- Invalid/missing amount → Snackbar notification
- Below minimum amount → Warning snackbar
- Missing bank for FPX → Prompt snackbar
- API errors → Error dialog with message
- Payment cancellation → Cancellation snackbar
- Confirmation failure → Error notification

## Future Enhancements

1. **Payment History**: Show previous top-up transactions
2. **Saved Banks**: Remember user's preferred bank
3. **Quick Top-Up**: One-tap top-up with saved settings
4. **Promo Codes**: Apply discount codes during top-up
5. **Auto Top-Up**: Automatic top-up when balance is low
6. **Receipt/Invoice**: Generate PDF receipt after successful top-up
7. **Multiple Payment Gateways**: Support for additional payment providers
8. **Wallet Balance Display**: Show current balance on top-up page

## Testing Checklist

- [ ] Top-up with predefined amounts (RM 50, 100, 200, 500, 1000, 2000)
- [ ] Top-up with custom amount
- [ ] Minimum amount validation (RM 10)
- [ ] FPX payment with all 8 banks
- [ ] Touch 'n Go eWallet payment
- [ ] GrabPay payment
- [ ] Payment gateway redirect
- [ ] Payment confirmation flow
- [ ] Payment cancellation
- [ ] Success dialog display
- [ ] Navigation back after success
- [ ] Error handling for API failures
- [ ] Insufficient balance error → Top-up navigation

## Notes

- Payment gateway integration uses `url_launcher` for external browser
- Dialog cannot be dismissed during payment processing
- Transaction details stored in controller for confirmation
- Success callback returns to previous page automatically
- All monetary values use double precision
- Bank codes are Malaysian banking standard codes
