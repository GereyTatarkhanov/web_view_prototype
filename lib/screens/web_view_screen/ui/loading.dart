import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({
    super.key,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isDissposed = false;
  bool hasError = false;

  @override
  void initState() {
    final selfKill = Future.delayed(const Duration(seconds: 15), () {
      if (!isDissposed) {
        hasError = true;
        setState(() {});
      } else {
        hasError = false;
      }
    });
    selfKill;
    super.initState();
  }

  @override
  void dispose() {
    isDissposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return hasError
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Что-то пошло не так...\nПроверьте соединение к интернету и перезапустите приложение',
                    style: TextStyle(fontSize: 25, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        : Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
              ),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            ],
          );
  }
}
