// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mas_app/controller/register/verify_code_controller.dart';
import 'package:mas_app/core/class/api.dart';
import 'package:mas_app/core/class/status_request.dart';
import 'package:mas_app/core/constant/colors.dart';
import 'package:mas_app/core/function/handling_data.dart';
import 'package:mas_app/data/data%20source/register.dart';
import 'package:mas_app/generated/l10n.dart';
import 'package:mas_app/main.dart';
import 'package:mas_app/view/screens/register/login/succcess_login.dart';
import 'package:mas_app/view/screens/register/signup/verify_code_register.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> loginGlobalKey = GlobalKey();
  VerifyCodeController controller = Get.put(VerifyCodeController());

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  StatuesRequest statuesRequest = StatuesRequest.none;
  RegisterRemoteData registerRemoteData = RegisterRemoteData(Get.put(Api()));
  bool showPass = true;
  String verificationId = '';
  String? tokenDevice;
  getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    tokenDevice = await messaging.getToken();
  }

  showPassword() {
    if (showPass == false) {
      showPass = true;
      update();
    } else {
      showPass = false;
      update();
    }
  }

  phoneValidate(String val, context) {
    if (val.isEmpty) {
      return S.of(context).errorPhone_1;
    } else if (val.length < 8 || val.length > 8) {
      return S.of(context).errorPhone_3;
    } else {
      return null;
    }
  }

  passwordValidate(String val, context) {
    if (val.isEmpty) {
      return S.of(context).errorPass_1;
    } else if (val.length < 8) {
      return S.of(context).errorPass_2;
    } else if (val.length > 20) {
      return S.of(context).errorPass_3;
    } else {
      return null;
    }
  }

  login(context) async {
    if (loginGlobalKey.currentState!.validate()) {
      print("nnn");
      print("token $tokenDevice");

      statuesRequest = StatuesRequest.loading;
      update();
      var response = await registerRemoteData.login(
          phoneController.text, passwordController.text, tokenDevice);
      print(response);
      statuesRequest = handlingData(response);
      if (statuesRequest == StatuesRequest.success) {
        Map responseBody = response['data'];
        print("response :: $responseBody");
        print("response :: ${responseBody['name']}");

        sharedPreferences!.setString("nameEn", "${responseBody['name']}");

        sharedPreferences!.setString("token", "${responseBody['token']}");

        sharedPreferences!.setString("email", "${responseBody['email']}");
        sharedPreferences!.setString("password", passwordController.text);
        sharedPreferences!.setString("address", "${responseBody['address']}");
        sharedPreferences!.setString("phone", "${responseBody['phone']}");
        sharedPreferences!.setString("img", "${responseBody['image']}");
        sharedPreferences!
            .setString("country", "${responseBody['country']['name']}");
        sharedPreferences!.setString("lat", "${responseBody['lat']}");
        sharedPreferences!.setString("lng", "${responseBody['lng']}");
        sharedPreferences!
            .setString("governorate", "${responseBody['governorate']['name']}");
        print(sharedPreferences!.getString("governorate"));
        sharedPreferences!
            .setString("governorateId", "${responseBody['governorate']['id']}");
        String text = responseBody['governorate']['name'];
        print(text);
        print("token1223 ${sharedPreferences!.getString("token")}");

        sharedPreferences!.setString("pageStart", "Home");
        Get.offAll(() => const SuccessLogin());
      } else if (statuesRequest == StatuesRequest.forbiddenException) {
        messageHandleException(S.of(context).notVerify, context);
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageHandleException(S.of(context).noInternetApi, context);
      } else if (statuesRequest == StatuesRequest.serverException) {
        messageHandleException(S.of(context).serverException, context);
      } else if (statuesRequest == StatuesRequest.unExpectedException) {
        messageHandleException(S.of(context).unExcepectedException, context);
      } else if (statuesRequest == StatuesRequest.defaultException) {
        messageHandleException(S.of(context).passwordNotCorrect, context);
      } else if (statuesRequest == StatuesRequest.serverError) {
        messageHandleException(S.of(context).serverError, context);
      } else if (statuesRequest == StatuesRequest.timeoutException) {
        messageHandleException(S.of(context).timeOutException, context);
      } else if (statuesRequest == StatuesRequest.unauthorizedException) {
        messageHandleException(S.of(context).passwordNotCorrect, context);
      } else if (statuesRequest == StatuesRequest.phoneNotVerify) {
        messageHandleException_2(S.of(context).confirmNum, context);
      }
      update();
    }
  }

  messageHandleException_2(message, context) {
    Get.defaultDialog(
        title: S.of(context).error,
                titleStyle:GoogleFonts.tajawal(
                  fontSize: 3.5.w,
                  color: LightMode.registerButtonBorder,
                  fontWeight: FontWeight.w500),
        content: Column(
          children: [
            Text(
              message,
              style: GoogleFonts.tajawal(
                  fontSize: 3.5.w,
                  color: LightMode.registerButtonBorder,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    await controller.reSendOtp(context);
                    Get.to(() => const VerifyCodeRegister());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: LightMode.splash,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    width: 30.w,
                    height: 5.h,
                    child: Center(
                      child: Text(
                        S.of(context).verifyPhone,
                        style: GoogleFonts.tajawal(
                            fontSize: 4.w,
                            color: LightMode.registerText,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: LightMode.splash),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    width: 30.w,
                    height: 5.h,
                    child: Center(
                      child: Text(
                        S.of(context).cancel,
                        style: GoogleFonts.tajawal(
                            fontSize: 4.w,
                            color: LightMode.splash,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  messageHandleException(message, context) {
    Get.defaultDialog(
        title: S.of(context).error,
                titleStyle:GoogleFonts.tajawal(
                  fontSize: 3.5.w,
                  color: LightMode.registerButtonBorder,
                  fontWeight: FontWeight.w500),
        content: Column(
          children: [
            Text(
              message,
              style: GoogleFonts.tajawal(
                  fontSize: 3.5.w,
                  color: LightMode.registerButtonBorder,
                  fontWeight: FontWeight.w500),
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: LightMode.splash,
                  borderRadius: BorderRadius.circular(3.w),
                ),
                width: 30.w,
                height: 5.h,
                child: Center(
                  child: Text(
                    S.of(context).tryAgain,
                    style: GoogleFonts.tajawal(
                        fontSize: 4.w,
                        color: LightMode.registerText,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void onInit() {
    getToken();
    super.onInit();
  }
}
