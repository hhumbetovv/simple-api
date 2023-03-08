String checker(List<String> parameters, data) {
  String response = 'success';
  if (data.isEmpty) {
    response = 'No data found';
  }
  for (var parameter in parameters) {
    if (data[parameter] == null) {
      response = 'Missing $parameter';
    }
  }

  return response;
}
