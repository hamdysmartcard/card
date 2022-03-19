extension NetworkHandler on Future<dynamic> {
  dynamic handleNetworkCall() {
    onError((error, stackTrace) => null);
  }
}
