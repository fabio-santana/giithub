import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../search/search.dart';

class SearchController extends GetxController {
  GetStorage box = GetStorage();

  SearchRepository userRepository;
  SearchModel user;

  RxBool apiBusy = false.obs;

  final userLov = TextEditingController().obs;

  RxList listaUsers = [].obs;

  SearchController() {
    userRepository = SearchRepository();
  }

  Future<List> getUsers(String token) async {
    user = await userRepository.users(token);
    apiBusy.value = true;
    await Future.delayed(new Duration(milliseconds: 1500)); // para vizualisar o CircularProgressIndicator
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
    } else {
      apiBusy.value = false;

      if (user.totalCount > 0) {
        // listausers.addAll(user.items);
        listaUsers.assignAll(user.items);
      } else {
        Get.snackbar(
          'Atenção',
          'Usuário não localizado.',
          icon: Icon(Icons.report_problem),
          shouldIconPulse: true,
          barBlur: 50,
          isDismissible: false,
          margin: EdgeInsets.all(8),
          backgroundColor: Colors.blue, // redAccent,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
        apiBusy.value = false;
      }
    }
    return user.items;
  }

  // void makeFavorite(int index, bool isFavorite) {
  //   // user.items[index].isFavorite = isFavorite.value;
  //   listaUsers[index].isFavorite = isFavorite;
  //   listaUsers[index].refresh();
  // }
}
