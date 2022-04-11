import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/views/user_screen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../components/styles/icon_broken.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          body: ConditionalBuilder(
            condition: cubit.allUsers.isNotEmpty,
            builder: (context) {
              return RefreshIndicator(
                
                onRefresh: () async {
                  cubit.refershPage(1);
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.separated(
                    shrinkWrap: true,physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return UserItem(cubit: cubit, index: index);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: cubit.allUsers.length,
                  ),
                ),
              );
            },
            fallback: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({
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
        cubit.getUserPosts(id: cubit.allUsers[index].uId);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UserScreen(user: cubit.allUsers[index])),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(cubit.allUsers[index].image),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Row(
                children: [
                  Text(
                    cubit.allUsers[index].name,
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
                  cubit.follow(cubit.allUsers[index].uId);
                }, icon: const Icon(IconBroken.Add_User)),
          ],
        ),
      ),
    );
  }
}
