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
  AuthenticationParams params;

  Map mockValidData() {
    final login = faker.internet.userName();
    final avatar = faker.image.image();
    final location = faker.internet.toString();
    final bio = faker.internet.toString();
    final name = faker.person.name();
    final email = faker.internet.email();

    return {
      'login': login,
      'avatar': avatar,
      'location': location,
      'bio': bio,
      'name': name,
      'email': email,
    };
  }

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(id: faker.internet.toString());
    mockHttpData(mockValidData());
  });
  test('Deve chamar HttpClient com valores corretos', () async {
    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'id': params.id},
    ));
  });

  test('Deve retornar UnexpectedError se o HttpClient retornar 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar UnexpectedError se o HttpClient retornar 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar UnexpectedError se o HttpClient retornar 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar InvalidCredentialsError se o HttpClient retornar 401', () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Deve retornar o Account se o HttpClient retornar 200', () async {
    final validData = mockValidData();

    mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.login, validData['login']);
    expect(account.avatar, validData['avatar']);
    expect(account.location, validData['location']);
    expect(account.bio, validData['bio']);
    expect(account.name, validData['name']);
    expect(account.email, validData['email']);
  });

  test('Deve retornar UnexpectedError o HttpClient retornar 200 com dado inválido', () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
