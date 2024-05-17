import 'dart:convert';

import 'package:fitinbox/service/utils.dart';
import 'package:fitinbox/widgets/default_scaffold.dart';
import 'package:fitinbox/widgets/web_view/web_view_loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmailWebView extends StatefulWidget {
  const EmailWebView({super.key, required this.title, required this.html, required this.email});

  final String title;
  final String html;
  final dynamic email;

  @override
  State<EmailWebView> createState() => _EmailWebViewState();
}

class _EmailWebViewState extends State<EmailWebView> {
  final WebViewController _webViewController = WebViewController();
  final ValueNotifier<int> _currentProgressNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    String meta = '<meta name="viewport" content="width=device-width, initial-scale=1.0" />';

    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        _currentProgressNotifier.value = 0;
      },
      onProgress: (progress) {
        _currentProgressNotifier.value = progress;
      },
      onPageFinished: (url) async {
        _currentProgressNotifier.value = 100;
      },
    ));
    _webViewController.setUserAgent("'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36'");
    _webViewController.setBackgroundColor(Colors.white);
    _webViewController.loadHtmlString(meta + widget.html);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Colors.white,
      backButton: true,
      title: Text(
        widget.title,
        style: const TextStyle(
          letterSpacing: 0,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF212124),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jsonDecode(widget.email["metadata"])["Records"][0]["ses"]["mail"]["commonHeaders"]["subject"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          "보낸사람",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F1FD),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              getDetailFromText(from: jsonDecode(widget.email["metadata"])["Records"][0]["ses"]["mail"]["commonHeaders"]["from"][0]),
                              style: const TextStyle(
                                letterSpacing: 0,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      getKorDate(widget.email["createdAt"].toDate()),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: WebViewWidget(
                  controller: _webViewController,
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: _currentProgressNotifier,
            builder: (context, currentProgress, child) {
              return WebLoadingIndicator(currentProgress: currentProgress);
            },
          ),
        ],
      ),
    );
  }
}
