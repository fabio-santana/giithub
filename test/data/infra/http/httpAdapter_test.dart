import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
    };
    final jsonBody = (body != null) ? jsonEncode(body) : null;
    final response = await client.post(Uri.http('', url), headers: headers, body: jsonBody);

    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}

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
  group('POST', () {
    test('Deve chamar POST com valores corretos', () async {
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

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
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      await sut.request(url: url, method: 'post');

      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('Deve retornar DATA se o POST retornar 200', () async {
      when(client.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Deve retornar null se o POST retornar 200 sem DATA', () async {
      when(client.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
  });
}
