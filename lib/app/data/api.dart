class Api {
  /// base url
 // static const baseUrl = "http://10.10.10.27:7000/api/v1";
  static const baseUrl = "http://10.10.10.27:7000/api/v1";

  ///auth
  static const login = "$baseUrl/auth/login";
  static const register = "$baseUrl/users";
  static const profile = "$baseUrl/users/my-profile";
  static const verifyOtp = "$baseUrl/otp/verify-otp";
  static const resendOtp = "$baseUrl/otp/resend-otp";
  static const changePassword = "$baseUrl/auth/change-password";
  static const forgetPassword = "$baseUrl/auth/forget-password";
  static const resetPassword = "$baseUrl/auth/reset-password";

  static const updateProfile = "$baseUrl/users/update-my-profile";
  static const deleteProfile = "$baseUrl/users/delete-my-account";

  //Common
  static const categories = "$baseUrl/categories";
  static const notifications = "$baseUrl/notifications";
  static const contents = "$baseUrl/contents";

  //Users
  static const cart = "$baseUrl/add-to-card";
  static const createOrders = "$baseUrl/orders";
  static const allProducts = "$baseUrl/products";
  static const allShop = "$baseUrl/shop";
  static const myOrders = "$baseUrl/orders/my-orders";
  static  shopWiseProduct({required shopId}) => "$baseUrl/products/author/$shopId";
  static  deleteCart({required cartId}) => "$baseUrl/add-to-card/$cartId";

  //Vendor
  static const addProduct = "$baseUrl/products";
  static const myProduct = "$baseUrl/products/my-products?limit=1000000000000";
  static  updateProduct({required productId}) => "$baseUrl/products/$productId";
  static  vendorOrder({required authorId}) => "$baseUrl/orders?author=$authorId";
  static  deleteOrder({required orderId}) => "$baseUrl/orders/$orderId";
  static  updateOrderStatus({required orderId}) => "$baseUrl/orders/$orderId";
  static const addBankDetails = "$baseUrl/bank-details";
  static const myBankDetails = "$baseUrl/bank-details/my-bank-details";
  static  updateBankDetails({required orderId}) => "$baseUrl/bank-details/$orderId";
  static const withdrawRequest = "$baseUrl/withdraw-request";
  static const myWithdrawRequest = "$baseUrl/withdraw-request/my-request";
  static const addShop = "$baseUrl/shop/update-my-shop";
  static const myShop = "$baseUrl/shop/my-shop";
  static const vendorRequest = "$baseUrl/vendor-request";
  static const stripeConnect = "$baseUrl/stripe/connect";





}