import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    @required String url,
    @required String method,
    // Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
    };
    await client.post(Uri.http('', url), headers: headers);
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
      await sut.request(url: url, method: 'post');

      verify(client.post(
        Uri.http('', url),
        headers: {
          'content-type': 'application/json',
        },
      ));
    });
  });
}
