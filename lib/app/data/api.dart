class Api {
  /// base url
 // static const baseUrl = "http://10.10.10.27:7000/api/v1";
  static const baseUrl = "http://103.186.20.117:9000/api/v1";

  ///auth
  static const login = "$baseUrl/auth/login"; //done
  static const register = "$baseUrl/users"; // done33
  static const profile = "$baseUrl/users/my-profile"; // done
  static const verifyOtp = "$baseUrl/otp/verify-otp"; // done
  static const resendOtp = "$baseUrl/otp/resend-otp"; // done
  static const changePassword = "$baseUrl/auth/change-password"; // done
  static const forgetPassword = "$baseUrl/auth/forgot-password"; // done
  static const resetPassword = "$baseUrl/auth/reset-password"; // done

  static const updateProfile = "$baseUrl/users/update-my-profile";  // problem with api
  static const deleteProfile = "$baseUrl/users/delete-my-account"; // done

  //Common
  static const categories = "$baseUrl/categories"; // done
  static const notifications = "$baseUrl/notifications"; // hold for data
  static const contents = "$baseUrl/contents"; // done

  //product order
  static const cart = "$baseUrl/add-to-card"; // done
  static const createOrders = "$baseUrl/orders";
  static const allProducts = "$baseUrl/products"; // done
  static  categoryProducts({required categoryId}) => "$baseUrl/products?category=$categoryId"; // done
  static const allShop = "$baseUrl/shop"; // done
  static const myOrders = "$baseUrl/orders/my-orders"; // done
  static const cartEmpty = "$baseUrl/add-to-card/empty"; //
  static  shopWiseProduct({required shopId}) => "$baseUrl/products/author/$shopId"; // done
  static  shopById({required shopId}) => "$baseUrl/shop/$shopId"; // done
  static  productById({required productId}) => "$baseUrl/products/$productId"; // done
  static  deleteCart({required cartId}) => "$baseUrl/add-to-card/$cartId"; // done

  //Vendor
  static const addProduct = "$baseUrl/products"; // hold
  static const myProduct = "$baseUrl/products/my-products?limit=1000000000000";//done
  static  updateProduct({required productId}) => "$baseUrl/products/$productId";
  static  deleteProduct({required productId}) => "$baseUrl/products/$productId"; // done
    static  productDetails({required productId}) => "$baseUrl/products/$productId";
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
  static const vendorRequest = "$baseUrl/vendor-request"; // done // lat lang nisse na
  static const stripeConnect = "$baseUrl/stripe/connect";
  static const vendorDashboard = "$baseUrl/payments/vendor-dashboard-data";





}