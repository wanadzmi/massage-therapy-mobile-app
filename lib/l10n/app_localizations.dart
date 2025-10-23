import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Therapy & Massage App'**
  String get appTitle;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Activity navigation label
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Welcome message on login page
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Login instruction text
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get pleaseSignIn;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Wallet balance label
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// Top up button text
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;

  /// History button text
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Find store card title
  ///
  /// In en, this message translates to:
  /// **'Find Store'**
  String get findStore;

  /// Find therapist card title
  ///
  /// In en, this message translates to:
  /// **'Find Therapist'**
  String get findTherapist;

  /// Find store card description
  ///
  /// In en, this message translates to:
  /// **'Discover the nearest massage therapy stores'**
  String get discoverNearestStores;

  /// Find therapist card description
  ///
  /// In en, this message translates to:
  /// **'Browse available therapists and book appointments'**
  String get browseAvailableTherapists;

  /// Appointments list title
  ///
  /// In en, this message translates to:
  /// **'Your Appointments'**
  String get yourAppointments;

  /// Filter button text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Filter snackbar message
  ///
  /// In en, this message translates to:
  /// **'Filter options coming soon!'**
  String get filterOptions;

  /// Empty appointments message
  ///
  /// In en, this message translates to:
  /// **'No appointments for selected date'**
  String get noAppointments;

  /// Appointment details title
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get appointmentDetails;

  /// View details snackbar message
  ///
  /// In en, this message translates to:
  /// **'View details coming soon!'**
  String get viewDetails;

  /// Confirmed appointment status
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get confirmed;

  /// Pending appointment status
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get pending;

  /// Cancelled appointment status
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get cancelled;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginError;

  /// Logout success message
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// Role validation error message
  ///
  /// In en, this message translates to:
  /// **'Only customers can login to this app'**
  String get roleError;

  /// Account settings section title
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Preferences section title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Support section title
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Personal information menu
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Personal information description
  ///
  /// In en, this message translates to:
  /// **'Update your personal details'**
  String get updatePersonalDetails;

  /// Booking history menu
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get bookingHistory;

  /// Booking history description
  ///
  /// In en, this message translates to:
  /// **'View all your past bookings'**
  String get viewPastBookings;

  /// Payment methods menu
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Payment methods description
  ///
  /// In en, this message translates to:
  /// **'Manage your payment options'**
  String get managePaymentOptions;

  /// Payment methods snackbar
  ///
  /// In en, this message translates to:
  /// **'Payment methods coming soon!'**
  String get paymentMethodsComingSoon;

  /// Notifications menu
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications description
  ///
  /// In en, this message translates to:
  /// **'Manage notification settings'**
  String get manageNotifications;

  /// Notifications snackbar
  ///
  /// In en, this message translates to:
  /// **'Notification settings coming soon!'**
  String get notificationsComingSoon;

  /// Language description
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// Help center menu
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// Help center description
  ///
  /// In en, this message translates to:
  /// **'Get help with any issues'**
  String get getHelpWithIssues;

  /// Help center snackbar
  ///
  /// In en, this message translates to:
  /// **'Help center coming soon!'**
  String get helpCenterComingSoon;

  /// Contact support menu
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Contact support description
  ///
  /// In en, this message translates to:
  /// **'Reach out to our support team'**
  String get reachSupportTeam;

  /// Terms and privacy menu
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsAndPrivacy;

  /// Terms and privacy description
  ///
  /// In en, this message translates to:
  /// **'Read our terms and privacy policy'**
  String get readTermsAndPrivacy;

  /// Terms snackbar
  ///
  /// In en, this message translates to:
  /// **'Terms and privacy policy coming soon!'**
  String get termsComingSoon;

  /// Total bookings label
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// Completed label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Loyalty points title
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get loyaltyPoints;

  /// Earn rewards description
  ///
  /// In en, this message translates to:
  /// **'Earn rewards with every booking'**
  String get earnRewards;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Earned label
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// Redeemed label
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemed;

  /// Referral code title
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// Successful label
  ///
  /// In en, this message translates to:
  /// **'successful'**
  String get successful;

  /// Copied title
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// Referral code copied message
  ///
  /// In en, this message translates to:
  /// **'Referral code copied to clipboard'**
  String get referralCodeCopied;

  /// Tier discount label
  ///
  /// In en, this message translates to:
  /// **'Tier Discount'**
  String get tierDiscount;

  /// Referral earnings label
  ///
  /// In en, this message translates to:
  /// **'Referral Earnings'**
  String get referralEarnings;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Select language dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Malay language option
  ///
  /// In en, this message translates to:
  /// **'Bahasa Melayu'**
  String get malay;

  /// Chinese language option
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// Language changed message
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChanged(String language);

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Singular booking
  ///
  /// In en, this message translates to:
  /// **'booking'**
  String get booking;

  /// Plural bookings
  ///
  /// In en, this message translates to:
  /// **'bookings'**
  String get bookings;

  /// Filtered label
  ///
  /// In en, this message translates to:
  /// **'Filtered'**
  String get filtered;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Tomorrow label
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Write review button
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get writeReview;

  /// Review submitted label
  ///
  /// In en, this message translates to:
  /// **'Review Submitted'**
  String get reviewSubmitted;

  /// Cancel booking button
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// Cannot cancel title
  ///
  /// In en, this message translates to:
  /// **'Cannot Cancel'**
  String get cannotCancel;

  /// Cannot cancel message
  ///
  /// In en, this message translates to:
  /// **'Bookings cannot be cancelled less than 1 hour before the start time'**
  String get cannotCancelMessage;

  /// Filter bookings title
  ///
  /// In en, this message translates to:
  /// **'Filter Bookings'**
  String get filterBookings;

  /// All bookings filter
  ///
  /// In en, this message translates to:
  /// **'All Bookings'**
  String get allBookings;

  /// In progress status
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Therapist label
  ///
  /// In en, this message translates to:
  /// **'Therapist'**
  String get therapist;

  /// Service label
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Overall rating title
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overallRating;

  /// Rating instruction text
  ///
  /// In en, this message translates to:
  /// **'Tap stars or use slider to rate'**
  String get tapStarsToRate;

  /// Detailed ratings section title
  ///
  /// In en, this message translates to:
  /// **'Detailed Ratings'**
  String get detailedRatings;

  /// Technique rating label
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get technique;

  /// Professionalism rating label
  ///
  /// In en, this message translates to:
  /// **'Professionalism'**
  String get professionalism;

  /// Cleanliness rating label
  ///
  /// In en, this message translates to:
  /// **'Cleanliness'**
  String get cleanliness;

  /// Comfort rating label
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get comfort;

  /// Value for money rating label
  ///
  /// In en, this message translates to:
  /// **'Value for Money'**
  String get valueForMoney;

  /// Review title field label
  ///
  /// In en, this message translates to:
  /// **'Title (Optional)'**
  String get titleOptional;

  /// Review title field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Amazing Experience!'**
  String get titleHint;

  /// Review content field label
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// Review content field hint
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get shareExperience;

  /// Review required error message
  ///
  /// In en, this message translates to:
  /// **'Please write your review'**
  String get pleaseWriteReview;

  /// Review minimum length error
  ///
  /// In en, this message translates to:
  /// **'Review must be at least 10 characters'**
  String get reviewMinLength;

  /// Pros field label
  ///
  /// In en, this message translates to:
  /// **'What was good? (Optional)'**
  String get whatWasGood;

  /// Pros field hint
  ///
  /// In en, this message translates to:
  /// **'Professional, Clean, Relaxing (comma separated)'**
  String get prosHint;

  /// Cons field label
  ///
  /// In en, this message translates to:
  /// **'What could improve? (Optional)'**
  String get whatCouldImprove;

  /// Cons field hint
  ///
  /// In en, this message translates to:
  /// **'Parking, Wait time (comma separated)'**
  String get consHint;

  /// Submit review button
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// Edit profile page title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Date of birth field label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Gender dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Other gender option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Top up wallet page title
  ///
  /// In en, this message translates to:
  /// **'Top Up Wallet'**
  String get topUpWallet;

  /// Current balance label
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// Amount input label
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// Amount input label for USDT
  ///
  /// In en, this message translates to:
  /// **'Enter Amount (USD)'**
  String get enterAmountUsd;

  /// Loading exchange rate message
  ///
  /// In en, this message translates to:
  /// **'Loading exchange rate...'**
  String get loadingExchangeRate;

  /// Min/max amount limits
  ///
  /// In en, this message translates to:
  /// **'Minimum: RM10 | Maximum: RM5,000'**
  String get minimumMaximum;

  /// Payment method selection label
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Test payment method name
  ///
  /// In en, this message translates to:
  /// **'Test Payment'**
  String get testPayment;

  /// Test payment method description
  ///
  /// In en, this message translates to:
  /// **'Instant credit (Testing only)'**
  String get testPaymentDesc;

  /// USDT TRC20 payment method name
  ///
  /// In en, this message translates to:
  /// **'USDT (TRC20)'**
  String get usdtTrc20;

  /// USDT TRC20 payment method description
  ///
  /// In en, this message translates to:
  /// **'Cryptocurrency on Tron Network'**
  String get usdtTrc20Desc;

  /// Online banking payment method name
  ///
  /// In en, this message translates to:
  /// **'Online Banking'**
  String get onlineBanking;

  /// Online banking payment method description
  ///
  /// In en, this message translates to:
  /// **'FPX Payment Gateway'**
  String get onlineBankingDesc;

  /// Touch n Go payment method name
  ///
  /// In en, this message translates to:
  /// **'Touch n Go'**
  String get touchNGo;

  /// Touch n Go payment method description
  ///
  /// In en, this message translates to:
  /// **'eWallet Payment'**
  String get touchNGoDesc;

  /// Instant badge text
  ///
  /// In en, this message translates to:
  /// **'INSTANT'**
  String get instant;

  /// Crypto badge text
  ///
  /// In en, this message translates to:
  /// **'CRYPTO'**
  String get crypto;

  /// Coming soon badge text
  ///
  /// In en, this message translates to:
  /// **'COMING SOON'**
  String get comingSoon;

  /// Invalid amount error title
  ///
  /// In en, this message translates to:
  /// **'Invalid Amount'**
  String get invalidAmount;

  /// Invalid amount error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// Minimum amount validation
  ///
  /// In en, this message translates to:
  /// **'Minimum top-up amount is RM10'**
  String get minimumTopUpAmount;

  /// Maximum amount validation
  ///
  /// In en, this message translates to:
  /// **'Maximum top-up amount is RM5,000'**
  String get maximumTopUpAmount;

  /// Payment method required title
  ///
  /// In en, this message translates to:
  /// **'Payment Method Required'**
  String get paymentMethodRequired;

  /// Payment method required message
  ///
  /// In en, this message translates to:
  /// **'Please select a payment method'**
  String get pleaseSelectPaymentMethod;

  /// Top-up failed title
  ///
  /// In en, this message translates to:
  /// **'Top-Up Failed'**
  String get topUpFailed;

  /// Top-up failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to initiate top-up'**
  String get failedToInitiateTopUp;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// Top-up success title
  ///
  /// In en, this message translates to:
  /// **'Top-Up Successful!'**
  String get topUpSuccessful;

  /// Credited to wallet message
  ///
  /// In en, this message translates to:
  /// **'has been credited to your wallet'**
  String get creditedToWallet;

  /// New balance label
  ///
  /// In en, this message translates to:
  /// **'New Balance'**
  String get newBalance;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Payment confirmed title
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmed!'**
  String get paymentConfirmed;

  /// Payment failed title
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// Payment failed message
  ///
  /// In en, this message translates to:
  /// **'Your payment could not be processed. Please try again.'**
  String get paymentCouldNotBeProcessed;

  /// Payment pending title
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPending;

  /// Payment pending message
  ///
  /// In en, this message translates to:
  /// **'Payment confirmation is taking longer than expected. Please check your transaction history.'**
  String get paymentTakingLonger;

  /// Coming soon payment method message
  ///
  /// In en, this message translates to:
  /// **'will be available soon'**
  String get willBeAvailableSoon;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ms', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
