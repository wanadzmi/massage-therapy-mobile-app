// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Therapy & Massage App';

  @override
  String get home => 'Home';

  @override
  String get activity => 'Activity';

  @override
  String get profile => 'Profile';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get pleaseSignIn => 'Please sign in to continue';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get topUp => 'Top Up';

  @override
  String get history => 'History';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get findStore => 'Find Store';

  @override
  String get findTherapist => 'Find Therapist';

  @override
  String get discoverNearestStores =>
      'Discover the nearest massage therapy stores';

  @override
  String get browseAvailableTherapists =>
      'Browse available therapists and book appointments';

  @override
  String get yourAppointments => 'Your Appointments';

  @override
  String get filter => 'Filter';

  @override
  String get filterOptions => 'Filter options coming soon!';

  @override
  String get noAppointments => 'No appointments for selected date';

  @override
  String get appointmentDetails => 'Appointment Details';

  @override
  String get viewDetails => 'View details coming soon!';

  @override
  String get confirmed => 'CONFIRMED';

  @override
  String get pending => 'PENDING';

  @override
  String get cancelled => 'CANCELLED';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get loginError => 'Login failed. Please try again.';

  @override
  String get logoutSuccess => 'Logged out successfully';

  @override
  String get roleError => 'Only customers can login to this app';
}
