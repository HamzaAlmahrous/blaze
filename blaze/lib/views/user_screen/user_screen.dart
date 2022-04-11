import 'package:blaze/components/default_app_bar.dart';
import 'package:blaze/components/default_button.dart';
import 'package:blaze/components/default_post.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class UserScreen extends StatelessWidget {
  UserScreen({required this.user, Key? key}) : super(key: key);

  SocialUser user;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              function: () {
                Navigator.pop(context);
              }),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Align(
                          child: Container(
                            height: 140.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  user.cover,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        CircleAvatar(
                          radius: 64.0,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(
                              user.image,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    user.bio,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                cubit.userPosts.length.toString(),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Posts',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                user.followers.toString(),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                cubit.followers.length.toString(),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Following',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      cubit.followers.indexWhere(
                                  (element) => element.uId == user.uId) !=
                              -1
                          ? Expanded(
                              child: defaultButton(
                                  text: 'unfollow',
                                  function: () {
                                    cubit.unfollow(user.uId);
                                  }),
                            )
                          : Expanded(
                              child: defaultButton(
                                  text: 'follow',
                                  function: () {
                                    cubit.follow(user.uId);
                                  }),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  ConditionalBuilder(
                    condition: cubit.userPosts.isNotEmpty && cubit.user != null,
                    builder: (context) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) => buildPostItem(
                            cubit.userPosts[index], context, index),
                        separatorBuilder: (context, index) =>
                           const Divider(thickness: 8.0),
                        itemCount: cubit.userPosts.length,
                      );
                    },
                    fallback: (context) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
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
