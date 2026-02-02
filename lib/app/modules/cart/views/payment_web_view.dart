import 'package:expiry_deals/app/modules/order_success/views/order_success_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentWebView({
    super.key,
    required this.paymentUrl,
    required this.orderId,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // For Android hybrid composition (newer versions)
    // WebView.platform = SurfaceAndroidWebView(); // usually not needed anymore in 2025+

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // You can show progress bar if you want
          },
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            // ──────────────────────────────────────────────
            // This is the key part — intercept your redirect URLs
            // ──────────────────────────────────────────────
            if (request.url.contains('/payment/success')) {
              _handlePaymentResult(success: true);
              return NavigationDecision.prevent;
            }
            if (request.url.contains('/payment/failed') ||
                request.url.contains('/payment/cancel')) {
              _handlePaymentResult(success: false);
              return NavigationDecision.prevent;
            }

            // Allow all other navigations
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> _handlePaymentResult({required bool success}) async {
    // Optional: call your backend to verify the payment status
    // (very strongly recommended for security)
    // e.g. await verifyPaymentOnBackend(widget.orderId, success);

    if (!mounted) return;

    if (success) {
      Get.offAll(() => OrderSuccessView());
      kSnackBar(message: 'Payment successful!', bgColor: AppColors.green);
    } else {
      // You can go back to cart or show failed page
      Get.back(); // or Get.offAll(() => FailedView());
      kSnackBar(message: 'Payment failed or cancelled.', bgColor: AppColors.failedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}