// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mas_app/core/class/api.dart';
import 'package:mas_app/core/class/status_request.dart';
import 'package:mas_app/core/constant/colors.dart';
import 'package:mas_app/core/function/handling_data.dart';
import 'package:mas_app/data/data%20source/orders.dart';
import 'package:mas_app/data/data%20source/register.dart';
import 'package:mas_app/data/data%20source/search.dart';
import 'package:mas_app/data/data%20source/services.dart';
import 'package:mas_app/data/model/country_model.dart';
import 'package:mas_app/data/model/product_model.dart';
import 'package:mas_app/data/model/service_model.dart';
import 'package:mas_app/data/model/store_order_model.dart';
import 'package:mas_app/generated/l10n.dart';
import 'package:mas_app/main.dart';
import 'package:mas_app/view/screens/register/main_register.dart';
import 'package:mas_app/view/widget/loading.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePageController extends GetxController {
  SpeechToText speechToText = SpeechToText();
  RegisterRemoteData registerRemoteData = RegisterRemoteData(Get.put(Api()));

  CountryMoodel? countryMoodel;
  String governorateId = '';
  String governorateName = '';
  bool lock = false;
  bool speechEnabled = false;
  // String wordsSpoken = "";
  double confidenceLevel = 0;
  void initSpeech() async {
    print("initialized");
    speechEnabled = await speechToText.initialize();
    print(speechEnabled);
    update();
  }

  void startListening() async {
    await speechToText.listen(
      onResult: onSpeechResult,
      // translate to arabic => by default english
      localeId: "ar",
    );

    confidenceLevel = 0;
    update();
  }

  void stopListening() async {
    await speechToText.stop();
    update();
  }

  void onSpeechResult(result) async {
    searchController.text = "${result.recognizedWords}";
    print("  result >>${result.recognizedWords}");
    if (searchController.text == "") {
      isSearch = false;
      update();
    } else {
      isSearch = true;
      await search();
      update();
    }
    confidenceLevel = result.confidence;
    update();
  }

  TextEditingController searchController = TextEditingController();
  List<ServiceModel> services = [];
  StatuesRequest statuesRequest = StatuesRequest.none;
  ServicesRemoteData servicesRemoteData = ServicesRemoteData(Get.put(Api()));
  SearchRemoteData searchRemoteData = SearchRemoteData(Get.put(Api()));

  bool isSearch = false;
  List<ProductModel> searchItems = [];
  bool succsess = false;
  OrdersRemoteData ordersRemoteData = OrdersRemoteData(Get.put(Api()));

  StoreOrderModel? storeOrderModel;
  String lat = '';
  String lng = '';

  storeOrder(orderId, orderType, orderQuantity) async {
    succsess = false;
   // lock = true;
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await ordersRemoteData.storeOrder(
        sharedPreferences!.getString("token"),
        orderId.toString(),
        orderType.toString(),
        orderQuantity.toString(),
        governorateId,
        sharedPreferences!.getString("lat"),
        sharedPreferences!.getString("lng"));
    print(response);
    statuesRequest = handlingData(response);
    if (statuesRequest == StatuesRequest.success) {
      Map<String, dynamic> responseBody = response['data'];

      storeOrderModel = StoreOrderModel.fromJson(responseBody);
      succsess = true;
      lock = false;
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageHandleException(S.of(Get.context!).noInternetApi);
    } else if (statuesRequest == StatuesRequest.serverException) {
      messageHandleException(S.of(Get.context!).serverException);
    } else if (statuesRequest == StatuesRequest.unExpectedException) {
      messageHandleException(S.of(Get.context!).unExcepectedException);
    } else if (statuesRequest == StatuesRequest.defaultException) {
      messageHandleException(S.of(Get.context!).defultException);
    } else if (statuesRequest == StatuesRequest.serverError) {
      messageHandleException(S.of(Get.context!).serverError);
    } else if (statuesRequest == StatuesRequest.timeoutException) {
      messageHandleException(S.of(Get.context!).timeOutException);
    } else if (statuesRequest == StatuesRequest.unauthorizedException) {
      messageHandleException(S.of(Get.context!).errorUnAuthorized);
    }
    update();
  }

  checkSearch(String value) async {
    print(value);
    if (value == "") {
      isSearch = false;
      update();
    } else {
      isSearch = true;
      await search();
      update();
    }
  }

  message(message) {
    Get.defaultDialog(
        title: S.of(Get.context!).error,
                titleStyle:GoogleFonts.tajawal(
                  fontSize: 3.5.w,
                  color: LightMode.registerButtonBorder,
                  fontWeight: FontWeight.w500),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                    fontSize: 3.5.w,
                    color: LightMode.registerButtonBorder,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 3.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.off(() => const MainRegister());
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
                          S.of(Get.context!).signup,
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
                          S.of(Get.context!).cancel,
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
          ),
        ));
  }

  search() async {
    searchItems.clear();
    print("  search    .... $searchItems");
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await searchRemoteData.getData(searchController.text);
    print(response);
    statuesRequest = handlingData(response);
    if (statuesRequest == StatuesRequest.success) {
      List responseBody = response['data']['items'];
      searchItems = [];
      searchItems.addAll(responseBody.map((e) => ProductModel.fromJson(e)));
      print("search item >>>>> $searchItems");
      //return searchItems;
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageHandleException(S.of(Get.context!).noInternetApi);
    } else if (statuesRequest == StatuesRequest.serverException) {
      messageHandleException(S.of(Get.context!).serverException);
    } else if (statuesRequest == StatuesRequest.unExpectedException) {
      messageHandleException(S.of(Get.context!).unExcepectedException);
    } else if (statuesRequest == StatuesRequest.defaultException) {
      messageHandleException(S.of(Get.context!).defultException);
    } else if (statuesRequest == StatuesRequest.serverError) {
      messageHandleException(S.of(Get.context!).serverError);
    } else if (statuesRequest == StatuesRequest.timeoutException) {
      messageHandleException(S.of(Get.context!).timeOutException);
    } else if (statuesRequest == StatuesRequest.unauthorizedException) {
      messageHandleException(S.of(Get.context!).errorUnAuthorized);
    }
    update();
  }

  getServices() async {
    services.clear();
    statuesRequest = StatuesRequest.loading;
    update();
    var response = await servicesRemoteData.getData();
    print(response);
    statuesRequest = handlingData(response);
    if (statuesRequest == StatuesRequest.success) {
      List responseBody = response['data']['items'];
      if (responseBody.isEmpty) {
      } else {
        for (int index = 0;
            responseBody.length == 1
                ? index < 1
                : responseBody.length == 2
                    ? index < 2
                    : responseBody.length == 3
                        ? index < 3
                        : index < 4;
            index++) {
          services.add(ServiceModel.fromJson(responseBody[index]));
        }
      }
      //  return services;
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageHandleException(S.of(Get.context!).noInternetApi);
    } else if (statuesRequest == StatuesRequest.serverException) {
      messageHandleException(S.of(Get.context!).serverException);
    } else if (statuesRequest == StatuesRequest.unExpectedException) {
      messageHandleException(S.of(Get.context!).unExcepectedException);
    } else if (statuesRequest == StatuesRequest.defaultException) {
      messageHandleException(S.of(Get.context!).defultException);
    } else if (statuesRequest == StatuesRequest.serverError) {
      messageHandleException(S.of(Get.context!).serverError);
    } else if (statuesRequest == StatuesRequest.timeoutException) {
      messageHandleException(S.of(Get.context!).timeOutException);
    } else if (statuesRequest == StatuesRequest.unauthorizedException) {
      messageHandleException(S.of(Get.context!).errorUnAuthorized);
    }
    update();
  }

  messageHandleException(message) {
    Get.defaultDialog(
        title: S.of(Get.context!).error,
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
                    S.of(Get.context!).tryAgain,
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

  getCountries(context) async {
    var response = await registerRemoteData.getCountry();
    print(response);

    statuesRequest = handlingData(response);
    if (statuesRequest == StatuesRequest.success) {
      Map<String, dynamic> responseBody = response['data'][0];
      print("response :: $responseBody");
      countryMoodel = CountryMoodel.fromJson(responseBody);
    } else if (statuesRequest == StatuesRequest.unprocessableException) {
      messageHandleException(
        S.of(context).error,
      );
    } else if (statuesRequest == StatuesRequest.socketException) {
      messageHandleException(
        S.of(context).noInternetApi,
      );
    } else if (statuesRequest == StatuesRequest.serverException) {
      messageHandleException(
        S.of(context).serverException,
      );
    } else if (statuesRequest == StatuesRequest.unExpectedException) {
      messageHandleException(
        S.of(context).unExcepectedException,
      );
    } else if (statuesRequest == StatuesRequest.defaultException) {
      messageHandleException(
        S.of(context).errorPhoneUseBeforeApi,
      );
    } else if (statuesRequest == StatuesRequest.serverError) {
      messageHandleException(
        S.of(context).serverError,
      );
    } else if (statuesRequest == StatuesRequest.timeoutException) {
      messageHandleException(
        S.of(context).timeOutException,
      );
    } else if (statuesRequest == StatuesRequest.unauthorizedException) {
      messageHandleException(
        S.of(context).passwordNotCorrect,
      );
    }

    update();
  }

  showDialogGovernate() {
    return showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 80.w,
          height: 50.h,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 5.w),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.w),
                      topRight: Radius.circular(2.w)),
                  color: LightMode.splash,
                ),
                width: 80.w,
                height: 8.h,
                child: Text(
                  S.of(context).chhoseGovernorate,
                  style: GoogleFonts.tajawal(
                      fontSize: 5.w,
                      color: LightMode.registerText,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: 80.w,
                height: 42.h,
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            governorateId = countryMoodel!
                                .governorates![index].id
                                .toString();
                            governorateName =
                                countryMoodel!.governorates![index].name!;

                            Get.back();
                            update();
                          },
                          child: Container(
                            padding:
                                sharedPreferences!.getString("local") == "ar"
                                    ? EdgeInsets.only(top: 3.w, right: 5.w)
                                    : EdgeInsets.only(top: 3.w, left: 5.w),
                            height: 6.h,
                            width: 80.w,
                            child: Text(
                              countryMoodel!.governorates![index].name!,
                              style: GoogleFonts.tajawal(
                                  fontSize: 4.w,
                                  color: LightMode.registerButtonBorder,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: countryMoodel!.governorates!.length),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  messageAddressDelivery(onPressConfirm) {
    Get.defaultDialog(
        onWillPop: () async {
          return false;
        },
        barrierDismissible: false,
        title: S.of(Get.context!).confirmAddress,
        titleStyle: GoogleFonts.tajawal(
            fontSize: 5.w,
            color: LightMode.registerButtonBorder,
            fontWeight: FontWeight.w500),
        content: Builder(builder: (context) {
          return GetBuilder<HomePageController>(
            builder: (controller) =>statuesRequest==StatuesRequest.loading?loading(25.h): Container(
              margin: EdgeInsets.only(right: 3.w, left: 3.w, bottom: 3.w),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await showDialogGovernate();

                      // messageAddressDelivery(onPressConfirm);
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 5.w),
                      alignment: Alignment.centerRight,
                      width: 70.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.w),
                          border: Border.all(color: LightMode.splash)),
                      child: Text(
                        governorateName,
                        style: GoogleFonts.tajawal(
                            fontSize: 4.w,
                            color: LightMode.splash,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: onPressConfirm,
                        child: Container(
                          alignment: Alignment.center,
                          width: 30.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: LightMode.splash,
                              borderRadius: BorderRadius.circular(4.w),
                              border: Border.all(
                                  color: LightMode.splash, width: 2)),
                          child: Text(
                            S.of(context).bottomOfTypePage,
                            style: GoogleFonts.tajawal(
                                fontSize: 4.w,
                                color: LightMode.registerText,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 30.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                              color: LightMode.registerText,
                              borderRadius: BorderRadius.circular(4.w),
                              border: Border.all(
                                  color: LightMode.splash, width: 2)),
                          child: Text(
                            S.of(context).cancel,
                            style: GoogleFonts.tajawal(
                                fontSize: 4.w,
                                color: LightMode.splash,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }

  @override
  void onInit() {
    governorateName = sharedPreferences!.getString("governorate") == null
        ? ""
        : sharedPreferences!.getString("governorate")!;
    governorateId = sharedPreferences!.getString("governorateId") == null
        ? ""
        : sharedPreferences!.getString("governorateId")!;
    print("  >>>>>>>>  $governorateName");
    initSpeech();
    getCountries(Get.context);
    getServices();

    super.onInit();
  }
}
