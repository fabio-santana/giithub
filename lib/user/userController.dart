import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../user/user.dart';

class UserController extends GetxController {
  GetStorage box = GetStorage();

  // var token = GetStorage().read('token');
  // var login = GetStorage().read('login');
  // var senha = GetStorage().read('senha');

  UserRepository userRepository;
  UserModel user;

  RxBool apiBusy = false.obs;

  RxList listaUser = [].obs;

  UserController() {
    userRepository = UserRepository();
  }

  Future<UserModel> getUser(String url) async {
    user = await userRepository.user(url);
    apiBusy.value = true;
    // await Future.delayed(new Duration(milliseconds: 1500));
    if (user == null) {
      Get.snackbar(
        'Erro',
        'Não foi possível estabelecer conexão com a API, verifique.',
        icon: Icon(Icons.report),
        shouldIconPulse: true,
        barBlur: 50,
        isDismissible: false,
        margin: EdgeInsets.all(8),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
      );
      apiBusy.value = false;
    }
    return user;
  }
}
