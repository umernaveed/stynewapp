import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  ValueNotifier<double> loadingProgress = ValueNotifier<double>(0);
  String successURL =
      'https://straight_to_yardja.com/tracking/lasco/payment/success';
  String failedURL =
      'https://straight_to_yardja.com/tracking/lasco/payment/failed';
  String timoutIssue = 'https://payment.lascobizja.com/gateway/v1/failure';

  @override
  Widget build(BuildContext context) {
    final params = Get.arguments as Map<String, dynamic>;
    final url = params['url'];
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(url),
            ),
            onWebViewCreated: (controller) {},
            onProgressChanged: (controller, progress) {
              loadingProgress.value = progress / 100;
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {
              final renderURL = url.toString().toLowerCase();
              if (renderURL == failedURL.toLowerCase()) {
                Get.back(result: -1);
              } else if (renderURL == successURL.toLowerCase()) {
                Get.back(result: 1);
              }
            },
          ),
          Positioned(
            top: 56,
            left: 16,
            child: Container(
              alignment: Alignment.center,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E8EA)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: Color(0xFF087C25),
                    size: 34,
                  ),
                  onPressed: () {
                    Get.back(result: -1);
                  },
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: ValueListenableBuilder<double>(
            valueListenable: loadingProgress,
            builder: (context, value, child) {
              return value < 1.0
                  ? const CircularProgressIndicator.adaptive()
                  : const SizedBox.shrink();
            },
          ))
        ],
      ),
    );
  }
}
