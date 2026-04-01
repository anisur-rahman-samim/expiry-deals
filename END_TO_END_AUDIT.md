# Expiry Deals — End-to-End Audit

Read-only audit. No code was modified.

---

## PART 1: CUSTOMER JOURNEY

### 1A. First-time user

**Splash:** Reads LocalStorage: onboarding, token, role. After 3s: if !onboarding → OnboardingView; else if !token → ChooseRoleView; else if role==vendor → VendorDashboardView; else → DashboardView. No API. SplashController empty.

**Onboarding:** 3 pages, static copy. Continue next page; Get Started (last page) or Skip saves AppConstant.onboarding, Get.offAll(ChooseRoleView). No API.

**Choose Role:** User tap saves role=User, Get.to(LoginView). Vendor tap saves role=Vendor, Get.to(LoginView(isVendor: true)). Role stored in GetStorage only; login overwrites with API role.
### 1B. Authentication

**Signup:** Fields: name, email, address, password, confirm password (no client-side match). Submit → AuthController.registration() → Api.register POST (name, email, password, address). Success: saves otpToken, Get.to(VerifyView(isSignUp: true)). Error: catch prints, no user message. No duplicate-email or weak-password validation.

**Verify OTP:** Receives isSignUp from nav. Uses otpToken from LocalStorage (set by signup/forget). Verify button → verifyOtp(pin, isSignUp). Calls Api.verifyOtp (token in headers, otp in body). Success: saves token, navigates to LoginView or ResetView. Resend → resendOtp() calls Api.resendOtp; then view shows snackbar "Verification code sent!" with failedColor (wrong). Wrong OTP: handleResponse throws or returns; catch only debugPrint. No expiry check; 60s countdown is UI only.

**Login:** Calls Api.login POST. Success: stores accessToken and role, routes by role (vendor→VendorDashboard, else→Dashboard). Bug: response['success'] = false is assignment not comparison. Wrong credentials: handleResponse throws; catch only debugPrint, no snackbar. Empty fields: snackbar.

**Forget:** Continue → forgetPassword(email) → Api.forgetPassword PATCH. Success: saves token from response to otpToken (code uses response['data']['token']), Get.to(VerifyView(isSignUp: false)). No email validation.

**Reset:** Uses LocalStorage AppConstant.token (set by verify after forget). resetPassword(new, confirm) → Api.resetPassword PATCH. No client-side new==confirm check. Success: removeData(token), Get.to(LoginView). Reset controller reads token (not otpToken).

**Change password:** Validates new==confirm. Calls Api.changePassword PATCH with Bearer token, old/new/confirm. No old≠new validation. Success: Navigator.pop.

**Logout:** Profile view: dialog Confirm → LocalStorage.removeData(token), removeData(role), Get.offAll(ChooseRoleView). Back after logout goes to Choose Role (stack replaced).

**Delete account:** Profile dialog Confirm → ProfileController.deleteProfile() → Api.deleteProfile (DELETE, token from deleteRequest). Success: removeData(token), Get.offAll(LoginView).
### 1C. Customer home and browsing

**Home:** On load: ProfileController.fetchProfile (Api.profile), CategoryDataController.fetchCategories (Api.categories), ProductController.fetchProducts (Api.allProducts), SpecialProductController.fetchSpecialProducts (Api.allProducts?sort=createdAt), NearMeStoresController.fetchNearMeStores (getCurrentLocation then Api.allShop?latitude=&longitude=). All real API. No pull-to-refresh on home. No pagination (single fetch, limit in URL where used). Banners/sliders are product images from API.

**Search:** SearchPageView uses SearchProductController. onInit: fetchSearchProducts(search: ""). onSearchChanged → fetchSearchProducts(search: query) → Api.allProducts?searchTerm=. No debounce. Results from server. Zero results: searchProducts.isEmpty shows empty state. Tap result → ProductDetailsView(productId).

**Category:** CategoryView(categoryList) gets list from CategoryDataController.categories (from Api.categories). Tap category → CategoryProductView(categoryId). Category products: fetchCategoryProducts(categoryId) → Api.categoryProducts(categoryId). No pagination. Route /category uses CategoryView(categoryList: []) — empty if opened by route.

**Store:** StoreView(shopId, authorId). initState: fetchSingleStoreProduct(shopId) → Api.shopById; fetchStoreWiseProduct(authorId) → Api.shopWiseProduct (products by author). Tap product → ProductDetailsView. Real API.

**Product details:** fetchSingleProduct(productId) → Api.productById. Displays name, price, discount, description, images, shop info. Image from first in list; no carousel. Add to Cart / Buy Now → addToCart(productId, quantity, isBuyNow, authorId) → Api.cart POST; on success fetchAddToCart, if isBuyNow → CartView.
### 1D. Cart

**Add to cart (PDP):** Calls Api.cart POST (product, quantity). Different author → cartEmpty() then add. Success: fetchAddToCart, snackbar, if Buy Now → CartView.

**Cart screen:** initState and RefreshIndicator → fetchAddToCart → Api.cart GET. Real items. No quantity +/- in UI; QTY display only. Remove: swipe or delete icon → removeFromCart (local) + deleteAddToCart(cartId) → Api.deleteCart. Subtotal/total from local fold over cartItems (price with discount). Empty state: message + Continue Shopping → Dashboard.
### 1E. Checkout and payment

**Billing:** One field: address (city/state/zip/country commented). Payment method: 1 = Cash, 2 = Online. Place Order → createOrder(authorId, items, totalPrice, address, city: address, state: address, zipCode: address, country: address, paymentMethod). No validation. createOrder → Api.createOrders POST (author, items, totalPrice, billingDetails). Success: cartEmpty(); if paymentMethod==1 → OrderSuccessView; else orderCheckout(orderId) → Api.paymentsCheckout POST → paymentUrl → PaymentView(webview). Payment view: loads URL; onPageFinished if url.contains('confirm-payment') → paymentDone(paymentApi: url) which does GET to that URL (fragile). 200 → OrderSuccessView. No Stripe SDK; payment via backend URL in webview.

### 1F. Order management (customer)

**My Orders:** fetchOrders() → Api.myOrders GET. Real orders. Status filter: all/pending/confirmed/shipped/delivered/cancelled (local filter on list). No pagination. Order details: tap opens OrderDetailsView; no separate API — uses order from list (cached). Order cancellation: no cancel button or Api.deleteOrder. Order tracking: status text only; no real-time or push.

### 1G. Notifications

Screen calls Api.notifications GET. Real list. No mark-as-read API or button. No badge on bottom nav. Refresh only on opening screen.

### 1H. Profile (customer)

**Profile:** Loads Api.profile on open. Edit Profile: name, email, phone, photo. pickImage + multipart Api.updateProfile. Save → updateProfile(); no explicit profile refresh. Delete Account: button → dialog → deleteProfile() → Api.deleteProfile; clears token, Get.offAll(LoginView). Privacy/Terms: Api.contents(id) for policy/terms; HTML displayed.

---

## PART 2: VENDOR JOURNEY

### 2A. Vendor onboarding

VendorRequestView: form (name, email, phone, shop name, document). Submit → Api.vendorRequest (multipart). Success → snackbar, Get.offAll(LoginView). No approval gate: vendor can log in after signup; dashboard shows data from API. Pending state: no dedicated "pending approval" screen.

### 2B. Vendor Dashboard

VendorDashboardView: no stats API on init. Stats (products, orders, revenue) not loaded from backend; UI may show placeholders or local state. No chart/graph. Product list via Api.myProduct; orders via Api.vendorOrder (from order module).

### 2C. Vendor product management

**List:** Api.myProduct GET. Real products. Refresh on open. No pagination. **Add:** Fields: name, description, price, original price, discount, category, stock, image. Categories from Api.categories. Image picker + multipart Api.addProduct. Validation on submit. Success → Get.back(), list refreshed when returning. **Edit:** Pre-fill from product; Api.updateProduct multipart. Can change image. **Delete:** Api.deleteProduct called; list refresh after delete. Confirmation dialog present.

### 2D. Vendor order management

Order list: Api.vendorOrder. Filter by status. Order details: customer, items, amounts. Status update: Api.updateOrderStatus; UI updates after success.

### 2E. Vendor financials

Withdraw: Api.myWithdrawRequest (history), Api.withdrawRequest (create). Fields: amount, method. Bank details: Api.updateBankDetails referenced; add/update flow present.

### 2F. Vendor shop/profile

My Shop: Api.myShop, Api.addShop (create/update). Fields: name, description, address, logo, banner. Vendor profile: same as customer (edit, photo, delete) using same Api.profile / Api.updateProfile / Api.deleteProfile.

---

## PART 3: CROSS-CUTTING

**3A. Deal timer / expiry:** No countdown widget or expiry timestamp in product model/screens. No time-limited deal logic. Core "expiry deals" feature not implemented.

**3B. Location / Maps:** geolocator, google_maps_flutter, geocoding in pubspec. Near-me stores use lat/long + Api.allShop. Map view present (e.g. store map); route/directions possible. No vendor-set shop location on map in flow.

**3C. Images:** Product/vendor upload: multipart; single image per product. No compression. Profile photo upload works. Customer: NetworkImage; no cached_network_image; placeholder on failure via AppImages.noImage.

**3D. Push notifications:** No firebase_messaging/OneSignal in pubspec. Notifications via Api.notifications only (poll on screen open).

**3E. Payment:** No Stripe SDK. Payment via backend URL in WebView (paymentsCheckout → open URL; confirm-payment URL triggers paymentDone GET). No card input in-app.

**3F. Error handling:** BaseClient: network/timeout/4xx/5xx throw or return null; snackbar for user. No global 401→login. Screens: catch often only debugPrint; some show snackbar. No retry UI. Deep link / missing data: no guards.

**3G. Security:** GET/POST/PATCH use token (BaseClient addToken). deleteRequest adds Authorization. Token in GetStorage (plain). No hardcoded API keys in traced code.

**3H. Offline:** No caching. All data requires live API.

---

## PART 4: DELIVERABLES

### Section A — Feature Status Table

| Feature | Screen/File | API Endpoint | Status | Notes |
|--------|-------------|--------------|--------|-------|
| Splash / routing | SplashView | — | Fully Working | LocalStorage only |
| Onboarding | OnboardingView | — | Fully Working | Skip, Get Started |
| Choose role | ChooseRoleView | — | Fully Working | Saves role |
| Signup | SignupView | Api.register | Partially Working | No confirm-password match, weak error UX |
| Verify OTP | VerifyView | verifyOtp, resendOtp | Partially Working | Resend snackbar wrong color |
| Login | LoginView | Api.login | Partially Working | response['success'] bug; wrong-cred UX |
| Forget password | ForgetView | Api.forgetPassword | Fully Working | |
| Reset password | ResetView | Api.resetPassword | Partially Working | No new==confirm check |
| Change password | ChangePasswordView | Api.changePassword | Partially Working | No old≠new check |
| Logout | ProfileView | — | Fully Working | Clears token/role |
| Delete account | ProfileView | Api.deleteProfile | Fully Working | |
| Home load | HomeView | profile, categories, allProducts, special, nearMe (allShop) | Fully Working | No refresh/pagination |
| Search | SearchPageView | Api.allProducts?searchTerm= | Fully Working | No debounce |
| Category browse | CategoryView, CategoryProductView | Api.categories, Api.categoryProducts | Partially Working | /category route passes [] |
| Store / shop | StoreView | Api.shopById, Api.shopWiseProduct | Fully Working | |
| Product details | ProductDetailsView | Api.productById | Fully Working | No carousel |
| Add to cart | ProductDetailsView, CartController | Api.cart POST | Fully Working | |
| Cart screen | CartView | Api.cart GET | Partially Working | No quantity +/- API |
| Remove from cart | CartView | Api.deleteCart | Fully Working | |
| Checkout / place order | OrderPlaceView | Api.createOrders | Fully Working | Minimal billing fields |
| Payment (online) | PaymentView | Api.paymentsCheckout, GET confirm URL | Partially Working | WebView; no SDK |
| My orders | MyOrdersView | Api.myOrders | Fully Working | Filter local |
| Order details | OrderDetailsView | — | Partially Working | Cached data only |
| Cancel order | — | Api.deleteOrder | Not Built | Endpoint exists, no UI |
| Notifications | NotificationsView | Api.notifications | Partially Working | No mark-as-read |
| Profile | ProfileView | Api.profile | Fully Working | |
| Edit profile | EditProfileView | Api.updateProfile | Fully Working | Photo multipart |
| Privacy/Terms | ContentView | Api.contents | Fully Working | |
| Vendor request | VendorRequestView | Api.vendorRequest | Fully Working | |
| Vendor dashboard | VendorDashboardView | myProduct, vendorOrder | Partially Working | No stats API |
| Vendor products | VendorProductView | Api.myProduct | Fully Working | |
| Add product | VendorAddProductView | Api.addProduct | Fully Working | |
| Edit product | VendorEditProductView | Api.updateProduct | Fully Working | |
| Delete product | — | Api.deleteProduct | Fully Working | |
| Vendor orders | VendorOrderView | Api.vendorOrder, Api.updateOrderStatus | Fully Working | |
| Withdraw | WithdrawView | Api.myWithdrawRequest, Api.withdrawRequest | Fully Working | |
| Bank details | — | Api.updateBankDetails | Fully Working | |
| My shop | VendorShopView | Api.myShop, Api.addShop | Fully Working | |
| Deal timer / expiry | — | — | Not Built | No timer or expiry field |
| Near me stores | HomeView | Api.allShop + location | Fully Working | |
| Push notifications | — | — | Not Built | Poll only |

### Section B — API Coverage Matrix

| Endpoint | Method | Controller/Trigger | Never Called |
|----------|--------|--------------------|--------------|
| login | POST | AuthController.login / Login submit | No |
| register | POST | AuthController.registration / Signup | No |
| profile | GET | ProfileController, EditProfileController / Profile load | No |
| verifyOtp | POST | AuthController.verifyOtp / Verify screen | No |
| resendOtp | POST | AuthController.resendOtp / Resend button | No |
| changePassword | PATCH | ChangePasswordController / Submit | No |
| forgetPassword | PATCH | ForgetController / Forget submit | No |
| resetPassword | PATCH | ResetPasswordController / Reset submit | No |
| updateProfile | multipart | EditProfileController.updateProfile / Save | No |
| deleteProfile | DELETE | ProfileController.deleteProfile / Delete account | No |
| categories | GET | CategoryDataController, VendorAddProduct / Home, dropdown | No |
| notifications | GET | NotificationsController / Notifications screen | No |
| contents | GET | ContentController / Privacy, Terms | No |
| cart | GET/POST | CartController fetchAddToCart, addToCart / Cart load, Add to cart | No |
| createOrders | POST | OrderPlaceController.createOrder / Place order | No |
| allProducts | GET | ProductController, SearchProductController / Home, Search | No |
| productDetails/productById | GET | ProductDetailsController / Product details | No |
| categoryProducts | GET | CategoryProductController / Category tap | No |
| allShop | GET | NearMeStoresController, etc. / Near me, shops | No |
| myOrders | GET | MyOrdersController / My Orders | No |
| singleOrder | GET | — | **Yes** |
| cartEmpty | POST/DELETE | CartController.cartEmpty / Different-vendor cart | No |
| shopWiseProduct, shopById | GET | StoreController / Store view | No |
| deleteCart | DELETE | CartController.deleteAddToCart / Remove item | No |
| paymentsCheckout | POST | OrderPlaceController.orderCheckout / Online payment | No |
| addProduct | POST multipart | VendorAddProductController / Add product | No |
| myProduct | GET | VendorProductController / Vendor products | No |
| updateProduct | PATCH multipart | VendorEditProductController / Edit product | No |
| deleteProduct | DELETE | VendorProductController / Delete product | No |
| vendorOrder | GET | VendorOrderController / Vendor orders | No |
| deleteOrder | DELETE | — | **Yes** |
| updateOrderStatus | PATCH | VendorOrderController / Status update | No |
| addBankDetails, myBankDetails | — | Withdraw/Bank flow | Used |
| withdrawRequest, myWithdrawRequest | GET/POST | WithdrawController / Withdraw screen | No |
| addShop, myShop | GET/POST | Vendor shop / My Shop | No |
| vendorRequest | POST multipart | VendorRequestView / Vendor request | No |
| stripeConnect | — | — | **Yes** |
| vendorDashboard | GET | — | Optional (dashboard stats) |

### Section C — Critical Missing Features (ranked)

1. **Deal timer / expiry** — No countdown, no expiry on products; core app concept missing.
2. **Cart quantity update** — No API or UI to change quantity (+/-); remove only.
3. **Order cancellation (customer)** — Api.deleteOrder exists but no cancel button or flow.
4. **401 / token expiry** — No global interceptor to redirect to login on 401.
5. **Mark notification read** — No API or UI.
6. **Confirm password / validation** — Signup and reset lack client-side match and strength checks.
7. **Billing fields** — Only one address field; city/state/zip/country commented.
8. **Vendor dashboard stats** — No API call for totals/charts; vendorDashboard endpoint unused.
9. **Push notifications** — In-app list only; no FCM/OneSignal.
10. **Offline / caching** — No offline support.

### Section D — Technical Debt

- **Auth:** `response['success'] = false` should be `==` in login error path; wrong-cred and signup error only debugPrint, no user message.
- **Routing:** CategoryView opened via route with `categoryList: []`; category list may be empty.
- **Resend OTP:** Snackbar uses failedColor for "Verification code sent!" (success).
- **Payment:** paymentDone uses full URL as "paymentApi"; GET to confirm URL is fragile.
- **BaseClient:** 404/400 may not throw; only some methods add Authorization (ensure all protected calls use token).
- **Token storage:** GetStorage (plain); consider secure storage for tokens.
- **Filename typo:** `custom_textfelid.dart` (should be textfield).
- **App name:** app_setup has "Gaming Shop"; should match "Expiry Deals".
- **Large limit:** myProduct uses limit=1000000000000 instead of pagination.
- **No retry UI** on failed API screens; no deep-link or missing-data guards.

### Section E — Launch Readiness Score (0–100)

| Area | Score | To reach 100 |
|------|-------|----------------|
| Auth system | 75 | Fix login bug; add validation (confirm password, wrong-cred snackbar); 401→login. |
| Customer shopping | 80 | Add cart quantity update; fix /category route; optional carousel. |
| Cart and checkout | 70 | Full billing fields; validate address; optional delivery/pickup. |
| Payment processing | 65 | Confirm flow (e.g. callback); no Stripe SDK in-app (backend OK). |
| Order lifecycle | 75 | Customer cancel order (use deleteOrder); optional real-time status. |
| Vendor management | 80 | Dashboard stats from vendorDashboard API; pagination for products. |
| Notifications | 50 | Mark-as-read API + UI; push (FCM) for alerts. |
| Security | 70 | Secure token storage; ensure all protected requests send token; no secrets in code. |
| Error handling | 60 | Global 401; retry UI; user-facing messages for signup/login errors. |
| Performance/polish | 65 | Pagination (products, orders); image caching; pull-to-refresh home. |

**Overall:** ~70 — Usable MVP for happy path; needs expiry feature, cart quantity, order cancel, and error/security polish for launch.
