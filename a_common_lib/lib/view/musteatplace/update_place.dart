import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/musteatplace.dart';
import '../../vm/musteatplace_db_handler.dart';

/*
 
  Description : Update MustEatPlace database
  Date        : 2024.04.07 Sun
  Author      : Forrest DongGeun Park. (PDG)
  Updates     : 
    2024.04.07 Sun
      - update test (without image data) 
      - image 수정 추가 
  Detail      : 
    

*/
class UpdateMustEatPlace extends StatefulWidget {
  const UpdateMustEatPlace({super.key});

  @override
  State<UpdateMustEatPlace> createState() => _UpdateMustEatPlaceState();
}

class _UpdateMustEatPlaceState extends State<UpdateMustEatPlace> {
  late DatabaseHandler handler;
  late int? seq;
  late String name;
  late String phone;
  late double lat;
  late double lng;
  late String? estimate;
  late Uint8List image;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController estimateController;

  ImagePicker picker = ImagePicker();
  XFile? imageFile;

  MustEatPlaces _mustEatPlaces = Get.arguments[0];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    print("value0 : ${_mustEatPlaces.seq}");
    seq = _mustEatPlaces.seq;
    name = _mustEatPlaces.name;
    phone = _mustEatPlaces.phone;
    lat = _mustEatPlaces.lat;
    lng = _mustEatPlaces.lng;
    estimate = _mustEatPlaces.estimate;
    image = _mustEatPlaces.image;

    nameController = TextEditingController(text: name);
    phoneController = TextEditingController(text: phone);
    latController = TextEditingController(text: lat.toString());
    lngController = TextEditingController(text: lng.toString());
    estimateController = TextEditingController(text: estimate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '맛집 수정',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Positioned(
              top: 3,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.25,
                child: imageFile == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.memory(image))
                    : Image.file(File(imageFile!.path)),
              ),
            ),

            // 사진 정보 입력
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                onPressed: () {
                  //사진 받아오는 함수 호출
                  getImageFileFromGallery(ImageSource.gallery);
                },
                child: const Text(
                  '사진수정하기',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                  ),
                )),
            SizedBox(
              height: 20,
            ),

            // 위치 정보 입력
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Location :",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: TextField(
                      controller: latController,
                      decoration: const InputDecoration(
                          labelText: 'latitiude', 
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.normal
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: TextField(
                      controller: lngController,
                      decoration: const InputDecoration(
                          labelText: 'longitude', 
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.normal
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),

            // 이름 입력
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Place :     ",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                           labelText: 'Enter the spot name',
                           labelStyle: TextStyle(
                            fontStyle: FontStyle.normal
                          )
                           ),
                    ),
                  ),
                ],
              ),
            ),
            // 전화번호 입력
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Tel :          ",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), 
                          labelText: 'Enter Tell number',
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.normal
                          )
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // 평가 입력
            Row(
              children: [
                const Text(
                  "  평가 :   ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    //expands: true,
                    maxLength: 200,
                    controller: estimateController,
                    decoration: const InputDecoration(
                        labelText: 'Enter your review', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),

            ElevatedButton(
                onPressed: () async {
                  // seq = seq +1;
                  name = nameController.text.toString();
                  lat = double.parse(latController.text.trim().toString());
                  lng = double.parse(lngController.text.trim().toString());
                  phone = phoneController.text.toString();
                  estimate = estimateController.text.toString();

                  MustEatPlaces musteatplace = MustEatPlaces(
                    seq: seq,
                    name: name,
                    lat: lat,
                    lng: lng,
                    phone: phone,
                    estimate: estimate,
                    image: await imageFile!.readAsBytes(),
                  );

                  var returnValue =
                      await handler.updateMustEatPlaces(musteatplace);
                  //print("입력결과 : $returnValue");
                  _showDialog();
                  // if(returnValue != 1){
                  //   //Snack bar
                  // }else{
                  //   _showDialog();
                  // }
                },
                child: const Text('수정'))
          ],
        ),
      ),
    );
  }

  //functions
  _showDialog() {
    Get.defaultDialog(
        title: '수정결과',
        middleText: "수정이 완료 되었습니다.",
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('OK'))
        ]);
  }

  getImageFileFromGallery(imageSource_gallery) async {
    final XFile? pickedImageFile =
        await picker.pickImage(source: imageSource_gallery);
    if (pickedImageFile != null) {
      imageFile = XFile(pickedImageFile.path);
    } else {
      imageFile = null;
    }
    setState(() {});
  }
} //End
