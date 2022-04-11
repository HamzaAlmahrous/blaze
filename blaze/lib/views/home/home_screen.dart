import 'package:blaze/components/const.dart';
import 'package:blaze/components/toast.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../components/default_post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialCommentPostsSuccessState) {
        showToast(
            text: 'comment added successfully', state: ToastState.SUCCESS);
      }
      if (state is SocialCommentPostsErrorState) {
        showToast(text: state.error, state: ToastState.ERROR);
      }
    }, builder: (context, state) {
      SocialCubit cubit = SocialCubit.get(context);
      return NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward &&
              !cubit.isFabVisible) {
            cubit.changeHomeFab(true);
          } else if (notification.direction == ScrollDirection.reverse &&
              cubit.isFabVisible) {
            cubit.changeHomeFab(false);
          }
          return true;
        },
        child: Scaffold(
          floatingActionButton: cubit.isFabVisible
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/new_post');
                  },
                  child: const Icon(Icons.post_add),
                )
              : null,
          body: ConditionalBuilder(
            condition:
                cubit.posts.isNotEmpty && cubit.user != SocialUser.empty(),
            builder: (context) {
              return RefreshIndicator(
                onRefresh: () async {
                  cubit.refershPage(0);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5.0,
                        margin: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: const [
                            FadeInImage(
                              placeholder:
                                  AssetImage('assets/images/tinder_3.png'),
                              image: NetworkImage(
                                  'https://img.freepik.com/free-photo/students-giving-five_23-2147663448.jpg?w=900'),
                              fit: BoxFit.cover,
                              height: 200.0,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'keep in touch with friends',
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          offset: Offset(-1, -1),
                                          color: Colors.black),
                                      Shadow(
                                          offset: Offset(1, -1),
                                          color: Colors.black),
                                      Shadow(
                                          offset: Offset(1, 1),
                                          color: Colors.black),
                                      Shadow(
                                          offset: Offset(-1, 1),
                                          color: Colors.black),
                                    ],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10.0, right: 5, left: 5),
                        child: SizedBox(
                          height: 60.0,
                          child: Card(
                            color: cubit.isDark ? Colors.grey : Colors.white,
                            elevation: 5.0,
                            child: InkWell(
                              child: Row(
                                children: [
                                  const SizedBox(width: 10.0),
                                  Container(
                                    padding: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      color: Colors.black,
                                    ),
                                    child: CircleAvatar(
                                      radius: 18.0,
                                      backgroundImage:
                                          NetworkImage(cubit.user.image),
                                    ),
                                  ),
                                  const SizedBox(width: 15.0),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: cubit.isDark
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                    child: Text(
                                      'What\'s on your mind?',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.post_add,
                                    size: 30.0,
                                  ),
                                  const SizedBox(width: 15.0),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/new_post');
                              },
                            ),
                          ),
                        ),
                      ),
                      ConditionalBuilder(
                        condition: cubit.posts.isNotEmpty && cubit.user != null,
                        builder: (context) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) => buildPostItem(
                                cubit.posts[index], context, index),
                            separatorBuilder: (context, index) =>
                                const Divider(thickness: 8.0),
                            itemCount: cubit.posts.length,
                          );
                        },
                        fallback: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              );
            },
            fallback: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );
    });
  }
}
