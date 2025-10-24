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

  /// Exchange rate label
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get exchangeRate;

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

  /// USDT payment page title
  ///
  /// In en, this message translates to:
  /// **'USDT Payment'**
  String get usdtPayment;

  /// Amount to pay label
  ///
  /// In en, this message translates to:
  /// **'Amount to Pay'**
  String get amountToPay;

  /// USDT equivalent note
  ///
  /// In en, this message translates to:
  /// **'in USDT equivalent'**
  String get inUsdtEquivalent;

  /// How to pay section title
  ///
  /// In en, this message translates to:
  /// **'How to Pay'**
  String get howToPay;

  /// Payment instruction step 1
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code or copy the wallet address'**
  String get scanQrOrCopy;

  /// Payment instruction step 2
  ///
  /// In en, this message translates to:
  /// **'Open your USDT wallet (Trust Wallet, Binance, etc.)'**
  String get openUsdtWallet;

  /// Payment instruction step 3
  ///
  /// In en, this message translates to:
  /// **'Send the exact USDT amount to the address shown'**
  String get sendExactAmount;

  /// Payment instruction step 4
  ///
  /// In en, this message translates to:
  /// **'Wait for blockchain confirmation (5-10 minutes)'**
  String get waitForConfirmation;

  /// QR code label
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// Copy address instruction
  ///
  /// In en, this message translates to:
  /// **'(Copy address below)'**
  String get copyAddressBelow;

  /// Wallet address label
  ///
  /// In en, this message translates to:
  /// **'Wallet Address'**
  String get walletAddress;

  /// Network label
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Network warning message
  ///
  /// In en, this message translates to:
  /// **'Only send USDT via {network} network'**
  String onlySendUsdtVia(String network);

  /// Important label
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// USDT payment warnings
  ///
  /// In en, this message translates to:
  /// **'• Only send USDT cryptocurrency to this address\n• Sending other tokens will result in loss of funds\n• Wrong network will result in permanent loss\n• Minimum amount: equivalent to RM10'**
  String get usdtWarnings;

  /// Payment sent confirmation button
  ///
  /// In en, this message translates to:
  /// **'I Have Sent the Payment'**
  String get iHaveSentPayment;

  /// Payment pending page title
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPendingTitle;

  /// Leave page dialog title
  ///
  /// In en, this message translates to:
  /// **'Leave this page?'**
  String get leaveThisPage;

  /// Leave page dialog content
  ///
  /// In en, this message translates to:
  /// **'Your payment is still being confirmed. You can check the status in your transaction history.'**
  String get paymentStillBeingConfirmed;

  /// Stay button
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// Leave button
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// Waiting for confirmation title
  ///
  /// In en, this message translates to:
  /// **'Waiting for Confirmation'**
  String get waitingForConfirmation;

  /// Payment confirmation description
  ///
  /// In en, this message translates to:
  /// **'We are waiting for your payment to be confirmed on the blockchain. This usually takes 5-10 minutes.'**
  String get waitingForPaymentConfirmation;

  /// Payment sent status
  ///
  /// In en, this message translates to:
  /// **'Payment Sent'**
  String get paymentSent;

  /// Transaction initiated subtitle
  ///
  /// In en, this message translates to:
  /// **'Transaction initiated'**
  String get transactionInitiated;

  /// Blockchain confirmation status
  ///
  /// In en, this message translates to:
  /// **'Blockchain Confirmation'**
  String get blockchainConfirmation;

  /// Waiting for network confirmation subtitle
  ///
  /// In en, this message translates to:
  /// **'Waiting for network confirmation'**
  String get waitingForNetworkConfirmation;

  /// Credit to wallet status
  ///
  /// In en, this message translates to:
  /// **'Credit to Wallet'**
  String get creditToWallet;

  /// Funds will be available subtitle
  ///
  /// In en, this message translates to:
  /// **'Funds will be available'**
  String get fundsWillBeAvailable;

  /// Transaction ID label
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// Safe close page info message
  ///
  /// In en, this message translates to:
  /// **'You can safely close this page. We will notify you once the payment is confirmed.'**
  String get safelyClosePage;

  /// My reviews menu title
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get myReviews;

  /// My reviews menu description
  ///
  /// In en, this message translates to:
  /// **'View your past reviews'**
  String get viewYourPastReviews;

  /// Membership tier label
  ///
  /// In en, this message translates to:
  /// **'Membership Tier'**
  String get membershipTier;

  /// Upgrade button text
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// Manage button text
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// Membership tiers page title
  ///
  /// In en, this message translates to:
  /// **'Membership Tiers'**
  String get membershipTiers;

  /// Current tier label
  ///
  /// In en, this message translates to:
  /// **'Current Tier'**
  String get currentTier;

  /// Wallet label
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Current badge text
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get current;

  /// Per month suffix
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// Cashback label
  ///
  /// In en, this message translates to:
  /// **'Cashback'**
  String get cashback;

  /// View tier details button
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewTierDetails;

  /// Invite only badge
  ///
  /// In en, this message translates to:
  /// **'Invite Only'**
  String get inviteOnly;

  /// Not available badge
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// Top up and subscribe button
  ///
  /// In en, this message translates to:
  /// **'Top Up & Subscribe'**
  String get topUpAndSubscribe;

  /// Upgrade now button
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// Subscribe button
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// Insufficient balance dialog title
  ///
  /// In en, this message translates to:
  /// **'Insufficient Balance'**
  String get insufficientBalance;

  /// Need amount to subscribe message
  ///
  /// In en, this message translates to:
  /// **'You need {amount} to subscribe to {tierName} tier.'**
  String needToSubscribe(String amount, String tierName);

  /// Current balance label with amount
  ///
  /// In en, this message translates to:
  /// **'Current Balance: {balance}'**
  String currentBalanceLabel(String balance);

  /// Subscribe confirmation title
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {tierName}?'**
  String subscribeTo(String tierName);

  /// Subscription charge message
  ///
  /// In en, this message translates to:
  /// **'You will be charged {amount} for 1 month subscription.'**
  String subscriptionChargeMessage(String amount);

  /// New balance label with amount
  ///
  /// In en, this message translates to:
  /// **'New Balance: {balance}'**
  String newBalanceLabel(String balance);

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Subscription success title
  ///
  /// In en, this message translates to:
  /// **'Subscription Successful!'**
  String get subscriptionSuccessful;

  /// Valid until date message
  ///
  /// In en, this message translates to:
  /// **'Valid until: {date}'**
  String validUntil(String date);

  /// Great button text
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get great;

  /// Cannot subscribe error title
  ///
  /// In en, this message translates to:
  /// **'Cannot Subscribe'**
  String get cannotSubscribe;

  /// Already member message
  ///
  /// In en, this message translates to:
  /// **'You are already a {tierName} member'**
  String alreadyMember(String tierName);

  /// Tier not available message
  ///
  /// In en, this message translates to:
  /// **'This tier is not available for subscription'**
  String get tierNotAvailable;

  /// Subscription failed title
  ///
  /// In en, this message translates to:
  /// **'Subscription Failed'**
  String get subscriptionFailed;

  /// Failed to load tiers error
  ///
  /// In en, this message translates to:
  /// **'Failed to load tiers'**
  String get failedToLoadTiers;

  /// My subscription page title
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// No active subscription title
  ///
  /// In en, this message translates to:
  /// **'No Active Subscription'**
  String get noActiveSubscription;

  /// Subscribe to unlock benefits message
  ///
  /// In en, this message translates to:
  /// **'Subscribe to a tier to unlock exclusive benefits and rewards'**
  String get subscribeToUnlockBenefits;

  /// Browse tiers button
  ///
  /// In en, this message translates to:
  /// **'Browse Tiers'**
  String get browseTiers;

  /// Member since label
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(String date);

  /// Subscription status section title
  ///
  /// In en, this message translates to:
  /// **'Subscription Status'**
  String get subscriptionStatus;

  /// Started label
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// Expires label
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// Last renewed label
  ///
  /// In en, this message translates to:
  /// **'Last Renewed'**
  String get lastRenewed;

  /// Auto-renewal label
  ///
  /// In en, this message translates to:
  /// **'Auto-Renewal'**
  String get autoRenewal;

  /// Enabled status
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Disabled status
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Your benefits section title
  ///
  /// In en, this message translates to:
  /// **'Your Benefits'**
  String get yourBenefits;

  /// Cashback on all bookings benefit
  ///
  /// In en, this message translates to:
  /// **'Cashback on All Bookings'**
  String get cashbackOnAllBookings;

  /// Actions section title
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Renew now button
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get renewNow;

  /// Cancel subscription button
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// Transaction history section title
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No transactions message
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// Load more button
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// Renew subscription dialog title
  ///
  /// In en, this message translates to:
  /// **'Renew Subscription?'**
  String get renewSubscription;

  /// Renew charge message
  ///
  /// In en, this message translates to:
  /// **'You will be charged {amount} for another month of {tierName} membership.'**
  String renewChargeMessage(String amount, String tierName);

  /// Renew button
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get renew;

  /// Renewal successful title
  ///
  /// In en, this message translates to:
  /// **'Renewal Successful!'**
  String get renewalSuccessful;

  /// New expiry date message
  ///
  /// In en, this message translates to:
  /// **'New expiry date: {date}'**
  String newExpiryDate(String date);

  /// Renewal failed title
  ///
  /// In en, this message translates to:
  /// **'Renewal Failed'**
  String get renewalFailed;

  /// Failed to renew subscription message
  ///
  /// In en, this message translates to:
  /// **'Failed to renew subscription'**
  String get failedToRenewSubscription;

  /// Cancel subscription confirm dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription?'**
  String get cancelSubscriptionConfirm;

  /// Cancel subscription warning message
  ///
  /// In en, this message translates to:
  /// **'Your benefits will remain active until {date}. After that, you\'ll lose access to tier benefits.'**
  String cancelSubscriptionWarning(String date);

  /// Keep subscription button
  ///
  /// In en, this message translates to:
  /// **'Keep It'**
  String get keepIt;

  /// Cancel subscription confirm button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelIt;

  /// Subscription cancelled title
  ///
  /// In en, this message translates to:
  /// **'Subscription Cancelled'**
  String get subscriptionCancelled;

  /// Subscription cancelled message
  ///
  /// In en, this message translates to:
  /// **'Your subscription has been cancelled. Benefits remain active until expiry.'**
  String get subscriptionCancelledMessage;

  /// Cancellation failed title
  ///
  /// In en, this message translates to:
  /// **'Cancellation Failed'**
  String get cancellationFailed;

  /// Failed to cancel subscription message
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel subscription'**
  String get failedToCancelSubscription;

  /// Auto-renewal enabled snackbar
  ///
  /// In en, this message translates to:
  /// **'Auto-renewal enabled'**
  String get autoRenewalEnabled;

  /// Auto-renewal disabled snackbar
  ///
  /// In en, this message translates to:
  /// **'Auto-renewal disabled'**
  String get autoRenewalDisabled;

  /// Failed to update auto-renewal message
  ///
  /// In en, this message translates to:
  /// **'Failed to update auto-renewal'**
  String get failedToUpdateAutoRenewal;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Failed to load subscription error
  ///
  /// In en, this message translates to:
  /// **'Failed to load subscription details'**
  String get failedToLoadSubscription;

  /// Failed to load transaction history error
  ///
  /// In en, this message translates to:
  /// **'Failed to load transaction history'**
  String get failedToLoadHistory;

  /// No reviews empty state title
  ///
  /// In en, this message translates to:
  /// **'No Reviews Yet'**
  String get noReviewsYet;

  /// No reviews empty state message
  ///
  /// In en, this message translates to:
  /// **'Your reviews will appear here after you complete a booking'**
  String get reviewsWillAppearHere;

  /// Pros label
  ///
  /// In en, this message translates to:
  /// **'Pros'**
  String get pros;

  /// Cons label
  ///
  /// In en, this message translates to:
  /// **'Cons'**
  String get cons;

  /// Approved status
  ///
  /// In en, this message translates to:
  /// **'approved'**
  String get approved;

  /// Flagged status
  ///
  /// In en, this message translates to:
  /// **'flagged'**
  String get flagged;

  /// Rejected status
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get rejected;

  /// Discover header text
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// Wellness text
  ///
  /// In en, this message translates to:
  /// **'wellness'**
  String get wellness;

  /// With us text
  ///
  /// In en, this message translates to:
  /// **'with us!'**
  String get withUs;

  /// Hello greeting with name
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// Available balance label
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// Quick menu section title
  ///
  /// In en, this message translates to:
  /// **'Quick Menu'**
  String get quickMenu;

  /// Total credits label in transaction summary
  ///
  /// In en, this message translates to:
  /// **'Total Credits'**
  String get totalCredits;

  /// Total debits label in transaction summary
  ///
  /// In en, this message translates to:
  /// **'Total Debits'**
  String get totalDebits;

  /// Number of transactions count
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String transactionsCount(int count);

  /// Payment label
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Mark all notifications as read tooltip
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// Transactional category label
  ///
  /// In en, this message translates to:
  /// **'Transactional'**
  String get transactional;

  /// Promotional category label
  ///
  /// In en, this message translates to:
  /// **'Promotional'**
  String get promotional;

  /// Reminder category label
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// System category label
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Toggle to show unread notifications only
  ///
  /// In en, this message translates to:
  /// **'Show unread only'**
  String get showUnreadOnly;

  /// Empty state title for notifications
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// Empty state message for notifications
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get allCaughtUp;

  /// Empty state title for transaction history
  ///
  /// In en, this message translates to:
  /// **'No Transactions Yet'**
  String get noTransactionsYetHistory;

  /// Empty state message for transaction history
  ///
  /// In en, this message translates to:
  /// **'Your transaction history will appear here'**
  String get transactionHistoryWillAppearHere;

  /// Transaction details bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// Balance before transaction label
  ///
  /// In en, this message translates to:
  /// **'Balance Before'**
  String get balanceBefore;

  /// Balance after transaction label
  ///
  /// In en, this message translates to:
  /// **'Balance After'**
  String get balanceAfter;

  /// Payment gateway ID label
  ///
  /// In en, this message translates to:
  /// **'Gateway ID'**
  String get gatewayId;

  /// Error message when transactions fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load transactions'**
  String get failedToLoadTransactions;

  /// Error message when transaction history fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load transaction history'**
  String get failedToLoadTransactionHistory;

  /// Messages page title
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// New chat button tooltip
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// Active filter label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Closed filter label
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// Empty state title for chat list
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// Empty state message for chat list
  ///
  /// In en, this message translates to:
  /// **'Start a new chat to get support'**
  String get startNewChatToGetSupport;

  /// Start new chat button text
  ///
  /// In en, this message translates to:
  /// **'Start New Chat'**
  String get startNewChat;

  /// Default chat name
  ///
  /// In en, this message translates to:
  /// **'Support Chat'**
  String get supportChat;

  /// Support header question
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// Support response time message
  ///
  /// In en, this message translates to:
  /// **'We typically respond within minutes'**
  String get weTypicallyRespondWithinMinutes;

  /// Category selection label
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// General category
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Technical category
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get technical;

  /// Subject field label
  ///
  /// In en, this message translates to:
  /// **'Subject (Optional)'**
  String get subjectOptional;

  /// Subject field hint
  ///
  /// In en, this message translates to:
  /// **'Brief subject line...'**
  String get briefSubjectLine;

  /// Message field label
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// Required field indicator
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Message field hint
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or question in detail...\n\nMinimum 10 characters'**
  String get describeYourIssue;

  /// Support info message
  ///
  /// In en, this message translates to:
  /// **'Our support team will be notified immediately and will respond as soon as possible. You can view your conversation history in the chat screen.'**
  String get supportTeamNotified;

  /// Start chat button text
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// Default admin support name
  ///
  /// In en, this message translates to:
  /// **'Admin Support'**
  String get adminSupport;

  /// Online status
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Waiting status
  ///
  /// In en, this message translates to:
  /// **'Waiting for agent...'**
  String get waitingForAgent;

  /// Offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Close chat menu item
  ///
  /// In en, this message translates to:
  /// **'Close Chat'**
  String get closeChat;

  /// Closed chat banner message
  ///
  /// In en, this message translates to:
  /// **'This chat has been closed'**
  String get thisChatHasBeenClosed;

  /// Typing indicator text
  ///
  /// In en, this message translates to:
  /// **'Agent is typing...'**
  String get agentIsTyping;

  /// Empty chat state title
  ///
  /// In en, this message translates to:
  /// **'Start a Conversation'**
  String get startAConversation;

  /// Empty chat state message
  ///
  /// In en, this message translates to:
  /// **'Send a message to our support team\nWe typically reply within a few minutes'**
  String get sendMessageToSupport;

  /// Quick tips label
  ///
  /// In en, this message translates to:
  /// **'Quick Tips'**
  String get quickTips;

  /// Tip 1
  ///
  /// In en, this message translates to:
  /// **'Ask about bookings and services'**
  String get askAboutBookingsAndServices;

  /// Tip 2
  ///
  /// In en, this message translates to:
  /// **'Get help with payments'**
  String get getHelpWithPayments;

  /// Tip 3
  ///
  /// In en, this message translates to:
  /// **'Report any issues'**
  String get reportAnyIssues;

  /// Message input hint
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// Store search hint
  ///
  /// In en, this message translates to:
  /// **'Search stores by name...'**
  String get searchStoresByName;

  /// Clear all filters button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Empty state title when filters applied
  ///
  /// In en, this message translates to:
  /// **'No stores match your filters'**
  String get noStoresMatchYourFilters;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'No stores found'**
  String get noStoresFound;

  /// Empty state subtitle when filters applied
  ///
  /// In en, this message translates to:
  /// **'Try adjusting or clearing your filters'**
  String get tryAdjustingOrClearingFilters;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'No stores available at the moment'**
  String get noStoresAvailableAtTheMoment;

  /// Clear filters button
  ///
  /// In en, this message translates to:
  /// **'Clear All Filters'**
  String get clearAllFilters;

  /// Verified badge
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Open status badge
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openNow;

  /// Default store name
  ///
  /// In en, this message translates to:
  /// **'Unknown Store'**
  String get unknownStore;

  /// Singular service count
  ///
  /// In en, this message translates to:
  /// **'service'**
  String get serviceSingular;

  /// Plural services count
  ///
  /// In en, this message translates to:
  /// **'services'**
  String get servicesPlural;

  /// Get directions button
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// Results text singular
  ///
  /// In en, this message translates to:
  /// **'store found'**
  String get storeFoundSingular;

  /// Results text plural
  ///
  /// In en, this message translates to:
  /// **'stores found'**
  String get storesFoundPlural;

  /// Results pagination text
  ///
  /// In en, this message translates to:
  /// **'Showing {showing} of {total} stores • Page {currentPage} of {totalPages}'**
  String showingOfStores(
    int showing,
    int total,
    int currentPage,
    int totalPages,
  );

  /// Filter summary for city
  ///
  /// In en, this message translates to:
  /// **'in {city}'**
  String filteredLocation(String city);

  /// Filter summary for radius
  ///
  /// In en, this message translates to:
  /// **'within {radius}km'**
  String withinRadius(int radius);

  /// Filter summary for rating
  ///
  /// In en, this message translates to:
  /// **'{rating}+ stars'**
  String minRating(String rating);

  /// Nearby filter chip label
  ///
  /// In en, this message translates to:
  /// **'Nearby {radius}km'**
  String nearbyKm(int radius);

  /// Budget price range
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// Standard price range
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// Premium price range
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Price: Low-High'**
  String get priceLowToHigh;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Price: High-Low'**
  String get priceHighToLow;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Rating: Low-High'**
  String get ratingLowToHigh;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Rating: High-Low'**
  String get ratingHighToLow;

  /// Sort option
  ///
  /// In en, this message translates to:
  /// **'Distance: Nearest'**
  String get distanceNearest;

  /// Distance to store
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String awayDistance(String distance);

  /// Error state message
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection\nand try again'**
  String get pleasCheckInternetConnection;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Filters bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Location section title
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Price range section title
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// Rating section title
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating'**
  String get minimumRating;

  /// Amenities section title
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// Sort section title
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// Apply button with count
  ///
  /// In en, this message translates to:
  /// **'Apply ({count})'**
  String applyWithCount(int count);

  /// Apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Location toggle label
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// Radius label
  ///
  /// In en, this message translates to:
  /// **'Search Radius'**
  String get searchRadius;

  /// Kilometer unit
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String kmUnit(int value);

  /// All ratings option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allRatings;

  /// Recommended sort option
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// Sort by distance option
  ///
  /// In en, this message translates to:
  /// **'Distance: Nearest First'**
  String get distanceNearestFirst;

  /// Store detail page title
  ///
  /// In en, this message translates to:
  /// **'Store Details'**
  String get storeDetails;

  /// Services section title
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get availableServices;

  /// Default store name
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get storeName;

  /// Default service name
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// Book now button
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// Empty services state
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get noServicesAvailable;

  /// Reviews section title
  ///
  /// In en, this message translates to:
  /// **'Reviews & Ratings'**
  String get reviewsAndRatings;

  /// Review count
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(int count);

  /// Empty reviews state in store
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYetStore;

  /// Recent reviews label
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recentReviews;

  /// Helpful count
  ///
  /// In en, this message translates to:
  /// **'{count} found this helpful'**
  String foundThisHelpful(int count);

  /// Store response label
  ///
  /// In en, this message translates to:
  /// **'Store Response'**
  String get storeResponse;

  /// Location error title
  ///
  /// In en, this message translates to:
  /// **'Location Error'**
  String get locationError;

  /// Location error message
  ///
  /// In en, this message translates to:
  /// **'Store location not available'**
  String get storeLocationNotAvailable;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// Google Maps error
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps'**
  String get couldNotOpenGoogleMaps;

  /// Waze error
  ///
  /// In en, this message translates to:
  /// **'Could not open Waze'**
  String get couldNotOpenWaze;

  /// Waze not available title
  ///
  /// In en, this message translates to:
  /// **'Waze Not Available'**
  String get wazeNotAvailable;

  /// Waze installation prompt
  ///
  /// In en, this message translates to:
  /// **'Please install Waze app or use Google Maps'**
  String get pleaseInstallWaze;

  /// Google Maps navigation option
  ///
  /// In en, this message translates to:
  /// **'Navigate using Google Maps'**
  String get navigateUsingGoogleMaps;

  /// Waze navigation option
  ///
  /// In en, this message translates to:
  /// **'Navigate using Waze'**
  String get navigateUsingWaze;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Confirm booking page title
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// Select time page title
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Select date page title
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Select therapist page title
  ///
  /// In en, this message translates to:
  /// **'Select Therapist'**
  String get selectTherapist;

  /// No availability message for therapist
  ///
  /// In en, this message translates to:
  /// **'No availability found for selected therapist in the next 30 days'**
  String get noAvailabilityForTherapist;

  /// No therapists message
  ///
  /// In en, this message translates to:
  /// **'No therapists available for this service'**
  String get noTherapistsAvailable;

  /// Available legend label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Not available legend label
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailableLabel;

  /// Calendar instruction text
  ///
  /// In en, this message translates to:
  /// **'Tap on a highlighted date to view available time slots'**
  String get tapHighlightedDate;

  /// Slots available count
  ///
  /// In en, this message translates to:
  /// **'{count} slots available'**
  String slotsAvailable(int count);

  /// Booking summary title
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;

  /// Date and time label
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// Your therapist label
  ///
  /// In en, this message translates to:
  /// **'Your Therapist'**
  String get yourTherapist;

  /// Proceed button text
  ///
  /// In en, this message translates to:
  /// **'Proceed to Booking'**
  String get proceedToBooking;

  /// Service info error
  ///
  /// In en, this message translates to:
  /// **'Service information is missing'**
  String get serviceInfoMissing;

  /// No availability error title
  ///
  /// In en, this message translates to:
  /// **'No Availability'**
  String get noAvailability;

  /// No availability error message
  ///
  /// In en, this message translates to:
  /// **'No available dates for this service in the next 30 days.'**
  String get noAvailableDatesMessage;

  /// Failed to load availability error
  ///
  /// In en, this message translates to:
  /// **'Failed to load availability calendar'**
  String get failedToLoadAvailability;

  /// Select therapist validation
  ///
  /// In en, this message translates to:
  /// **'Please select a therapist'**
  String get pleaseSelectTherapist;

  /// Select date validation
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// Select time slot validation
  ///
  /// In en, this message translates to:
  /// **'Please select a time slot'**
  String get pleaseSelectTimeSlot;

  /// Pressure level label
  ///
  /// In en, this message translates to:
  /// **'Pressure Level'**
  String get pressureLevel;

  /// Light pressure option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Medium pressure option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Firm pressure option
  ///
  /// In en, this message translates to:
  /// **'Firm'**
  String get firm;

  /// Focus areas label
  ///
  /// In en, this message translates to:
  /// **'Focus Areas'**
  String get focusAreas;

  /// Neck focus area
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get neck;

  /// Shoulders focus area
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get shoulders;

  /// Back focus area
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Lower back focus area
  ///
  /// In en, this message translates to:
  /// **'Lower Back'**
  String get lowerBack;

  /// Arms focus area
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get arms;

  /// Legs focus area
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get legs;

  /// Feet focus area
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get feet;

  /// Special instructions section title
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get specialInstructions;

  /// Special instructions input hint
  ///
  /// In en, this message translates to:
  /// **'E.g., Please use lavender oil, focus on lower back...'**
  String get specialInstructionsHint;

  /// Voucher code section title
  ///
  /// In en, this message translates to:
  /// **'Voucher Code'**
  String get voucherCode;

  /// Voucher code input hint
  ///
  /// In en, this message translates to:
  /// **'Enter voucher code (optional)'**
  String get enterVoucherCodeOptional;

  /// Payment method section title
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Cash payment option
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Cash payment description
  ///
  /// In en, this message translates to:
  /// **'Pay at therapist location'**
  String get payAtTherapistLocation;

  /// Cash payment reminder
  ///
  /// In en, this message translates to:
  /// **'Please bring RM {amount} in cash to the therapist location.'**
  String pleaseBringCash(String amount);

  /// Insufficient balance message
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance. Please top up.'**
  String get insufficientBalanceTopUp;

  /// Insufficient balance dialog title
  ///
  /// In en, this message translates to:
  /// **'Insufficient Wallet Balance'**
  String get insufficientWalletBalance;

  /// Insufficient balance dialog message
  ///
  /// In en, this message translates to:
  /// **'Your wallet balance is insufficient. Please top up your wallet or select cash payment.'**
  String get insufficientWalletBalanceMessage;

  /// Booking confirmed dialog title
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmedTitle;

  /// Wallet payment success message
  ///
  /// In en, this message translates to:
  /// **'Payment successful. Your booking has been confirmed.'**
  String get paymentSuccessful;

  /// Cash booking confirmed message
  ///
  /// In en, this message translates to:
  /// **'Your booking has been confirmed. Please bring RM {amount} in cash to the therapist location.'**
  String bookingConfirmedCash(String amount);

  /// Cash payment info
  ///
  /// In en, this message translates to:
  /// **'Payment will be collected at the location'**
  String get paymentCollectedAtLocation;

  /// Booking failed dialog title
  ///
  /// In en, this message translates to:
  /// **'Booking Failed'**
  String get bookingFailed;

  /// Booking failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to create booking. Please try again.'**
  String get failedToCreateBooking;

  /// Missing info error
  ///
  /// In en, this message translates to:
  /// **'Missing required booking information'**
  String get missingBookingInfo;

  /// Invalid payment method error title
  ///
  /// In en, this message translates to:
  /// **'Invalid Payment Method'**
  String get invalidPaymentMethod;

  /// Invalid payment method error message
  ///
  /// In en, this message translates to:
  /// **'Only wallet and cash payments are accepted for bookings.'**
  String get invalidPaymentMethodMessage;

  /// Invalid information error title
  ///
  /// In en, this message translates to:
  /// **'Invalid Information'**
  String get invalidInformation;

  /// Invalid information error message
  ///
  /// In en, this message translates to:
  /// **'Please check your booking information and try again.'**
  String get invalidInformationMessage;
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
