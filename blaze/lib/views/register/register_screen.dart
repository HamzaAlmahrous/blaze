import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/translations/locale_keys.g.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/const.dart';
import '../../components/default_button.dart';
import '../../components/default_format_field.dart';
import '../../components/styles/icon_broken.dart';
import '../../components/toast.dart';
import '../../helpers/local/chache_helper.dart';
import 'cubit/register_cubit.dart';
import 'cubit/register_state.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var nameController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is CreateUserErrorState) {
            String msg =
                state.error.substring(state.error.lastIndexOf(']') + 1);
            showToast(text: msg, state: ToastState.ERROR);
          }
          if (state is CreateUserSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = CacheHelper.getData(key: 'uId');
              SocialCubit.get(context)
                ..getUserData()
                ..getPosts()
                ..getAllUsers()
                ..getFollowers();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                            child: const Image(
                              image: AssetImage('assets/images/tinder_1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            LocaleKeys.join_now.tr(),
                            style:const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                            context: context,
                            controller: nameController,
                            keyboardType: TextInputType.emailAddress,
                            label: LocaleKeys.name.tr(),
                            prefix: IconBroken.User,
                            validate: (value) {
                              if (value!.isEmpty) {
                                String msg =
                                    LocaleKeys.please.tr() + LocaleKeys.name.tr();
                                return msg;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                            context: context,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            label: LocaleKeys.email.tr(),
                            prefix: Icons.email_outlined,
                            validate: (value) {
                              if (value!.isEmpty) {
                                String msg = LocaleKeys.please.tr() + LocaleKeys.email.tr();
                                return msg;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                            context: context,
                            controller: phoneController,
                            keyboardType: TextInputType.emailAddress,
                            label: LocaleKeys.phone.tr(),
                            prefix: IconBroken.Call,
                            validate: (value) {
                              if (value!.isEmpty) {
                                String msg = LocaleKeys.please.tr() + LocaleKeys.phone.tr(); 
                        return msg;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultFormField(
                              context: context,
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              label: LocaleKeys.password.tr(),
                              prefix: Icons.lock_outline,
                              suffix: RegisterCubit.get(context).suffix,
                              isPassword:
                                  RegisterCubit.get(context).showPassword,
                              suffixPressed: () {
                                RegisterCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              onSubmit: (value) {
                                if (registerFormKey.currentState!.validate()) {}
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
                            condition: state is! RegisterLoadingState,
                            builder: (context) => defaultButton(
                                gradient: const LinearGradient(colors: [
                                  defaultColor1,
                                  Colors.orange,
                                ]),
                                text: LocaleKeys.register.tr(),
                                isUpperCase: true,
                                function: () {
                                  if (registerFormKey.currentState!
                                      .validate()) {
                                    RegisterCubit.get(context).userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                }),
                            fallback: (context) => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(100.0),
                                child: LinearProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      ),
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
