import 'package:blaze/components/default_post.dart';
import 'package:blaze/components/styles/icon_broken.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:iconsax/iconsax.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              cubit.refershPage(3);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            child: Container(
                              height: 160.0,
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              child: FadeInImage(
                                placeholder:
                                   const AssetImage('assets/images/tinder_3.png'),
                                image: NetworkImage(
                                  cubit.user.cover,
                                ),
                                fit: BoxFit.cover,
                              ),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(
                                    15.0,
                                  ),
                                  bottomLeft: Radius.circular(
                                    15.0,
                                  ),
                                ),
                              ),
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                        ),
                        CircleAvatar(
                          radius: 64.0,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundImage: NetworkImage(
                              cubit.user.image,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    cubit.user.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    cubit.user.bio,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  cubit.userPosts.length.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  LocaleKeys.posts.tr(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  cubit.user.followers.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  LocaleKeys.followers.tr(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Column(
                              children: [
                                Text(
                                  cubit.followers.length.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  LocaleKeys.following.tr(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/new_post');
                          },
                          child: Text(
                            LocaleKeys.create_post.tr(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit_profile');
                          cubit.coverImage = null;
                          cubit.profileImage = null;
                        },
                        child: const Icon(
                          IconBroken.Edit,
                          size: 16.0,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                        child: const Icon(
                          Iconsax.setting,
                          size: 16.0,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 5.0,
                  ),
                  ConditionalBuilder(
                    condition: cubit.userPosts.isNotEmpty,
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
                      return const Center(child: CircularProgressIndicator());
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
