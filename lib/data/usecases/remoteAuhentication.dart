import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    this.httpClient,
    this.url,
  });

  Future<void> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    await httpClient.request(
      url: url,
      method: 'post',
      body: body,
    );
  }
}

class RemoteAuthenticationParams {
  final String id;

  RemoteAuthenticationParams({
    this.id,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) => RemoteAuthenticationParams(id: params.id);

  Map toJson() => {'id': id};
}
