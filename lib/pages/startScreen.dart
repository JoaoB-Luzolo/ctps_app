import 'package:ctps_app/pages/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:ctps_app/components/my_button.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            // logo
            Image.asset(
              'lib/images/logo.png',
              height: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  //sign in
                  MyButton(
                    text: 'Login',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //sign in
                  MyButton(
                    text: 'SignUp',
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
