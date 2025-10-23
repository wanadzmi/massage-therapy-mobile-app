import 'package:get/get.dart';

import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/bindings/register_binding.dart';
import '../modules/auth/bindings/otp_verification_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/find_store/bindings/find_store_binding.dart';
import '../modules/find_store/views/find_store_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/services/bindings/services_binding.dart';
import '../modules/services/views/services_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/store_detail/bindings/store_detail_binding.dart';
import '../modules/store_detail/views/store_detail_view.dart';
import '../modules/therapist_selection/bindings/therapist_selection_binding.dart';
import '../modules/therapist_selection/views/therapist_selection_view.dart';
import '../modules/booking_create/bindings/booking_create_binding.dart';
import '../modules/booking_create/views/booking_create_view.dart';
import '../modules/wallet/bindings/wallet_topup_binding.dart';
import '../modules/wallet/views/wallet_topup_view.dart';
import '../modules/wallet/views/wallet_usdt_payment_view.dart';
import '../modules/wallet/views/wallet_payment_pending_view.dart';
import '../modules/transaction_history/bindings/transaction_history_binding.dart';
import '../modules/transaction_history/views/transaction_history_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/write_review_view.dart';
import '../modules/review/views/my_reviews_view.dart';
import '../modules/tier_subscription/bindings/tier_subscription_binding.dart';
import '../modules/tier_subscription/bindings/tier_detail_binding.dart';
import '../modules/tier_subscription/views/tier_subscription_view.dart';
import '../modules/tier_subscription/views/tier_detail_view.dart';
import '../modules/therapist_home/bindings/therapist_home_binding.dart';
import '../modules/therapist_home/views/therapist_home_view.dart';
import '../modules/therapist_today_summary/bindings/today_summary_binding.dart';
import '../modules/therapist_today_summary/views/today_summary_view.dart';
import '../modules/therapist_booking_detail/bindings/therapist_booking_detail_binding.dart';
import '../modules/therapist_booking_detail/views/therapist_booking_detail_view.dart';
import '../modules/therapist_profile/bindings/therapist_profile_binding.dart';
import '../modules/therapist_profile/views/therapist_profile_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/notification/views/notification_preferences_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OTPVerificationView(),
      binding: OTPVerificationBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    // GetPage(
    //   name: _Paths.AUTH,
    //   page: () => const AuthView(),
    //   binding: AuthBinding(),
    // ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.SERVICES,
      page: () => const ServicesView(),
      binding: ServicesBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FIND_STORE,
      page: () => const FindStoreView(),
      binding: FindStoreBinding(),
    ),
    GetPage(
      name: _Paths.STORE_DETAIL,
      page: () => const StoreDetailView(),
      binding: StoreDetailBinding(),
    ),
    GetPage(
      name: _Paths.THERAPIST_SELECTION,
      page: () => const TherapistSelectionView(),
      binding: TherapistSelectionBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_CREATE,
      page: () => const BookingCreateView(),
      binding: BookingCreateBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_TOPUP,
      page: () => const WalletTopUpView(),
      binding: WalletTopUpBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_USDT_PAYMENT,
      page: () => const WalletUsdtPaymentView(),
      binding: WalletTopUpBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_PAYMENT_PENDING,
      page: () => const WalletPaymentPendingView(),
      binding: WalletTopUpBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_HISTORY,
      page: () => const TransactionHistoryView(),
      binding: TransactionHistoryBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.WRITE_REVIEW,
      page: () => const WriteReviewView(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.MY_REVIEWS,
      page: () => const MyReviewsView(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.TIER_SUBSCRIPTION,
      page: () => const TierSubscriptionView(),
      binding: TierSubscriptionBinding(),
    ),
    GetPage(
      name: _Paths.TIER_DETAIL,
      page: () => const TierDetailView(),
      binding: TierDetailBinding(),
    ),
    GetPage(
      name: _Paths.THERAPIST_HOME,
      page: () => const TherapistHomeView(),
      binding: TherapistHomeBinding(),
    ),
    GetPage(
      name: _Paths.THERAPIST_TODAY_SUMMARY,
      page: () => const TodaySummaryView(),
      binding: TodaySummaryBinding(),
    ),
    GetPage(
      name: '${_Paths.THERAPIST_BOOKING_DETAIL}/:bookingId',
      page: () => const TherapistBookingDetailView(),
      binding: TherapistBookingDetailBinding(),
    ),
    GetPage(
      name: _Paths.THERAPIST_PROFILE,
      page: () => const TherapistProfileView(),
      binding: TherapistProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_PREFERENCES,
      page: () => const NotificationPreferencesView(),
      binding: NotificationBinding(),
    ),
  ];
}
