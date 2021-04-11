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

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(id: faker.internet.toString());
  });
  test('Deve chamar HttpClient com valores corretos', () async {
    final login = faker.internet.userName();
    final avatar = faker.image.image();
    final location = faker.internet.toString();
    final bio = faker.internet.toString();
    final name = faker.person.name();
    final email = faker.internet.email();

    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => {
          'login': login,
          'avatar': avatar,
          'location': location,
          'bio': bio,
          'name': name,
          'email': email,
        });

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

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar UnexpectedError se o HttpClient retornar 404', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar UnexpectedError se o HttpClient retornar 500', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve retornar InvalidCredentialsError se o HttpClient retornar 401', () async {
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Deve retornar o Account se o HttpClient retornar 200', () async {
    final login = faker.internet.userName();
    final avatar = faker.image.image();
    final location = faker.internet.toString();
    final bio = faker.internet.toString();
    final name = faker.person.name();
    final email = faker.internet.email();

    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => {
          'login': login,
          'avatar': avatar,
          'location': location,
          'bio': bio,
          'name': name,
          'email': email,
        });

    final account = await sut.auth(params);

    expect(account.login, login);
    expect(account.avatar, avatar);
    expect(account.location, location);
    expect(account.bio, bio);
    expect(account.name, name);
    expect(account.email, email);

    // expect([
    //   account.login,
    //   account.avatar,
    //   account.location,
    //   account.bio,
    //   account.name,
    //   account.email,
    // ], [
    //   login,
    //   avatar,
    //   location,
    //   bio,
    //   name,
    //   email,
    // ]);
  });
}
