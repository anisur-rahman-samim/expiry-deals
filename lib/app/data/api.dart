class Api {
  /// base url
 // static const baseUrl = "http://10.10.10.27:7000/api/v1";
  static const baseUrl = "https://api.expirydeals.online/api/v1";

  ///auth
  static const login = "$baseUrl/auth/login"; //done
  static const register = "$baseUrl/users"; // done33
  static const profile = "$baseUrl/users/my-profile"; // done
  static const verifyOtp = "$baseUrl/otp/verify-otp"; // done
  static const resendOtp = "$baseUrl/otp/resend-otp"; // done
  static const changePassword = "$baseUrl/auth/change-password"; // done
  static const forgetPassword = "$baseUrl/auth/forgot-password"; // done
  static const resetPassword = "$baseUrl/auth/reset-password"; // done

  static const updateProfile = "$baseUrl/users/update-my-profile";  // done
  static const deleteProfile = "$baseUrl/users/delete-my-account"; // done

  //Common
  static const categories = "$baseUrl/categories"; // done
  static const notifications = "$baseUrl/notifications"; // done
  static const contents = "$baseUrl/contents"; // done

  //product order
  static const cart = "$baseUrl/add-to-card"; // done
  static const createOrders = "$baseUrl/orders"; // done
  static const allProducts = "$baseUrl/products"; // done
  static  productDetails({required productId}) => "$baseUrl/products/$productId"; // done
  static  categoryProducts({required categoryId}) => "$baseUrl/products?category=$categoryId"; // done
  static const allShop = "$baseUrl/shop"; // done
  static const myOrders = "$baseUrl/orders/my-orders"; // done
  static  singleOrder({required orderId}) => "$baseUrl/orders/$orderId"; // done
  static const cartEmpty = "$baseUrl/add-to-card/empty"; //done
  static  shopWiseProduct({required shopId}) => "$baseUrl/products/author/$shopId"; // done
  static  shopById({required shopId}) => "$baseUrl/shop/$shopId"; // done
  static  productById({required productId}) => "$baseUrl/products/$productId"; // done
  static  deleteCart({required cartId}) => "$baseUrl/add-to-card/$cartId"; // done

  //
  static const paymentsCheckout = "$baseUrl/payments/checkout"; //

  //Vendor
  static const addProduct = "$baseUrl/products"; // done
  static const myProduct = "$baseUrl/products/my-products?limit=1000000000000";//done
  static  updateProduct({required productId}) => "$baseUrl/products/$productId"; // done

  static  deleteProduct({required productId}) => "$baseUrl/products/$productId"; // done
  static  vendorOrder({required authorId}) => "$baseUrl/orders?author=$authorId"; // done
  static  deleteOrder({required orderId}) => "$baseUrl/orders/$orderId"; // no need
  static  updateOrderStatus({required orderId}) => "$baseUrl/orders/$orderId"; // done
  static const addBankDetails = "$baseUrl/bank-details"; // done
  static const myBankDetails = "$baseUrl/bank-details/my-bank-details"; // done
  static const withdrawRequest = "$baseUrl/withdraw-request"; // done
  static const myWithdrawRequest = "$baseUrl/withdraw-request/my-request"; // done
  static const addShop = "$baseUrl/shop/update-my-shop"; // done
  static const myShop = "$baseUrl/shop/my-shop"; // done
  static const vendorRequest = "$baseUrl/vendor-request"; // done // lat lang nisse na
  static const stripeConnect = "$baseUrl/stripe/connect";
  static const vendorDashboard = "$baseUrl/payments/vendor-dashboard-data"; // done





}