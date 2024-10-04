import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mas_app/controller/orders/my_order_info_controller.dart';
import 'package:mas_app/core/constant/colors.dart';
import 'package:mas_app/core/constant/images.dart';
import 'package:mas_app/data/model/order_model.dart';
import 'package:mas_app/generated/l10n.dart';
import 'package:mas_app/main.dart';
import 'package:mas_app/view/screens/orders/my_orders.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class MyOrderInfo extends StatelessWidget {
  const MyOrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    MyOrderInfoController controller = Get.put(MyOrderInfoController());
    return Scaffold(
      backgroundColor: sharedPreferences!.getBool("darkMode") == false
          ? LightMode.registerText
          : DarkMode.darkModeSplash,
      body: SingleChildScrollView(
        child: Column(
          children: [
            appBarMyOrders(context),
            GetBuilder<MyOrderInfoController>(
                builder: (controller) => topPartOfPage(
                    controller.showAddress,
                    controller.showInfo,
                    (controller.showAddress == true &&
                            controller.showInfo == true)
                        ? 41.h
                        : (controller.showAddress == true &&
                                controller.showInfo == false)
                            ? 33.h
                            : (controller.showAddress == false &&
                                    controller.showInfo == true)
                                ? 30.5.h
                                : 20.5.h,
                    controller.showInfo == true ? 12.h : 4.h,
                    controller.showAddress == true ? 32.h : 4.h,
                    () {
                      controller.changeShow("address");
                    },
                    () {
                      controller.changeShow("info");
                    },
                    controller.orderModel!.code,
                    controller.orderModel!.createdAt!.substring(
                        0, controller.orderModel!.createdAt!.indexOf(" ")),
                    "${controller.orderModel!.total} دينار",
                    controller.controllerArea,
                    controller.controllerBloc,
                    controller.controllerStreet,
                    controller.controllerHouseNum,
                    controller.edit,
                    controller.showInfo == true
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    controller.showAddress == true
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    () {
                      controller.showMessage();
                    },
                    sharedPreferences!.getString("country"),
                    controller.orderModel!.userAddress,
                    sharedPreferences!.getString("governorate"),
                    controller.controllerGovernorate,
                    () {
                      controller.showMessage();
                    })),
            order(
                controller.orderModel!.code,
                controller.orderModel!,
                controller.orderModel!.subTotal,
                controller.orderModel!.tax,
                controller.orderModel!.deliveryFee == null ||
                        controller.orderModel!.deliveryFee == ""
                    ? S.of(context).free
                    : controller.orderModel!.deliveryFee,
                controller.orderModel!.total),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.w)),
                  border: Border.all(color: LightMode.splash, width: 2),
                  color: sharedPreferences!.getBool("darkMode") == false
                      ? LightMode.searchField.withOpacity(.1)
                      : DarkMode.whiteDarkColor),
              margin: EdgeInsets.only(right: 4.w, left: 4.w),
              child: Column(
                children: [
                  rowTypeOfOrder(
                    (controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "confirmed" ||
                            controller.orderModel!.status == "delivery" ||
                            controller.orderModel!.status == "paid")
                        ? Icons.check_circle
                        : (controller.orderModel!.status == "pending"
                            ? Icons.circle
                            : Icons.cancel),
                    (controller.orderModel!.status == "confirmed" ||
                            controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery" ||
                            controller.orderModel!.status == "paid")
                        ? LightMode.btnGreen
                        : (controller.orderModel!.status == "pending")
                            ? LightMode.registerButtonBorder.withOpacity(.3)
                            : LightMode.discountCollor,
                    S.of(context).confirmStatus,
                    (controller.orderModel!.status == "confirmed" ||
                            controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery" ||
                            controller.orderModel!.status == "paid")
                        ? FontWeight.bold
                        : (controller.orderModel!.status == "pending"
                            ? FontWeight.w600
                            : FontWeight.bold),
                  ),
                  rowTypeOfOrder(
                    (controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery" ||
                            controller.orderModel!.status == "paid")
                        ? Icons.check_circle
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed")
                            ? Icons.circle
                            : Icons.cancel),
                    (controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery" ||
                            controller.orderModel!.status == "paid")
                        ? LightMode.btnGreen
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed")
                            ? LightMode.registerButtonBorder.withOpacity(.3)
                            : LightMode.discountCollor),
                    S.of(context).paidStatus,
                    (controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery" ||
                            controller.orderModel!.status == "paid")
                        ? FontWeight.bold
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed")
                            ? FontWeight.w600
                            : FontWeight.bold),
                  ),
                  rowTypeOfOrder(
                    (controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery")
                        ? Icons.check_circle
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed" ||
                                controller.orderModel!.status == "paid")
                            ? Icons.circle
                            : Icons.cancel),
                    (controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery")
                        ? LightMode.btnGreen
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed" ||
                                controller.orderModel!.status == "paid")
                            ? LightMode.registerButtonBorder.withOpacity(.3)
                            : LightMode.discountCollor),
                    S.of(context).deliverStatus,
                    (controller.orderModel!.status == "completed" ||
                            controller.orderModel!.status == "delivery")
                        ? FontWeight.bold
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed" ||
                                controller.orderModel!.status == "paid")
                            ? FontWeight.w600
                            : FontWeight.bold),
                  ),
                  rowTypeOfOrder(
                    (controller.orderModel!.status == "completed")
                        ? Icons.check_circle
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed" ||
                                controller.orderModel!.status == "paid" ||
                                controller.orderModel!.status == "delivery")
                            ? Icons.circle
                            : Icons.cancel),
                    (controller.orderModel!.status == "completed")
                        ? LightMode.btnGreen
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed" ||
                                controller.orderModel!.status == "paid" ||
                                controller.orderModel!.status == "delivery")
                            ? LightMode.registerButtonBorder.withOpacity(.3)
                            : LightMode.discountCollor),
                    S.of(context).deliveredStatus,
                    (controller.orderModel!.status == "completed")
                        ? FontWeight.bold
                        : ((controller.orderModel!.status == "pending" ||
                                controller.orderModel!.status == "confirmed" ||
                                controller.orderModel!.status == "paid" ||
                                controller.orderModel!.status == "delivery")
                            ? FontWeight.w600
                            : FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.w,
            ),
            if (controller.page == "chat")
              btnOrderLocation(() {
                Get.back();
              }),
            SizedBox(
              height: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget btnCancel(text, onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              border: Border.all(color: LightMode.discountCollor)),
          width: 40.w,
          height: 6.h,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.tajawal(
                  color: LightMode.discountCollor,
                  fontSize: 4.w,
                  fontWeight: FontWeight.w500),
            ),
          )),
    );
  }

  Widget btnOrderLocation(onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: LightMode.splash, borderRadius: BorderRadius.circular(4.w)),
        width: 80.w,
        height: 6.h,
        child: Text(
          S.of(Get.context!).returnChat,
          style: GoogleFonts.tajawal(
              color: LightMode.registerText,
              fontSize: 4.w,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget appBarMyOrders(context) {
    return SizedBox(
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 20.w,
            child: Padding(
              padding: EdgeInsets.only(top: 7.w),
              child: IconButton(
                  onPressed: () {
                    Navigator.canPop(context)
                        ? Get.back()
                        : Get.off(() => const MyOrders());
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 6.w,
                    color: sharedPreferences!.getBool("darkMode") == false
                        ? null
                        : DarkMode.whiteDarkColor,
                  )),
            ),
          ),
          SizedBox(
            width: 60.w,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: 6.5.h,
                bottom: 2.h,
              ),
              child: Text(
                S.of(context).detailOrder,
                style: GoogleFonts.tajawal(
                  fontSize: 5.w,
                  fontWeight: FontWeight.bold,
                  color: sharedPreferences!.getBool("darkMode") == false
                      ? LightMode.typeUserTitle
                      : DarkMode.whiteDarkColor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
        ],
      ),
    );
  }

  Widget topPartOfPage(
      showAddress,
      showInfo,
      heigh,
      heightPart1,
      heighPart2,
      onPressDropAddress,
      onPressDropInfo,
      numOfOrder,
      dateOfOrder,
      priceOfOrder,
      controllerArea,
      controllerBloc,
      controllerStreet,
      controllerHouseNum,
      edit,
      iconInfo,
      iconAddress,
      onPressEdit,
      areaName,
      blocName,
      streetName,
      houseName,
      onPressedEdit) {
    return Container(
      margin: EdgeInsets.only(right: 4.w, left: 4.w, bottom: 1.w),
      width: 100.w,
      // height: heigh,
      decoration: BoxDecoration(
        color: sharedPreferences!.getBool("darkMode") == false
            ? LightMode.searchField.withOpacity(.1)
            : DarkMode.whiteDarkColor,
        borderRadius: BorderRadius.circular(5.w),
        border: Border.all(color: LightMode.splash, width: 2),
      ),
      child: Column(
        children: [
          infoOrder(showInfo, heightPart1, numOfOrder, dateOfOrder,
              priceOfOrder, onPressDropInfo, iconInfo),
          Divider(
            color: LightMode.registerButtonBorder,
          ),
          addressOfOrder(
              showAddress,
              controllerArea,
              controllerBloc,
              controllerStreet,
              controllerHouseNum,
              onPressDropAddress,
              edit,
              iconAddress,
              onPressEdit,
              areaName,
              blocName,
              streetName,
              houseName,
              onPressedEdit)
        ],
      ),
    );
  }

  Widget infoOrder(showInfo, heightPart1, numOfOrder, dateOfOrder, priceOfOrder,
      onPressDropInfo, iconInfo) {
    return Container(
      // height: showInfo == true ? 16.h : 7.h,
      margin: EdgeInsets.only(top: 2.w, bottom: 2.w, right: 4.w, left: 4.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(Get.context!).orderDetail,
                style: GoogleFonts.tajawal(
                    fontSize: 5.w,
                    fontWeight: FontWeight.bold,
                    color: LightMode.registerButtonBorder),
              ),
              IconButton(
                  onPressed: onPressDropInfo,
                  icon: Icon(
                    iconInfo,
                    size: 6.w,
                  )),
            ],
          ),
          showInfo == true
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(Get.context!).orderNum,
                          style: GoogleFonts.tajawal(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w600,
                              color: LightMode.registerButtonBorder),
                        ),
                        Text(
                          "$numOfOrder",
                          style: GoogleFonts.tajawal(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w600,
                              color: LightMode.registerButtonBorder),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(Get.context!).orderDate,
                          style: GoogleFonts.tajawal(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w600,
                              color: LightMode.registerButtonBorder),
                        ),
                        Text(
                          dateOfOrder,
                          style: GoogleFonts.tajawal(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w600,
                              color: LightMode.registerButtonBorder),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(Get.context!).totalPrice,
                          style: GoogleFonts.tajawal(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w600,
                              color: LightMode.registerButtonBorder),
                        ),
                        Text(
                          "$priceOfOrder",
                          style: GoogleFonts.tajawal(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w600,
                              color: LightMode.registerButtonBorder),
                        ),
                      ],
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget addressOfOrder(
      showAddress,
      controllerArea,
      controllerBloc,
      controllerStreet,
      controllerHouseNum,
      onPressDropAddress,
      edit,
      icon,
      onPressEdit,
      areaName,
      blocName,
      governorateName,
      controllerGovernorate,
      onPressedEdit) {
    return Container(
      // height: showAddress == true ? 18.h : 7.h,
      margin: EdgeInsets.only(top: 2.w, left: 4.w, right: 4.w, bottom: 2.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(S.of(Get.context!).shippingAddress, FontWeight.bold, 5.w),
              IconButton(
                  onPressed: onPressDropAddress,
                  icon: Icon(
                    icon,
                    size: 6.w,
                  )),
            ],
          ),
          showAddress == true
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(
                            S.of(Get.context!).country, FontWeight.bold, 3.5.w),
                        text(S.of(Get.context!).area, FontWeight.bold, 3.5.w),
                      ],
                    ),
                    SizedBox(
                      height: 1.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 5.h,
                          width: 40.w,
                          child: textField(controllerArea, areaName, edit),
                        ),
                        SizedBox(
                          height: 5.h,
                          width: 40.w,
                          child: textField(controllerBloc, blocName, edit),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 40.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(S.of(Get.context!).governorate,
                                  FontWeight.bold, 3.5.w),
                              SizedBox(
                                height: 5.h,
                                width: 40.w,
                                child: textField(controllerGovernorate,
                                    governorateName, edit),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                            onPressed: onPressedEdit,
                            child: Text(
                              S.of(Get.context!).edit,
                              style: GoogleFonts.tajawal(
                                  fontSize: 3.5.w,
                                  fontWeight: FontWeight.w500,
                                  color: LightMode.splash),
                            ))
                      ],
                    )
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget textField(controller, text, edit) {
    return TextFormField(
      style: GoogleFonts.tajawal(
          color: LightMode.splash, fontSize: 3.w, fontWeight: FontWeight.w500),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 1.w),
        hintStyle: GoogleFonts.tajawal(
            color: LightMode.splash,
            fontSize: 3.w,
            fontWeight: FontWeight.w500),
        hintText: text,
        enabled: edit,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: LightMode.splash,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: LightMode.splash,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: LightMode.splash,
          ),
        ),
      ),
    );
  }

  Widget text(text, weight, size) {
    return Text(
      text,
      style: GoogleFonts.tajawal(
          fontSize: size,
          fontWeight: weight,
          color: LightMode.registerButtonBorder),
    );
  }

  Widget order(
      numOfOrder, OrderModel listOfItems, total, nearBy, delivery, totalPrice) {
    return Container(
      // height: 48.h,
      width: 100.w,
      margin: EdgeInsets.only(right: 4.w, left: 4.w, top: 2.w, bottom: 3.w),
      padding: EdgeInsets.only(bottom: 3.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.w)),
          border: Border.all(color: LightMode.splash, width: 2),
          color: sharedPreferences!.getBool("darkMode") == false
              ? LightMode.searchField.withOpacity(.1)
              : DarkMode.whiteDarkColor),
      child: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(right: 4.w, left: 4.w, top: 4.w, bottom: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(S.of(Get.context!).orderNum, FontWeight.w600, 4.w),
                text("$numOfOrder", FontWeight.w600, 4.w),
              ],
            ),
          ),
          Divider(
            color: LightMode.registerButtonBorder,
          ),
          SizedBox(
            height: 20.h,
            width: 100.w,
            child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(right: 4.w, left: 4.w, top: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 2.w),
                            width: 15.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.w),
                                border: Border.all(
                                    color: LightMode.splash, width: 2),
                                image: DecorationImage(
                                    image: listOfItems.orderItems![index].item!
                                                    .image ==
                                                "" ||
                                            listOfItems.orderItems![index].item!
                                                    .image ==
                                                null
                                        ? AssetImage(
                                            ImagesLink.noImage,
                                          )
                                        : CachedNetworkImageProvider(
                                            listOfItems.orderItems![index].item!
                                                .image!,
                                          ),
                                    fit: BoxFit.fill)),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5.h,
                                width: 60.w,
                                child: text(
                                    "${listOfItems.orderItems![index].item!.description}",
                                    FontWeight.bold,
                                    3.5.w),
                              ),
                              text(
                                  "${S.of(Get.context!).quantity}: ${listOfItems.orderItems![index].quantity}",
                                  FontWeight.w600,
                                  3.w),
                              text(
                                  "${listOfItems.orderItems![index].item!.price} دينار",
                                  FontWeight.w600,
                                  3.w),
                              Divider(
                                color: LightMode.registerButtonBorder,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: 5.w,
                    ),
                itemCount: listOfItems.orderItems!.length),
          ),
          Divider(
            color: LightMode.registerButtonBorder,
          ),
          Container(
            margin:
                EdgeInsets.only(right: 4.w, left: 4.w, top: 1.w, bottom: 1.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(S.of(Get.context!).subtotalPrice, FontWeight.w600, 4.w),
                text("$total", FontWeight.w600, 4.w),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(right: 4.w, left: 4.w, top: 1.w, bottom: 1.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(S.of(Get.context!).taxVAlue, FontWeight.w600, 4.w),
                text("$nearBy", FontWeight.w600, 4.w)
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(right: 4.w, left: 4.w, top: 1.w, bottom: 1.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(S.of(Get.context!).delivery, FontWeight.w600, 4.w),
                Text(
                  "$delivery",
                  style: GoogleFonts.tajawal(
                      fontSize: 4.w,
                      fontWeight: FontWeight.w600,
                      color: LightMode.btnGreen),
                ),
              ],
            ),
          ),
          Divider(
            color: LightMode.registerButtonBorder,
          ),
          Container(
            margin:
                EdgeInsets.only(right: 4.w, left: 4.w, top: 1.w, bottom: 1.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(S.of(Get.context!).totalPrice, FontWeight.bold, 4.w),
                text("$totalPrice", FontWeight.bold, 4.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rowTypeOfOrder(icon, color, title, weight) {
    return Container(
      margin: EdgeInsets.only(right: 4.w, top: 2.w, left: 4.w, bottom: 2.w),
      child: Row(
        children: [
          Icon(
            icon,
            size: 7.w,
            color: color,
          ),
          SizedBox(
            width: 2.w,
          ),
          text(title, weight, 4.w),
        ],
      ),
    );
  }
}
