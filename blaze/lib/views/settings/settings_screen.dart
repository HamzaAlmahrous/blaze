import 'package:blaze/components/const.dart';
import 'package:blaze/components/default_app_bar.dart';
import 'package:blaze/components/default_button.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              function: () {
                Navigator.pop(context);
              },
              title: LocaleKeys.settings.tr()),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  defaultButton(
                      function: () {
                        cubit.logOut(context);
                      },
                      text: LocaleKeys.log_out.tr(),
                  ),
                  const SizedBox(height: 10.0),
                  defaultButton(function: (){
                     cubit.changeAppMode(fromShared: !cubit.isDark);
                  }, text: cubit.isDark ? LocaleKeys.light_mode.tr() : LocaleKeys.dark_mode.tr() ),

                  const SizedBox(height: 20.0),
                  Text(LocaleKeys.change_lang.tr(), style: Theme.of(context).textTheme.bodyText1!.copyWith(color: defaultColor1),),
                  const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(100, 50))),
                                  onPressed: () async {
                                    cubit.changeLanguage('ar');
                                    cubit.isSelected[0] = true;
                                    cubit.isSelected[1] = false;
                                    await context.setLocale(const Locale('ar'));
                                  },
                                  child: const Text('العربية',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 20.0),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(100, 50)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      )),
                                  onPressed: () async {
                                    cubit.changeLanguage('en');
                                    cubit.isSelected[1] = true;
                                    cubit.isSelected[0] = false;
                                    await context.setLocale(const Locale('en'));
                                  },
                                  child: const Text('English',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
