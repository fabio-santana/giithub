import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../lib/data/http/http.dart';
import '../../../lib/data/usecases/usecases.dart';

import '../../../lib/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  //sut = system under test
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test('Deve chamar HttpClient com valores corretos', () async {
    final params = AuthenticationParams(id: faker.internet.toString());
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'id': params.id},
    ));
  });
}
