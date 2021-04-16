import 'package:dio/dio.dart';
import '../user/user.dart';

class UserRepository {
  Future<UserModel> user(
    String _url,
  ) async {
    print('Buscando informações dos clientes...');

    Response response = await Dio().get(
      _url,
    );

    if (response.statusCode == 200) {
      print('Usuário localizado com sucesso!');
      return UserModel.fromJson(response.data);
    } else {
      print('Usuário não localizado!');
      return null;
    }
  }
}
