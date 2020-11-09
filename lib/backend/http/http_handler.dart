mixin HttpHandlerMixin {
  bool handleHttpCode(int code) {
    switch (code) {
      case 200:
        return true;
      case 404:
        throw new Exception404();
      case 401:
      case 403:
        throw new Exception401403();
      case 500:
      default:
        throw new Exception500();
    }
  }
}

class Exception404 implements Exception {}

class Exception401403 implements Exception {}

class Exception500 implements Exception {}
