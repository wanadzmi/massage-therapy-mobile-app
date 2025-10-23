part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const OTP_VERIFICATION = _Paths.OTP_VERIFICATION;
  static const AUTH = _Paths.AUTH;
  static const BOOKING = _Paths.BOOKING;
  static const SERVICES = _Paths.SERVICES;
  static const PROFILE = _Paths.PROFILE;
  static const FIND_STORE = _Paths.FIND_STORE;
  static const STORE_DETAIL = _Paths.STORE_DETAIL;
  static const THERAPIST_SELECTION = _Paths.THERAPIST_SELECTION;
  static const BOOKING_CREATE = _Paths.BOOKING_CREATE;
  static const BOOKING_DETAIL = _Paths.BOOKING_DETAIL;
  static const WALLET_TOPUP = _Paths.WALLET_TOPUP;
  static const WALLET_USDT_PAYMENT = _Paths.WALLET_USDT_PAYMENT;
  static const WALLET_PAYMENT_PENDING = _Paths.WALLET_PAYMENT_PENDING;
  static const TRANSACTION_HISTORY = _Paths.TRANSACTION_HISTORY;
  static const CHAT = _Paths.CHAT;
  static const WRITE_REVIEW = _Paths.WRITE_REVIEW;
  static const MY_REVIEWS = _Paths.MY_REVIEWS;
  static const TIER_SUBSCRIPTION = _Paths.TIER_SUBSCRIPTION;
  static const TIER_DETAIL = _Paths.TIER_DETAIL;
  static const THERAPIST_HOME = _Paths.THERAPIST_HOME;
  static const THERAPIST_TODAY_SUMMARY = _Paths.THERAPIST_TODAY_SUMMARY;
  static const THERAPIST_BOOKING_DETAIL = _Paths.THERAPIST_BOOKING_DETAIL;
  static const THERAPIST_PROFILE = _Paths.THERAPIST_PROFILE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const NOTIFICATION_PREFERENCES = _Paths.NOTIFICATION_PREFERENCES;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const OTP_VERIFICATION = '/otp-verification';
  static const AUTH = '/auth';
  static const BOOKING = '/booking';
  static const SERVICES = '/services';
  static const PROFILE = '/profile';
  static const FIND_STORE = '/find-store';
  static const STORE_DETAIL = '/store-detail';
  static const THERAPIST_SELECTION = '/therapist-selection';
  static const BOOKING_CREATE = '/booking-create';
  static const BOOKING_DETAIL = '/booking-detail';
  static const WALLET_TOPUP = '/wallet-topup';
  static const WALLET_USDT_PAYMENT = '/wallet-usdt-payment';
  static const WALLET_PAYMENT_PENDING = '/wallet-payment-pending';
  static const TRANSACTION_HISTORY = '/transaction-history';
  static const CHAT = '/chat';
  static const WRITE_REVIEW = '/write-review';
  static const MY_REVIEWS = '/my-reviews';
  static const TIER_SUBSCRIPTION = '/tier-subscription';
  static const TIER_DETAIL = '/tier-detail';
  static const THERAPIST_HOME = '/therapist-home';
  static const THERAPIST_TODAY_SUMMARY = '/therapist-today-summary';
  static const THERAPIST_BOOKING_DETAIL = '/therapist-booking-detail';
  static const THERAPIST_PROFILE = '/therapist-profile';
  static const NOTIFICATION = '/notifications';
  static const NOTIFICATION_PREFERENCES = '/notification-preferences';
}
