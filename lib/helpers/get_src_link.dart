String? getSrc(String html) {
  int firstIndex = html.indexOf("src=\"");
  print("----- firstIndex " + firstIndex.toString());
  if (firstIndex != -1) {
    int lastIndex = html.indexOf("\"", firstIndex + 6);
    print("lastIndex " + lastIndex.toString());
    String output = html.substring(firstIndex + 5, lastIndex);
    print('Src video link ' + output);
    return output;
  } else {
    return null;
  }
}
