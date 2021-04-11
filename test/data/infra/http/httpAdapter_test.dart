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
    await client.post(Uri.http('', url));
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('POST=>', () {
    test('Deve chamar POST com valores corretos', () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();

      await sut.request(url: url, method: 'post');

      verify(client.post(Uri.http('', url)));
    });
  });
}
