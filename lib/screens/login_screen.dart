import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scraphive/resources/auth_methods.dart';
import 'package:scraphive/screens/default_screen.dart';
import 'package:scraphive/utils/colors.dart';
import 'package:scraphive/utils/utils.dart';
import 'package:scraphive/widgets/scraphive_loader.dart';
import 'package:scraphive/widgets/text_field_input.dart';
import '../screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const DefaultScreen()));
    } else {
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? ScrapHiveLoader()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    SvgPicture.asset(
                      'assets/ScrapHive_Logo.svg',
                      height: 48,
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter Email',
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: 'Enter Password',
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      child: Container(
                        child: const Text(
                          'Log in',
                          style: TextStyle(color: Colors.white),
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: amberColor,
                        ),
                      ),
                      onTap: loginUser,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text(
                            "Don't Have Account? ",
                            style: TextStyle(color: greyColor),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                        GestureDetector(
                          onTap: navigateToSignUp,
                          child: Container(
                            child:const Text(
                              "Signup",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: brownColor),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
      ),
    );
  }
}
