import 'package:blaze/components/styles/icon_broken.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/models/post.dart';
import 'package:blaze/views/comment_screen/comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FullImageScreen extends StatelessWidget {
  FullImageScreen({required this.index, required this.post, Key? key}) : super(key: key);

  SocialPost post;
  int index;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(post.postImage!)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      cubit.saveImage(post.postImage!);
                    },
                    icon: const Icon(Iconsax.document_download, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.getCommetns(postId: post.pId!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentScreen(postId: post.pId!)));
                    },
                    icon: const Icon(Icons.comment_outlined, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.likePost(post.pId!,
                      cubit.posts[index].likes!, index);
                    },
                    icon: const Icon(IconBroken.Heart, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
