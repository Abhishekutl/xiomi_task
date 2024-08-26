import 'package:demo/Modal/ImageModal.dart';
import 'package:demo/Modal/ResposeModal.dart';
import 'package:demo/Services/networkHelper.dart';

class RepoClass {
  Future<ImageModal> getImageRepo(body) async {
    var s = await ApiProvider()
        .fromApi("http://dev3.xicomtechnologies.com/xttest/getdata.php", body);
    return ImageModal.fromJson(s);
  }

  Future<ResponseModal> submitFormRepo(body, imagePath) async {
    var s = await ApiProvider().uploadFormImageApi(
        "http://dev3.xicomtechnologies.com/xttest/savedata.php",
        imagePath,
        body);
    return ResponseModal.fromJson(s);
  }
}
