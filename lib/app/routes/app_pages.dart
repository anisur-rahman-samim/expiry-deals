// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/cart/bindings/cart_binding.dart';

import '../modules/cart/views/cart_view.dart';

import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/choose_role/bindings/choose_role_binding.dart';
import '../modules/choose_role/views/choose_role_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/forget/bindings/forget_binding.dart';
import '../modules/forget/views/forget_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/my_orders/bindings/my_orders_binding.dart';
import '../modules/my_orders/views/my_orders_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/order_success/bindings/order_success_binding.dart';
import '../modules/order_success/views/order_success_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_page/bindings/search_page_binding.dart';
import '../modules/search_page/views/search_page_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/store/bindings/store_binding.dart';
import '../modules/store/views/store_view.dart';
import '../modules/terms_conditions/bindings/terms_conditions_binding.dart';
import '../modules/terms_conditions/views/terms_conditions_view.dart';
import '../modules/vendor_dashboard/bindings/vendor_dashboard_binding.dart';
import '../modules/vendor_dashboard/vendor_home/bindings/vendor_home_binding.dart';
import '../modules/vendor_dashboard/vendor_home/views/vendor_home_view.dart';
import '../modules/vendor_dashboard/vendor_order/bindings/vendor_order_binding.dart';
import '../modules/vendor_dashboard/vendor_order/views/vendor_order_view.dart';
import '../modules/vendor_dashboard/vendor_product/bindings/vendor_product_binding.dart';
import '../modules/vendor_dashboard/vendor_product/views/vendor_product_view.dart';
import '../modules/vendor_dashboard/vendor_profile/bindings/vendor_profile_binding.dart';
import '../modules/vendor_dashboard/vendor_profile/views/vendor_profile_view.dart';
import '../modules/vendor_dashboard/vendor_withdraw/bindings/vendor_withdraw_binding.dart';
import '../modules/vendor_dashboard/vendor_withdraw/views/vendor_withdraw_view.dart';
import '../modules/vendor_dashboard/views/vendor_dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_ROLE,
      page: () => const ChooseRoleView(),
      binding: ChooseRoleBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGET,
      page: () => const ForgetView(),
      binding: ForgetBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_CONDITIONS,
      page: () => TermsConditionsView(),
      binding: TermsConditionsBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.MY_ORDERS,
      page: () => const MyOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.STORE,
      page: () => const StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_SUCCESS,
      page: () => const OrderSuccessView(),
      binding: OrderSuccessBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_PAGE,
      page: () => SearchPageView(),
      binding: SearchPageBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: _Paths.VENDOR_DASHBOARD,
      page: () => VendorDashboardView(),
      binding: VendorDashboardBinding(),
      children: [
        GetPage(
          name: _Paths.VENDOR_HOME,
          page: () => const VendorHomeView(),
          binding: VendorHomeBinding(),
        ),
        GetPage(
          name: _Paths.VENDOR_PRODUCT,
          page: () => const VendorProductView(),
          binding: VendorProductBinding(),
        ),
        GetPage(
          name: _Paths.VENDOR_ORDER,
          page: () => const VendorOrderView(),
          binding: VendorOrderBinding(),
        ),
        GetPage(
          name: _Paths.VENDOR_WITHDRAW,
          page: () => const VendorWithdrawView(),
          binding: VendorWithdrawBinding(),
        ),
        GetPage(
          name: _Paths.VENDOR_PROFILE,
          page: () =>  VendorProfileView(),
          binding: VendorProfileBinding(),
        ),
      ],
    ),
  ];
}
