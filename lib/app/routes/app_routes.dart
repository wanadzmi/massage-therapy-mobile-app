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
  static const TRANSACTION_HISTORY = _Paths.TRANSACTION_HISTORY;
  static const CHAT = _Paths.CHAT;
  static const WRITE_REVIEW = _Paths.WRITE_REVIEW;
  static const MY_REVIEWS = _Paths.MY_REVIEWS;
  static const TIER_SUBSCRIPTION = _Paths.TIER_SUBSCRIPTION;
  static const TIER_DETAIL = _Paths.TIER_DETAIL;
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
  static const TRANSACTION_HISTORY = '/transaction-history';
  static const CHAT = '/chat';
  static const WRITE_REVIEW = '/write-review';
  static const MY_REVIEWS = '/my-reviews';
  static const TIER_SUBSCRIPTION = '/tier-subscription';
  static const TIER_DETAIL = '/tier-detail';
}
