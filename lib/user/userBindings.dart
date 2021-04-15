import 'package:get/get.dart';

import 'user.dart';

class UserBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(
      () => UserController(),
    );
  }
}
