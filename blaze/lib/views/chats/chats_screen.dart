import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/views/chat_details/chat_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../components/styles/icon_broken.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          body: state is SocialGetFollowersLoadingState
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                          height: MediaQuery.of(context).size.height,
                child: RefreshIndicator(
                    onRefresh: () async {
                      cubit.refershPage(2);
                    },
                    child: ConditionalBuilder(
                      condition: cubit.followers.isNotEmpty,
                      builder: (context) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatItem(cubit: cubit, index: index);
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: cubit.followers.length,
                        );
                      },
                      fallback: (context) {
                        return const Center(
                            child: Text('you don\'t follow anyone yet!'));
                      },
                    ),
                  ),
              ),
        );
      },
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.cubit,
    required this.index,
  }) : super(key: key);

  final SocialCubit cubit;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ChatDetailsScreen(receiver: cubit.followers[index])),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(cubit.followers[index].image),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Row(
                children: [
                  Text(
                    cubit.followers[index].name,
                    style: Theme.of(context).textTheme.bodyText1
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
                  cubit.unfollow(cubit.followers[index].uId);
                },
                icon: const Icon(IconBroken.Delete)),
          ],
        ),
      ),
    );
  }
}
