import 'package:demo/Modal/ImageModal.dart';
import 'package:demo/Modal/ResposeModal.dart';
import 'package:demo/repository/mainRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProvider extends ChangeNotifier {
  bool imageIsLoaded = false;
  bool boolLoadMore = false;
  ImageModal imageModal = ImageModal();
  int offset = 0;

  ResponseModal response = ResponseModal();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<Images> data = [];

  getImage() async {
    imageIsLoaded = false;
    notifyListeners();
    Map<String, dynamic> body = {
      "user_id": "108",
      "offset": offset.toString(),
      "type": "popular"
    };

    imageModal = await RepoClass().getImageRepo(body);
    if (imageModal.status == "success" && imageModal.images!.isNotEmpty) {
      for (var element in imageModal.images!) {
        data.add(element);
      }
      print("lenth data ${data.length}");
      imageIsLoaded = true;
      offset = offset+1;
      print('offset  $offset');
    }
    notifyListeners();
  }

  submitFormApi(imagePath, context) async {
    Map<String, dynamic> body = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text
    };
    response = await RepoClass().submitFormRepo(body, imagePath);
    if (response.status == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.message}')),
      );

      Navigator.pop(context);
    }
  }

  setLoadMore(bool status){
    boolLoadMore = status;
    notifyListeners();
  }


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

final mainProvider = ChangeNotifierProvider((ref) {
  MainProvider ob = MainProvider();
  ob.getImage();
  return ob;
});
