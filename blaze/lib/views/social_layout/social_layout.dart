import 'package:blaze/components/const.dart';
import 'package:blaze/components/styles/icon_broken.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLayout extends StatefulWidget {
  SocialLayout({Key? key}) : super(key: key);

  @override
  State<SocialLayout> createState() => _SocialLayoutState();
}

class _SocialLayoutState extends State<SocialLayout>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(() {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: ((context, state) {
      }),
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[tabController.index],
                style: GoogleFonts.laila().copyWith(fontSize: 20.0)),
            bottom: TabBar(
              controller: tabController,
              labelColor: defaultColor1,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Iconsax.home, size: 30)),
                Tab(icon: Icon(Iconsax.discover_13, size: 30)),
                Tab(icon: Icon(Iconsax.message, size: 30)),
                Tab(icon: Icon(IconBroken.Profile, size: 30)),
              ],
              onTap: (index) {
                print(index);
                cubit.changeNav(index);
              },
            ),
            actions: [
              IconButton(onPressed: () {
                Navigator.pushNamed(context, '/search');
              }, icon: const Icon(IconBroken.Search)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(IconBroken.Notification, size: 30.0)),
            ],
          ),
          body: TabBarView(
            children: cubit.screens,
            controller: tabController,
          ),
        );
      },
    );
  }
}
