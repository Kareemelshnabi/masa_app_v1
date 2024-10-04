import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mas_app/controller/chat/chat_controller.dart';
import 'package:mas_app/core/class/status_request.dart';
import 'package:mas_app/core/constant/colors.dart';
import 'package:mas_app/core/constant/images.dart';
import 'package:mas_app/generated/l10n.dart';
import 'package:mas_app/main.dart';
import 'package:mas_app/view/screens/chat/my_orders_chat.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.put(ChatController());

    return StreamBuilder<List<dynamic>>(
        stream: controller.getChatByIdStream(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: sharedPreferences!.getBool("darkMode") == false
                ? null
                : DarkMode.darkModeSplash,
            body: GetBuilder<ChatController>(
              builder: (controller) => controller.statuesRequest ==
                      StatuesRequest.loading
                  ? SizedBox(
                      height: 50.h,
                      width: 100.w,
                      child: const Center(child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          appBarChat(() async {
                            Get.off(() => const MyOrdersChat());
                          },
                              controller.nameOfOrder,
                              ImagesLink.noProfileImage,
                              controller.typeIndex == 0
                                  ? () {
                                      controller.chatModel!.merchantAssigned ==
                                              true
                                          ? controller.firstMessage()
                                          : null;
                                    }
                                  : () {},
                              controller.typeIndex == 0
                                  ? LightMode.registerText
                                  : LightMode.blueColor),
                          Container(
                            margin: EdgeInsets.only(bottom: 3.w),
                            height: 75.h,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 3.w,
                              ),
                              itemCount: controller.messages.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                print(controller.messages[index].sender);
                                return controller.messages[index].sender !=
                                        "user"
                                    ? InkWell(
                                        onTap: () {
                                          controller.messages[index].type ==
                                                  "file"
                                              ? controller.showImage(controller
                                                  .messages[index].attachment)
                                              : null;
                                        },
                                        child: chatPartFromMessage(
                                            ImagesLink.noProfileImage,
                                            controller.messages[index].content,
                                            controller.messages[index].type,
                                            controller
                                                .messages[index].attachment,
                                            () {}),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          controller.messages[index].type ==
                                                  "file"
                                              ? controller.showImage(controller
                                                  .messages[index].attachment)
                                              : null;
                                        },
                                        child: chatPartToMessage(
                                            controller.imageUser == null ||
                                                    controller.imageUser == ""
                                                ? AssetImage(
                                                    ImagesLink.noProfileImage)
                                                : CachedNetworkImageProvider(
                                                    controller.imageUser!),
                                            controller.chatModel!
                                                .messages![index].content,
                                            controller.messages[index].type,
                                            controller
                                                .messages[index].attachment,
                                            () {
                                              controller.showImage(controller
                                                  .messages[index].attachment);
                                            },
                                            controller.isPlay[controller
                                                .messages[index].id
                                                .toString()],
                                            () {
                                              if (controller.isPlay[controller
                                                          .messages[index].id
                                                          .toString()] ==
                                                      "0" ||
                                                  controller.isPlay[controller
                                                          .messages[index].id
                                                          .toString()] ==
                                                      null) {
                                                controller.setFavourite(
                                                    controller
                                                        .messages[index].id
                                                        .toString(),
                                                    "1");
                                              } else {
                                                controller.setFavourite(
                                                    controller
                                                        .messages[index].id
                                                        .toString(),
                                                    "0");
                                              }

                                              if (controller.isPlayer ==
                                                  false) {
                                                controller.play(
                                                    controller.messages[index]
                                                        .attachment,
                                                    index);
                                              } else {
                                                controller.stop(index);
                                              }
                                            }),
                                      );
                              },
                            ),
                          ),
                          if (controller.typeIndex == 0)
                            bottomBarChat(
                                controller.messageController,
                                S.of(context).clickWrite,
                                () {
                                  controller.getImageFromGallery();
                                },
                                () {
                                  controller.sendMessageText();
                                },
                                controller.messageController.text.isEmpty
                                    ? "voice"
                                    : "text",
                                controller.isRecord,
                                () {
                                  print("recorddddddddddddddddddd");
                                  controller.isRecord == false
                                      ? controller.startRecord()
                                      : controller.stopRecord();
                                }),
                          if (controller.typeIndex == 1)
                            bottmBarChatWithText(
                                " ${S.of(context).bottomOfTypePage} ",
                                LightMode.btnGreen),
                          if (controller.typeIndex == 2)
                            bottmBarChatWithText(" ${S.of(context).cancel} ",
                                LightMode.discountCollor),
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}

Widget chatPartToMessage(
    img, message, type, image, onPressShow, play, onPressPlay) {
  return SizedBox(
    width: 100.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 9.w,
          width: 9.w,
          decoration: BoxDecoration(
            border: Border.all(color: LightMode.splash),
            shape: BoxShape.circle,
            image: DecorationImage(image: img, fit: BoxFit.fill),
            color: sharedPreferences!.getString("img") == null ||
                    sharedPreferences!.getString("img") == "null" ||
                    sharedPreferences!.getString("img") == ""
                ? LightMode.registerButtonBorder
                : null,
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Container(
          padding: EdgeInsets.all(3.w),
          width: type == "file" ? 70.w : 40.w,
          decoration: BoxDecoration(
            border: Border.all(color: LightMode.splash),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: type == "file"
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.fill,
                )
              : type == "voice"
                  ? FittedBox(
                      child: Row(
                        children: [
                          Container(),
                          IconButton(
                            onPressed: onPressPlay,
                            icon: Icon(
                              play == "1"
                                  ? Icons.stop_circle_outlined
                                  : Icons.play_circle_outline_rounded,
                              color: sharedPreferences!.getBool("darkMode") ==
                                      false
                                  ? LightMode.splash
                                  : DarkMode.whiteDarkColor,
                              size: 20.w,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 50.w,
                            height: 2.w,
                            color: play == "1"
                                ? LightMode.btnGreen
                                : LightMode.splash,
                          )
                        ],
                      ),
                    )
                  : Text(
                      maxLines: 5,
                      message,
                      style: GoogleFonts.tajawal(
                          fontSize: 3.w,
                          fontWeight: FontWeight.w600,
                          color: sharedPreferences!.getBool("darkMode") == false
                              ? LightMode.registerButtonBorder
                              : DarkMode.whiteDarkColor.withOpacity(.5)),
                    ),
        ),
      ],
    ),
  );
}

Widget chatPartFromMessage(img, message, type, image, onPressShow) {
  return SizedBox(
    width: 100.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          width: type == "file" ? 70.w : 40.w,
          decoration: BoxDecoration(
            border: Border.all(color: LightMode.splash),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: type == "file"
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.fill,
                )
              : Text(
                  message,
                  maxLines: 5,
                  style: GoogleFonts.tajawal(
                      fontSize: 3.w,
                      fontWeight: FontWeight.w600,
                      color: sharedPreferences!.getBool("darkMode") == false
                          ? LightMode.registerButtonBorder
                          : DarkMode.whiteDarkColor.withOpacity(.5)),
                ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Container(
          height: 9.w,
          width: 9.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                ImagesLink.noProfileImage,
              ),
            ),
            color: LightMode.registerButtonBorder,
          ),
        ),
      ],
    ),
  );
}

Widget bottmBarChatWithText(text, color) {
  return Container(
      width: 100.w,
      //height: 10.h,
      padding: EdgeInsets.only(right: 5.w, left: 5.w, bottom: 5.w, top: 5.w),
      decoration: BoxDecoration(
        color: LightMode.splash,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7.w), topRight: Radius.circular(7.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            S.of(Get.context!).bottomPartOneChat,
            style: GoogleFonts.tajawal(
                fontSize: 3.5.w,
                fontWeight: FontWeight.w600,
                color: LightMode.registerText),
          ),
          Text(
            text,
            style: GoogleFonts.tajawal(
                fontSize: 3.5.w, fontWeight: FontWeight.w600, color: color),
          ),
          Text(
            S.of(Get.context!).bottomPartTwoChat,
            style: GoogleFonts.tajawal(
                fontSize: 3.5.w,
                fontWeight: FontWeight.w600,
                color: LightMode.registerText),
          ),
        ],
      ));
}

Widget bottomBarChat(
    controller, text, onPressFile, onPressSend, type, record, onPressVoice) {
  return Container(
    width: 100.w,
    //  height: 10.h,
    padding: EdgeInsets.only(right: 5.w, left: 5.w, bottom: 5.w, top: 5.w),
    decoration: BoxDecoration(
      border: sharedPreferences!.getBool("darkMode") == false
          ? null
          : Border(top: BorderSide(color: DarkMode.buttonDarkColor, width: 2)),
      color: sharedPreferences!.getBool("darkMode") == false
          ? LightMode.splash
          : DarkMode.darkModeSplash,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7.w), topRight: Radius.circular(7.w)),
    ),
    child: Row(
      children: [
        SizedBox(
          //  height: 10.h,
          width: 70.w,
          child: TextFormField(
            style: GoogleFonts.tajawal(
                color: LightMode.splash,
                fontSize: 3.w,
                fontWeight: FontWeight.w500),
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(bottom: 2.w, right: 2.w, left: 2.w, top: 2.w),
              filled: true,
              fillColor: LightMode.registerText,
              hintStyle: GoogleFonts.tajawal(
                  color: LightMode.splash,
                  fontSize: 4.w,
                  fontWeight: FontWeight.w500),
              hintText: text,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide.none),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.w),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: onPressFile,
              icon: Icon(
                Icons.insert_drive_file_outlined,
                color: LightMode.registerText,
                size: 5.w,
              )),
        ),
        SizedBox(
          width: 10.w,
          child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: type == "text" ? onPressSend : onPressVoice,
              icon: Icon(
                type == "text"
                    ? Icons.send_outlined
                    : ((type == "voice" && record == false)
                        ? Icons.mic
                        : Icons.stop),
                color: LightMode.registerText,
                size: 5.w,
              )),
        ),
      ],
    ),
  );
}

Widget appBarChat(onPress, name, img, onPressText, colorText) {
  return Container(
    width: 100.w,
    // height: 15.h,
    padding: EdgeInsets.only(right: 5.w, left: 5.w, bottom: 2.w, top: 5.h),
    decoration: BoxDecoration(
      border: sharedPreferences!.getBool("darkMode") == false
          ? null
          : Border(
              bottom: BorderSide(color: DarkMode.buttonDarkColor, width: 2)),
      color: sharedPreferences!.getBool("darkMode") == false
          ? LightMode.splash
          : DarkMode.darkModeSplash,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7.w), bottomRight: Radius.circular(7.w)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: sharedPreferences!.getString("local") == "ar" ? 60.w : 50.w,
          child: Row(
            children: [
              SizedBox(
                width: 7.w,
                child: IconButton(
                    onPressed: onPress,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: LightMode.registerText,
                      size: 6.w,
                    )),
              ),
              SizedBox(
                width: 10.w,
                child: CircleAvatar(
                  backgroundColor: LightMode.splash,
                  maxRadius: 5.w,
                  child: Image.asset(
                    img,
                    color: LightMode.registerButtonBorder,
                    fit: BoxFit.fill,
                    width: 9.w,
                    height: 9.w,
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                name,
                style: GoogleFonts.tajawal(
                    color: LightMode.registerText,
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onPressText,
          child: Text(
            S.of(Get.context!).additionalOption,
            style: TextStyle(
                color: colorText,
                fontSize: 3.5.w,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: colorText),
          ),
        )
      ],
    ),
  );
}
