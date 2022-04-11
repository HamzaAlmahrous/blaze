import 'package:blaze/components/const.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../components/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../models/user.dart';

final TextEditingController messageController = TextEditingController();

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({required this.receiver, Key? key}) : super(key: key);

  SocialUser receiver;

  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).getMessages(receiverId: receiver.uId);

    return Builder(
      builder: (context) {
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialCubit cubit = SocialCubit.get(context);
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  titleSpacing: 0.0,
                  leading: IconButton(
                    icon: const Icon(IconBroken.Arrow___Left_2),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: defaultColor2,
                          ),
                          padding: const EdgeInsetsDirectional.all(2.0),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(receiver.image),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Text(
                          receiver.name,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 15.0, right: 15.0, bottom: 5.0),
                  child: Column(
                    children: [
                      ConditionalBuilder(
                        condition: cubit.messages.isNotEmpty,
                        builder: (contxt) {
                          return Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  SocialMessage message = cubit.messages[index];
                                  if (message.senderId == cubit.user.uId) {
                                    return MyMessage(message: message);
                                  } else {
                                    return Message(message: message);
                                  }
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 5.0);
                                },
                                itemCount: cubit.messages.length),
                          );
                        },
                        fallback: (context) => Expanded(
                          child: Center(
                            child: Text(
                              'No messages!',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'type your message here..',
                                hintStyle: TextStyle(color: Colors.white),
                                fillColor: defaultColor2,
                                filled: true,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          CircleAvatar(
                            backgroundColor: defaultColor1,
                            radius: 25.0,
                            child: MaterialButton(
                              onPressed: () {
                                cubit.sendMessage(
                                    receiver.uId,
                                    DateTime.now().toString(),
                                    messageController.text);
                                messageController.clear();
                              },
                              child: const Icon(Icons.send,
                                  size: 20.0, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MyMessage extends StatelessWidget {
  MyMessage({
    required this.message,
    Key? key,
  }) : super(key: key);

  SocialMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: const BoxDecoration(
            color: defaultColor4,
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            )),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(message.text, style: const TextStyle(fontSize: 17.0)),
            const SizedBox(width: 3.0),
            Text(DateFormat("h:mm a").format(DateTime.parse(message.dateTime)).toString() , style: const TextStyle(fontSize: 8.0)),
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  Message({
    required this.message,
    Key? key,
  }) : super(key: key);

  SocialMessage message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
            color: defaultColor3.withOpacity(0.5),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            )),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(message.text, style: const TextStyle(fontSize: 17.0)),
            const SizedBox(width: 3.0),
            Text(DateFormat("h:mm a").format(DateTime.parse(message.dateTime)).toString() , style: const TextStyle(fontSize: 8.0)),
          ],
        ),
      ),
    );
  }
}
