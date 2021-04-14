import 'package:dio/dio.dart';
import '../search/search.dart';
import '../routes.dart';

class SearchRepository {
  Future<SearchModel> users(
    String _id,
  ) async {
    var url = Routes.APIURL;

    print('Buscando informações dos usuários...');

    Response response = await Dio().get(
      url,
      queryParameters: {
        "q": _id,
        "per_page": "100",
      },
    );

    if (response.statusCode == 200) {
      print('Usuário localizado com sucesso!');

      // return response.data;
      print(response.data);
      return SearchModel.fromJson(response.data);
    } else {
      print('Usuário não localizado!');
      return null;
    }
  }
}
