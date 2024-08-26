
abstract class NetworkBaseClass {

  Future<dynamic> fromApi(String url,Map<String,dynamic> body);

  Future<dynamic> uploadFormImageApi(String url, String imageUrl, Map<String, dynamic> body);


}