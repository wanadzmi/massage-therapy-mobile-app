# Wallet Top-Up Testing Guide

## Prerequisites

Before testing, ensure:
1. ✅ Backend API is running: `https://massage-therapy-backend.onrender.com`
2. ✅ You have a valid user account and are logged in
3. ✅ App is running on simulator/device with internet connection

## Testing Methods

### Method 1: Test via Booking Flow (Recommended - Real Use Case)

This tests the complete integration from booking error to top-up.

**Steps:**
1. **Create a booking with insufficient balance:**
   ```
   Home → Find Store → Select Store → Select Service
   → Select Therapist & Time → Review Booking → Confirm Booking
   ```

2. **Trigger insufficient balance error:**
   - The booking will fail if your wallet balance is less than the service price
   - You should see an error dialog with:
     - Title: "Insufficient Wallet Balance"
     - Orange wallet icon
     - Message about insufficient balance
     - Two buttons: "Cancel" and "Top Up Wallet"

3. **Click "Top Up Wallet" button**
   - Should navigate to wallet top-up page

4. **Complete the top-up flow** (see Method 2 below for details)

---

### Method 2: Direct Navigation to Wallet Top-Up

You can directly test the wallet page by navigating to it.

**Option A: Add a temporary test button**

Add this to your profile page or home page temporarily:

```dart
ElevatedButton(
  onPressed: () => Get.toNamed('/wallet-topup'),
  child: const Text('Test Wallet Top-Up'),
)
```

**Option B: Use GetX navigation from anywhere**

In any controller or view, add:
```dart
Get.toNamed('/wallet-topup');
```

**Option C: Modify your app to show it in the UI**

Add a wallet/top-up option to your profile page menu.

---

## Testing the Top-Up Flow

Once you're on the wallet top-up page:

### Test Case 1: Predefined Amounts
1. **Select a predefined amount** (RM 50, 100, 200, 500, 1000, or 2000)
   - Chip should highlight in gold
   - Previous selection should deselect

2. **Select payment method:**
   - Choose "FPX Online Banking"
   - Bank selection should appear

3. **Select bank:**
   - Choose any bank (e.g., "Maybank")
   - Bank should highlight

4. **Click "Proceed to Payment"**
   - Should show loading spinner
   - Backend will create transaction

### Test Case 2: Custom Amount
1. **Click on custom amount field**
2. **Enter amount** (e.g., 150)
   - Only digits should be allowed
   - Predefined amounts should deselect

3. **Test validation:**
   - Try entering 5 (below minimum) → Should show error snackbar
   - Try entering 0 → Should show error snackbar
   - Enter 50 or more → Should proceed

### Test Case 3: Different Payment Methods
1. **Test FPX:**
   - Select "FPX Online Banking"
   - Bank selection should appear
   - Try without selecting bank → Should show error "Please select your bank"
   - Select bank → Should proceed

2. **Test Touch 'n Go:**
   - Select "Touch 'n Go eWallet"
   - Bank selection should hide
   - Should proceed without bank selection

3. **Test GrabPay:**
   - Select "GrabPay"
   - Bank selection should hide
   - Should proceed without bank selection

---

## Expected Backend Responses

### Scenario A: Successful Initiation (With Redirect)

**Request:**
```json
POST /api/wallet/top-up
{
  "amount": 100,
  "paymentMethod": "fpx",
  "bankCode": "MBB"
}
```

**Expected Response:**
```json
{
  "transactionId": "txn_abc123",
  "paymentId": "pay_xyz789",
  "amount": 100,
  "method": "fpx",
  "status": "pending",
  "requiresRedirect": true,
  "paymentUrl": "https://payment-gateway.example.com/pay?id=xyz789"
}
```

**App Behavior:**
- Opens payment URL in external browser (Safari/Chrome)
- Shows dialog: "Waiting for Payment"
- Dialog has "Cancel" and "I've Paid" buttons

### Scenario B: Payment Completion

After payment in browser, user returns to app:

1. **User clicks "I've Paid"**
   
   **Request:**
   ```json
   POST /api/wallet/top-up/confirm
   {
     "paymentId": "pay_xyz789",
     "gatewayTransactionId": "txn_abc123",
     "amount": 100,
     "status": "success"
   }
   ```

   **Expected Response:**
   ```json
   {
     "status": "OK",
     "processed": true
   }
   ```

   **App Behavior:**
   - Shows success dialog with green checkmark
   - Displays amount: "RM 100.00 has been added to your wallet"
   - "Done" button closes dialog and returns to previous page

2. **User clicks "Cancel"**
   - Shows snackbar: "Payment Cancelled"
   - Clears transaction data
   - Stays on top-up page

---

## Testing Checklist

### ✅ UI Tests
- [ ] All predefined amounts clickable and highlight correctly
- [ ] Custom amount field accepts only numbers
- [ ] Payment method cards highlight on selection
- [ ] Bank cards appear/hide based on payment method
- [ ] Bank selection highlights correctly
- [ ] Bottom button is always visible
- [ ] Loading spinner appears during API calls
- [ ] All text is readable on dark background

### ✅ Validation Tests
- [ ] Amount below RM 10 shows error
- [ ] Zero amount shows error
- [ ] Empty amount shows error
- [ ] FPX without bank selection shows error
- [ ] Valid inputs proceed successfully

### ✅ Navigation Tests
- [ ] Can navigate to top-up from booking error
- [ ] Back button returns to previous page
- [ ] Success dialog "Done" returns to previous page
- [ ] Cancel dialog returns to top-up page

### ✅ Payment Flow Tests
- [ ] Payment URL opens in external browser
- [ ] Waiting dialog appears
- [ ] "I've Paid" triggers confirmation
- [ ] "Cancel" cancels transaction
- [ ] Success dialog shows correct amount
- [ ] Success confirmation returns user

### ✅ Error Handling Tests
- [ ] Network error shows error message
- [ ] Invalid API response shows error
- [ ] Backend validation errors display correctly
- [ ] Payment failure shows appropriate message

---

## Common Issues & Debugging

### Issue 1: "Top Up Wallet" button doesn't navigate
**Debug:**
```dart
// Check in booking_create_controller.dart
// Should have:
Get.toNamed('/wallet-topup');
```

### Issue 2: Payment URL doesn't open
**Check:**
- `url_launcher` package installed?
- Run: `flutter pub get`
- Device has browser app?
- URL is valid HTTPS?

**Debug output:**
```dart
print('🔗 Payment URL: ${topUpData.paymentUrl}');
print('🔄 Requires Redirect: ${topUpData.requiresRedirect}');
```

### Issue 3: Confirmation fails
**Check console logs:**
```dart
print('✅ Top-up initiated: ${topUpData.paymentId}');
print('💰 Amount: ${currentAmount}');
print('🆔 Transaction: ${currentTransactionId}');
```

### Issue 4: Blank/white screen on navigation
**Verify route is registered:**
```dart
// In app_pages.dart
GetPage(
  name: _Paths.WALLET_TOPUP,
  page: () => const WalletTopupView(),
  binding: WalletTopupBinding(),
),
```

---

## Testing with Backend Logs

Monitor backend logs for:
```
POST /api/wallet/top-up - User initiated top-up
POST /api/wallet/top-up/confirm - Payment confirmed
```

Check response status codes:
- `200` - Success
- `400` - Validation error (check your input)
- `401` - Unauthorized (login again)
- `500` - Server error (backend issue)

---

## Quick Test Commands

### Test in Flutter DevTools Console:
```dart
// Navigate directly
Get.toNamed('/wallet-topup');

// Check if route exists
Get.routing.routes.forEach((route) => print(route.name));
```

### Test API directly with curl:
```bash
# Initiate top-up
curl -X POST https://massage-therapy-backend.onrender.com/api/wallet/top-up \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "amount": 100,
    "paymentMethod": "fpx",
    "bankCode": "MBB"
  }'

# Confirm top-up
curl -X POST https://massage-therapy-backend.onrender.com/api/wallet/top-up/confirm \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "paymentId": "pay_123",
    "gatewayTransactionId": "txn_456",
    "amount": 100,
    "status": "success"
  }'
```

---

## Mock Testing (Without Real Payment)

If backend returns `requiresRedirect: false`, the app will auto-confirm after 1 second:

```dart
// In controller, this line handles mock mode:
if (topUpData.requiresRedirect == false) {
  await _autoConfirmPayment();
}
```

This is useful for testing the confirmation flow without actual payment gateway.

---

## Video Recording Checklist

For demonstrating the feature:
1. Show booking with insufficient balance error
2. Click "Top Up Wallet"
3. Select amount (try both predefined and custom)
4. Select payment method
5. For FPX: Select bank
6. Click proceed
7. Show payment dialog
8. Click "I've Paid"
9. Show success dialog
10. Verify return to previous page

---

## Next Steps After Testing

Once basic testing is complete:
1. Test with real payment gateway (if integrated)
2. Test on different devices (iOS/Android)
3. Test with slow network (network throttling)
4. Test with backend errors (disconnect backend)
5. Test concurrent top-ups
6. Load test multiple rapid clicks
7. Test back button during payment
8. Test app kill during payment

---

## Support

If you encounter issues:
1. Check Flutter console for errors
2. Check backend logs
3. Verify API endpoints are correct
4. Ensure authentication token is valid
5. Check network connectivity
6. Verify all dependencies installed (`flutter pub get`)
