import 'package:flutter/material.dart';

class ExampleAppBar extends StatelessWidget {
  const ExampleAppBar({
    super.key,
    required this.title,
    this.showGoBack = false,
  });

  final String title;
  final bool showGoBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 10.0,
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: showGoBack
                  ? IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                    )
                  : Container(
                      height: 50.0,
                    ),
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleAppBarLayout extends StatelessWidget {
  const ExampleAppBarLayout({
    super.key,
    required this.title,
    this.showGoBack = false,
    required this.child,
  });

  final String title;
  final bool showGoBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ExampleAppBar(
              title: title,
              showGoBack: showGoBack,
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
