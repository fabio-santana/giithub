import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/data/http/http.dart';

import '../../../../lib/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test('Deve chamar ServerError se um verbo inválido for utilizado', () async {
      final future = sut.request(url: url, method: 'invalid_verb', body: {'any_key': 'any_value'});

      expect(future, throwsA(HttpError.serverError));
    });
  });
  group('POST', () {
    PostExpectation mockRequest() => when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() => mockRequest().thenThrow(Exception());

    setUp(() {
      mockResponse(200);
    });

    test('Deve chamar POST com valores corretos', () async {
      mockResponse(200);

      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(
        Uri.http('', url),
        headers: {
          'content-type': 'application/json',
        },
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Deve chamar POST com valores corretos sem o body', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Deve retornar DATA se o POST retornar 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Deve retornar null se o POST retornar 200 sem DATA', () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Deve retornar null se o POST retornar 204', () async {
      mockResponse(204, body: '');
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Deve retornar null se o POST retornar 204 com DATA', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });

    test('Deve retornar BadRequestError se o POST retornar 400 com body', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Deve retornar BadRequestError se o POST retornar 400 sem body', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Deve retornar UnauthorizedError se o POST retornar 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Deve retornar ForbiddenError se o POST retornar 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Deve retornar NotFoundError se o POST retornar 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Deve retornar ServerError se o POST retornar 500', () async {
      mockResponse(500);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Deve retornar ServerError se o POST tiver uma exceção', () async {
      mockError();
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
