import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/local/chache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/const.dart';
import '../../components/default_button.dart';
import '../../components/default_format_field.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../components/toast.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class SocialLogin extends StatelessWidget {
  SocialLogin({Key? key}) : super(key: key);
  var loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            
            String msg = state.error.substring(state.error.lastIndexOf(']')+1);
            showToast(text: msg, state: ToastState.ERROR);
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = CacheHelper.getData(key: 'uId');
              SocialCubit.get(context)..getUserData()..getPosts()..getFollowers();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          child: const Image(
                            image: AssetImage('assets/images/tinder.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text(
                          "blaze",
                          style: TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          "keep in touch with your friends",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          context: context,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          label: "email",
                          prefix: Icons.email_outlined,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            context: context,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            label: "password",
                            prefix: Icons.lock_outline,
                            suffix: SocialLoginCubit.get(context).suffix,
                            isPassword:
                                SocialLoginCubit.get(context).showPassword,
                            suffixPressed: () {
                              SocialLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            onSubmit: (value) {
                              if (loginFormKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'password is too short';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) => defaultButton(
                              gradient: const LinearGradient(colors: [
                                defaultColor1,
                                Colors.orange,
                              ]),
                              text: "login",
                              isUpperCase: true,
                              function: () {
                                if (loginFormKey.currentState!.validate()) {
                                  SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              }),
                          fallback: (context) => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(70.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultButton(
                            gradient: const LinearGradient(colors: [
                              defaultColor1,
                              Colors.orange,
                            ]),
                            text: "register",
                            isUpperCase: true,
                            function: () {
                              Navigator.pushNamed(context, '/register');
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
