// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import 'package:mas_app/data/model/service_model.dart';

class CategoriesController extends GetxController {
  List<Categories> categories = [];
  @override
  void onInit() {
    categories = Get.arguments["categories"];
  

    log("  list   ::  $categories");
    super.onInit();
  }
}
