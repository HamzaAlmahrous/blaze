import 'package:blaze/components/const.dart';
import 'package:blaze/components/default_app_bar.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../components/styles/icon_broken.dart';
import '../../models/comments.dart';

class CommentScreen extends StatelessWidget {
  CommentScreen({Key? key, required this.postId}) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              function: () {
                cubit.comments.clear();
                Navigator.pop(context);
              },
              title: 'Comments'),
          backgroundColor: defaultColor4,
          body: state is SocialGetCommentsLoadingState
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      //  cubit.refershPage(1);
                    },
                    child: Column(
                      children: [
                        ConditionalBuilder(
                          condition: cubit.comments.isNotEmpty,
                          builder: (context) {
                            return Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return commentItem(
                                      cubit.comments[index], context, postId);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 20.0);
                                },
                                itemCount: cubit.comments.length,
                              ),
                            );
                          },
                          fallback: (context) {
                            return const Expanded(
                              child: Center(
                                  child: Text('There\'s no comments yet!')),
                            );
                          },
                        ),
                        if (SocialCubit.get(context).commentImage != null)
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 100.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  image: DecorationImage(
                                    image: FileImage(
                                        SocialCubit.get(context).commentImage!),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).removeCommentImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.lightBlue,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18.0,
                              backgroundImage: NetworkImage(
                                  SocialCubit.get(context).user.image),
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: TextFormField(
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    SocialCubit.get(context).addComment(
                                        text: value,
                                        postId: postId,
                                        dateTime: DateTime.now().toString());
                                    commentController.clear();
                                  }
                                },
                                controller: commentController,
                                
                                style: Theme.of(context).textTheme.caption,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'write a comment!',
                                  hintStyle:
                                      Theme.of(context).textTheme.caption,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: defaultColor1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .getCommentImage();
                                    },
                                    icon: const Icon(
                                      IconBroken.Image,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
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

Widget commentItem(SocialComment comment, context, String postId) {
  TextEditingController commentController = TextEditingController();
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(comment.image),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.name,
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
                    Text(
                      DateFormat("h:mm a d/M/y")
                          .format(DateTime.parse(comment.dateTime))
                          .toString(),
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                child: const Icon(IconBroken.More_Circle),
                itemBuilder: (context) {
                  return <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                        child: TextButton(
                            onPressed: () {
                              SocialCubit.get(context)
                                  .deleteComment(comment, postId);
                            },
                            child: const Text('delete comment'))),
                  ];
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
                width: double.infinity, height: 1.0, color: Colors.grey[300]),
          ),
          Text(comment.text, style: Theme.of(context).textTheme.subtitle1),
          if (comment.commentImage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(comment.commentImage!),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
