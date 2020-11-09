String extractUrl(String path) {
  final List<String> splitted = path.split("/");
  final int indexOf = splitted.indexOf("schools");
  return splitted.sublist(indexOf).join("/");
}
