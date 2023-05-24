import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gpt2338/widgets/centered_circular_progress_indicator.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  bool _isLoading = false;
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0xffffffff))
    ..loadRequest(Uri.parse("https://gpt2338.jp/"));

  @override
  void initState() {
    super.initState();
    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          print('progress----------$progress');
        },
        onPageStarted: (String url) {
          setState(() {
            _isLoading = true;
          });
          print('Started-------$url');
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });
          print('Finished--------$url');
        },
        onWebResourceError: (WebResourceError request) {
          print('Error--------$request');
        },
        // onNavigationRequest: (NavigationRequest request) {
        //   return NavigationDecision.navigate;
        // },
      ),
    );
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    controller
      ..clearLocalStorage()
      ..clearCache()
      ..removeJavaScriptChannel('channel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("Search Club"),
        //   // backgroundColor: const Color(0xFFE4670B),
        //   backgroundColor: const Color(0xFFE1E1E1),
        //   actions: <Widget>[
        //     NavigationControls(webViewController: controller),
        //   ],
        // ),
        appBar: null,
        backgroundColor: const Color(0xFF666666),
        body: Stack(children: [
          SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.white,
              alignment: Alignment.topCenter,
              child: WebViewWidget(controller: controller),
            ),
          ),
          // _isLoading ? const CenteredCircularProgressIndicator() : const Stack()
          Visibility(
            visible: _isLoading,
            child: const CenteredCircularProgressIndicator(),
          )
        ]));
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No page to go back')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No page to go forward')),
                );
              }
            }
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.replay),
        //   onPressed: () => webViewController.reload(),
        // ),
      ],
    );
  }
}
