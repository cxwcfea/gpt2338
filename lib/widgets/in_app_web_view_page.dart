import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gpt2338/widgets/centered_circular_progress_indicator.dart';

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({super.key});

  @override
  InAppWebViewPageState createState() => InAppWebViewPageState();
}

class InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  bool _isLoading = false;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();

    // onRefresh: () async {
    //   if (Platform.isAndroid) {
    //     webViewController?.reload();
    //   } else if (Platform.isIOS) {
    //     webViewController?.loadUrl(
    //         urlRequest: URLRequest(url: await webViewController?.getUrl()));
    //   }
    // },
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text("InAppWebView")),
        appBar: null,
        backgroundColor: const Color(0xFF666666),
        body: Stack(children: [
          SafeArea(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest:
                  URLRequest(url: Uri.parse("https://gpt2338.jp/")),
              initialOptions: options,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  _isLoading = true;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  this.url = url.toString();
                  _isLoading = false;
                });
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: const CenteredCircularProgressIndicator(),
          )
        ]));
  }
}
