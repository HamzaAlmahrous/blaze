import 'package:blaze/components/const.dart';
import 'package:blaze/components/styles/icon_broken.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/models/post.dart';
import 'package:blaze/views/comment_screen/comment_screen.dart';
import 'package:blaze/views/full_image/full_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

 Widget buildPostItem(SocialPost post, context, index) {
    TextEditingController commentController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(post.image),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.name,
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
                        DateFormat("h:mm a  d/M/y")
                            .format(DateTime.parse(post.dateTime))
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15.0),
                PopupMenuButton(
                  child: const Icon(Iconsax.more_square),
                  itemBuilder: (context) {
                    return <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                          child: TextButton(
                              onPressed: () {
                                SocialCubit.get(context).deletePost(post);
                              },
                              child: const Text('delete post'))),
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
            Text(post.text, style: Theme.of(context).textTheme.subtitle1),
            if (post.postImage != '')
              InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (contaxt) => FullImageScreen(index: index, post: post)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(post.postImage!),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          children: [
                            const Icon(IconBroken.Heart,
                                size: 16.0, color: defaultColor1),
                            const SizedBox(width: 5.0),
                            Text(
                              post.likes.toString(),
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.comment_outlined,
                                size: 16.0, color: defaultColor2),
                            const SizedBox(width: 5.0),
                            Text(
                              'comments',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        SocialCubit.get(context).getCommetns(postId: post.pId!);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommentScreen(postId: post.pId!)));
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
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
                        image:
                            FileImage(SocialCubit.get(context).commentImage!),
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
            Row(
              children: [
                CircleAvatar(
                  radius: 18.0,
                  backgroundImage:
                      NetworkImage(SocialCubit.get(context).user.image),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        SocialCubit.get(context).addComment(
                            text: value,
                            postId: post.pId!,
                            dateTime: DateTime.now().toString());
                        commentController.clear();
                      }
                    },
                    controller: commentController,
                    style: Theme.of(context).textTheme.caption,
                    decoration: InputDecoration(
                      hintText: 'write a comment!',
                      hintStyle: Theme.of(context).textTheme.caption,
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
                          SocialCubit.get(context).getCommentImage();
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
                const SizedBox(width: 5.0),
                InkWell(
                  child: Row(
                    children: [
                      const Icon(IconBroken.Heart,
                          size: 16.0, color: defaultColor1),
                      const SizedBox(width: 5.0),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                  onTap: () {
                    SocialCubit.get(context).likePost(post.pId!,
                        SocialCubit.get(context).posts[index].likes!, index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
