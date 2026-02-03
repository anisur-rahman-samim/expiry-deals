
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_text_style/styles.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends StatefulWidget {
  String? paymentUrl;
  PaymentView({super.key, this.paymentUrl});

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late WebViewController _controller;
  bool _isLoading = true;

  final PaymentController paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    if (widget.paymentUrl == null || widget.paymentUrl!.isEmpty) {
      print('Error: Invalid payment URL');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid payment URL')),
        );
        Navigator.pop(context);
      });
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started loading: $url');
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            setState(() => _isLoading = false);
            if (url.contains('confirm-payment')) {
              print('Calling paymentDone with URL: $url');
              paymentController.paymentDone(paymentApi: url);
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load payment page: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigating to: ${request.url}');
            if (request.url.contains('success') ||
                request.url.contains('cancel') ||
                request.url.contains('error')) {
              print('Payment redirect URL: ${request.url}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment redirect: ${request.url}')),
              );
              Navigator.pop(context);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text('Payment', style: h2.copyWith(fontSize: 18)),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}