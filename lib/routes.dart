import 'package:get/route_manager.dart';

import './search/search.dart';

class Routes {
  static const SEARCH = '/';
  static const APIURL = 'https://api.github.com/search/users';
}

class Pages {
  static List<GetPage> pages = [
    GetPage(name: Routes.SEARCH, page: () => SearchView(), binding: SearchBindings()),
  ];
}
