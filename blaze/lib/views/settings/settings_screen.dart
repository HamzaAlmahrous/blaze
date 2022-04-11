import 'package:blaze/components/default_app_bar.dart';
import 'package:blaze/components/default_button.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              function: () {
                Navigator.pop(context);
              },
              title: 'settings'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  defaultButton(
                      function: () {
                        SocialCubit.get(context).logOut(context);
                      },
                      text: 'log out',
                  ),
                  const SizedBox(height: 10.0),
                  defaultButton(function: (){
                     SocialCubit.get(context).changeAppMode(fromShared: !SocialCubit.get(context).isDark);
                  }, text: SocialCubit.get(context).isDark ? 'switch to light mode' : 'switch to dark mode' ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
