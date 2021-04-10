import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/domain/usecases/usecases.dart';

import '../../../lib/data/http/http.dart';
import '../../../lib/data/usecases/usecases.dart';

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

  test('Deve retornar UnexpectedError se o HttpClient retornar 400', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(id: faker.internet.toString());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
