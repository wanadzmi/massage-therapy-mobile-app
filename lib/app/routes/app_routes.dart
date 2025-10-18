part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const AUTH = _Paths.AUTH;
  static const BOOKING = _Paths.BOOKING;
  static const SERVICES = _Paths.SERVICES;
  static const PROFILE = _Paths.PROFILE;
  static const FIND_STORE = _Paths.FIND_STORE;
  static const STORE_DETAIL = _Paths.STORE_DETAIL;
  static const THERAPIST_SELECTION = _Paths.THERAPIST_SELECTION;
  static const BOOKING_CREATE = _Paths.BOOKING_CREATE;
  static const BOOKING_DETAIL = _Paths.BOOKING_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const AUTH = '/auth';
  static const BOOKING = '/booking';
  static const SERVICES = '/services';
  static const PROFILE = '/profile';
  static const FIND_STORE = '/find-store';
  static const STORE_DETAIL = '/store-detail';
  static const THERAPIST_SELECTION = '/therapist-selection';
  static const BOOKING_CREATE = '/booking-create';
  static const BOOKING_DETAIL = '/booking-detail';
}
