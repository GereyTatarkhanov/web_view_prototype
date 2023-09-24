import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'ui/loading.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController webViewController;
  int progress = 0;
  bool isIndicatorVisible = false;
  int pageIndex = 0;
  int? statusCode;

  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(255, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            this.progress = progress;
            changeIndicatorVisivility();
          },
          onPageStarted: (String url) async {
            statusCode = await getStatusCode(url);
            setState(() {});
          },
          onPageFinished: (String url) async {
          },
          onWebResourceError: (WebResourceError error) {
            statusCode = 404;
            setState(() {});
          },
          onNavigationRequest: (NavigationRequest request) async {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://aivazovsvet.ru/'));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (statusCode) {
      case null:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Загрузка',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CircularProgressIndicator(
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        );
      case == 200:
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              var isLastPage = await webViewController.canGoBack();
              if (isLastPage) {
                webViewController.goBack();
                return false;
              }
              return true;
            },
            child: SafeArea(
              child: Stack(
                children: [
                  WebViewWidget(controller: webViewController),
                  isIndicatorVisible ?  const Loading() : const SizedBox()
                ],
              ),
            ),
          ),
        );
    }
    return const Center(child: CircularProgressIndicator());
  }


  //WebView go to
  void goTo(String path) {
    webViewController.loadRequest(Uri.parse(path));
  }

  // Indicator visible mode on or off checking
  void changeIndicatorVisivility() {
    if (progress >= 50) {
      setState(() {
        isIndicatorVisible = false;
      });
    } else {
      setState(() {
        isIndicatorVisible = true;
      });
    }
  }


  Future<int> getStatusCode(String url) async {
    final response = await http.post(Uri.parse(url));
    return response.statusCode;
  }
}
