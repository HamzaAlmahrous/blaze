import 'package:blaze/components/default_app_bar.dart';
import 'package:blaze/components/default_format_field.dart';
import 'package:blaze/components/styles/icon_broken.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/views/user_screen/user_screen.dart';
import 'package:blaze/views/users/users_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

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
                  cubit.searchResualt = [];
                  Navigator.pop(context);
                },
                title: 'search'),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        cubit.searchResualt = [];
                        cubit.search(s: value);
                      },
                    ),
                    state is SocialSearchLoadingState ? const Center(child: CircularProgressIndicator()) : ListView.separated(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            cubit.getUserPosts(id: cubit.searchResualt[index].uId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserScreen(user: cubit.searchResualt[index])),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage:
                                      NetworkImage(cubit.searchResualt[index].image),
                                ),
                                const SizedBox(width: 15.0),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        cubit.searchResualt[index].name,
                                        style: const TextStyle(
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.lightBlue,
                                        size: 16.0,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15.0),
                                IconButton(
                                    onPressed: () {
                                      cubit.follow(cubit.searchResualt[index].uId);
                                    },
                                    icon: const Icon(IconBroken.Add_User)),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: cubit.searchResualt.length,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
