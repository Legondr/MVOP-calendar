import 'package:calendar/components/custom_button.dart';
import 'package:calendar/components/custom_text_field.dart';
import 'package:calendar/components/square_tile.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});

  //text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'DMCalendar',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 3, 192, 244),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //login text
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 45,
                  ),
                ),

                //username/email textfield
                const SizedBox(
                  height: 100,
                ),
                CustomTextField(
                  controller: usernameController,
                  hintText: 'Username / Email',
                  obscureText: false,
                ),

                //password textfield
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                //forget password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot password?',
                        style:
                            TextStyle(color: Color.fromARGB(255, 100, 98, 98)),
                      ),
                    ],
                  ),
                ),
                //sign in button
                CustomButton(
                  onTap: signUserIn,
                ),
                //cara
                const SizedBox(
                  height: 20,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 3, 192, 244),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Color.fromARGB(255, 100, 98, 98),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 3, 192, 244),
                        ),
                      ),
                    ],
                  ),
                ),
                //sign in via apple or google
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google
                    SquareTile(imagePath: 'lib/images4projects/google.png'),

                    SizedBox(
                      width: 10,
                    ),

                    //apple
                    SquareTile(imagePath: 'lib/images4projects/apple.png'),
                  ],
                ),
                //not a member? register now

                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 100, 98, 98),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Register now',
                      style: TextStyle(
                          color: Color.fromARGB(255, 3, 192, 244),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
