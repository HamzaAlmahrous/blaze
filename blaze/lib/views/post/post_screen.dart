import 'package:blaze/components/const.dart';
import 'package:blaze/components/default_app_bar.dart';
import 'package:blaze/components/styles/icon_broken.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/default_text_button.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController postController = TextEditingController();

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: defaultAppBar(
                context: context,
                function: () {
                  cubit.postImage = null;
                  Navigator.pop(context);
                },
                title: 'Create Post',
                actions: [
                  defaultTextButton(
                      function: () {
                        var now = DateTime.now();

                        if (cubit.postImage == null) {
                          cubit.createPost(
                              text: postController.text,
                              dateTime: now.toString());
                        } else {
                          cubit.uploadPostImage(
                              text: postController.text,
                              dateTime: now.toString());
                        }
                        Navigator.pop(context);
                      },
                      text: 'Post'),
                  const SizedBox(width: 8.0),
                ]),
            body: Column(children: [
              if (state is SocialCreatePostLoadingState)
                const LinearProgressIndicator(),
              const SizedBox(height: 5.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20.0),
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      cubit.user.image,
                    ),
                  ),
                  const SizedBox(width: 15.0),
                  Text(
                    cubit.user.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: TextFormField(
                  controller: postController,
                  maxLines: 50,
                  decoration: const InputDecoration(
                    hintText: 'what\'s on your mind...',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 14.0, color: defaultColor1),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (cubit.postImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 140.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          image: FileImage(cubit.postImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cubit.removePostImage();
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      cubit.getPostImage();
                    },
                    child: Row(
                      children: const [
                        Icon(IconBroken.Image_2, size: 30.0),
                        SizedBox(width: 5.0),
                        Text('add image', style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('# add tag',
                        style: TextStyle(fontSize: 16.0)),
                  ),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
