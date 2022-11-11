import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/iconBroken.dart';
import 'package:social_app/styles/colors.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: 'Edit Profile', actions: [
            TextButton(
                onPressed: () {
                  SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text);
                },
                child: const Text(
                  "UPDATE",
                  style: TextStyle(fontSize: 18, color: defaultColor),
                )),
            const SizedBox(
              width: 10,
            )
          ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    const SizedBox(
                      height: 15,
                    ),
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                height: 140,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0)),
                                    image: DecorationImage(
                                      image: coverImage != null
                                          ? Image.file(coverImage).image
                                          : NetworkImage(userModel.cover!),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: defaultColor,
                                  child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context)
                                            .getCoverImage();
                                      },
                                      icon: const Icon(
                                        IconBroken.Camera,
                                      )),
                                ),
                              )
                            ],
                          ),
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
                                backgroundImage: profileImage != null
                                    ? Image.file(profileImage).image
                                    : NetworkImage(userModel.image!),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: defaultColor,
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .getProfileImage();
                                    },
                                    icon: const Icon(
                                      IconBroken.Camera,
                                    )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      if (SocialCubit.get(context).profileImage != null)
                        Expanded(
                            child: Column(
                          children: [
                            defaultButton(
                                function: () {
                                  SocialCubit.get(context).uploadProfileImage(
                                      bio: bioController.text,
                                      name: nameController.text,
                                      phone: phoneController.text);
                                },
                                text: "Upload Profile"),
                            if (state is SocialUserUpdateLoadingState)
                              const SizedBox(
                                height: 5,
                              ),
                            if (state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        )),
                      const SizedBox(
                        width: 8,
                      ),
                      if (SocialCubit.get(context).coverImage != null)
                        Expanded(
                            child: Column(
                          children: [
                            defaultButton(
                                function: () {
                                  SocialCubit.get(context).uploadCoverImage(
                                      bio: bioController.text,
                                      name: nameController.text,
                                      phone: phoneController.text);
                                },
                                text: "Upload Cover"),
                            if (state is SocialUserUpdateLoadingState)
                              const SizedBox(
                                height: 5,
                              ),
                            if (state is SocialUserUpdateLoadingState)
                              const LinearProgressIndicator(),
                          ],
                        )),
                    ],
                  ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    const SizedBox(
                      height: 20,
                    ),
                  defaultFormField(context,
                      controller: nameController,
                      type: TextInputType.name, validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'name must not be empty';
                    }
                    return null;
                  }, label: 'name', prefix: IconBroken.User),
                  const SizedBox(
                    height: 15,
                  ),
                  defaultFormField(context,
                      controller: bioController,
                      type: TextInputType.text, validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'bio must not be empty';
                    }
                    return null;
                  }, label: 'Bio', prefix: IconBroken.Info_Circle),
                  const SizedBox(
                    height: 15,
                  ),
                  defaultFormField(context,
                      controller: phoneController,
                      type: TextInputType.phone, validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'phone must not be empty';
                    }
                    return null;
                  }, label: 'phone', prefix: IconBroken.Call),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
