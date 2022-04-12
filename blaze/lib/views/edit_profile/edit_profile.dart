import 'package:blaze/components/default_app_bar.dart';
import 'package:blaze/components/default_text_button.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/default_format_field.dart';
import '../../components/styles/icon_broken.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController bioController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        nameController.text = cubit.user.name;
        bioController.text = cubit.user.bio;
        phoneController.text = cubit.user.phone;

        return Scaffold(
          appBar: defaultAppBar(context: context,
          function: (){
            cubit.coverImage = null;
            cubit.profileImage = null;
            Navigator.pop(context);
          }
          ,
           title: LocaleKeys.edit_profile.tr(),
          actions: [
            defaultTextButton(function: (){
              if(cubit.coverImage != null){
                cubit.uploadCoverImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);
              }
              if(cubit.profileImage != null){
                cubit.uploadProfileImage(name: nameController.text, phone: phoneController.text, bio: bioController.text);  
              }
              if(cubit.profileImage == null && cubit.coverImage == null){
                cubit.updateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);  
              }
            }, text: LocaleKeys.update.tr()),
            const SizedBox(width: 5.0),
          ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(state is SocialUploadImageErrorState || state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                    const SizedBox(height: 5.0),
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ),
                                    topRight: Radius.circular(
                                      10.0,
                                    ),
                                  ),
                                  image: DecorationImage(
                                    image: cubit.coverImage == null ? NetworkImage(cubit.user.cover) : FileImage(cubit.coverImage!) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.getCoverImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Colors.lightBlue,
                                  child: Icon(
                                    IconBroken.Camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: cubit.profileImage == null ? NetworkImage(cubit.user.image) : FileImage(cubit.profileImage!) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.getProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.lightBlue,
                                child: Icon(
                                  IconBroken.Camera,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                    context: context,
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    label: LocaleKeys.name.tr(),
                    prefix: IconBroken.User,
                    validate: (value) {
                      if (value!.isEmpty) {
                        String msg = LocaleKeys.please.tr() + LocaleKeys.name.tr(); 
                        return msg;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                    context: context,
                    controller: bioController,
                    keyboardType: TextInputType.emailAddress,
                    label: LocaleKeys.bio.tr(),
                    prefix: IconBroken.Info_Circle,
                    validate: (value) {
                      if (value!.isEmpty) {
                        String msg = LocaleKeys.please.tr() + LocaleKeys.bio.tr(); 
                        return msg;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                    context: context,
                    controller: phoneController,
                    keyboardType: TextInputType.emailAddress,
                    label: LocaleKeys.phone.tr(),
                    prefix: IconBroken.Call,
                    validate: (value) {
                      if (value!.isEmpty) {
                        String msg = LocaleKeys.please.tr() + LocaleKeys.password.tr(); 
                        return msg;
                      }
                      return null;
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
