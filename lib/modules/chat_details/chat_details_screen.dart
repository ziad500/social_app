import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/styles/iconBroken.dart';
import 'package:social_app/styles/colors.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key, this.userModel}) : super(key: key);
  final UserModel? userModel;

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(recieverId: userModel!.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is SocialSendMessageSuccessState) {
              messageController.clear();
            }
          },
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userModel!.image!),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      userModel!.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    cubit.messages.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: cubit.messages.length,
                              itemBuilder: (context, index) {
                                var message = cubit.messages[index];
                                if (uId == message.senderId) {
                                  return buildMyMessage(context, message);
                                } else {
                                  return buildMessage(context, message);
                                }
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10.0,
                              ),
                            ),
                          ),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1.0)),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                      hintText:
                                          'type your message here .....'))),
                          InkWell(
                            onTap: () {
                              cubit.sendMessages(
                                  recieverId: userModel!.uId!,
                                  text: messageController.text);
                            },
                            child: const CircleAvatar(
                              backgroundColor: defaultColor,
                              radius: 25,
                              child: Icon(
                                IconBroken.Send,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(context, MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10.0),
                    topStart: Radius.circular(10.0),
                    topEnd: Radius.circular(10.0))),
            child: Text(
              model.text!,
              style: Theme.of(context).textTheme.subtitle1,
            )),
      );

  Widget buildMyMessage(context, MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: const BoxDecoration(
                color: defaultColor,
                borderRadius: BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(10.0),
                    topStart: Radius.circular(10.0),
                    topEnd: Radius.circular(10.0))),
            child: Text(
              model.text!,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white),
            )),
      );
}
