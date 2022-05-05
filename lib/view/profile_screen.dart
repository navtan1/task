import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/firebase_service/firebase_service.dart';
import 'package:task/view/sign_up_screen.dart';

import '../constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final getStorage = GetStorage();

  File? _image;

  final picker = ImagePicker();

  Future pickedImage() async {
    var imagePicked = await picker.getImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      setState(() {
        _image = File(imagePicked.path);
      });
    }
  }

  Future<String?> uploadFile(File file, String filename) async {
    print("File path:${file.path}");
    try {
      var response = await storage.ref("user_image/$filename").putFile(file);
      return response.storage.ref("user_image/$filename").getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  Future allUserData() async {
    String? imageUrl =
        await uploadFile(_image!, "${kFirebaseAuth.currentUser!.email}");
    await collectionReference.doc(kFirebaseAuth.currentUser!.uid).update({
      "first name": _fName.text,
      "Last name": _lName.text,
      "Email": _email.text,
      "Mobile": _mobile.text,
      "Image": imageUrl,
      "city name": selectCity.toString(),
      "Gender": circle == true ? 'male' : 'female',
      "Hobbies": box == true && box1 == true
          ? "Both singing and Dancing"
          : box == true
              ? "only Singing"
              : box1 == true
                  ? "only Dancing"
                  : "",
    }).catchError((e) {
      print("ERROR==========$e");
    });
  }

  String? userImage;

  Future getUserData() async {
    final user =
        await collectionReference.doc(kFirebaseAuth.currentUser!.uid).get();
    Map<String, dynamic>? getUserData = user.data();
    _email.text = getUserData!['Email'];
    _fName.text = getUserData['first name'];
    _lName.text = getUserData['Last name'];
    _mobile.text = getUserData['Mobile'];
    setState(() {
      userImage = getUserData['Image'];
    });
    selectCity = getUserData['city name'];
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  final TextEditingController _fName = TextEditingController();

  final TextEditingController _lName = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _mobile = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool box = false;

  bool box1 = false;

  bool pass = true;

  bool circle = false;

  List<String> city = [
    'city',
    'Surat',
    'Ahmedabad',
    'Jamnager',
    'Vadodara',
  ];

  dynamic selectCity = 'city';

  bool read = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.1),
                  Colors.grey.shade200,
                  Colors.grey.shade200,
                  Colors.grey.shade200,
                  Colors.greenAccent.withOpacity(0.1)
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () async {
                            await getStorage.remove("Email");
                            await FirebaseService.logOut().then(
                              (value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "LogOut",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Card(
                          margin: EdgeInsets.all(15),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: userImage == null
                                  ? Center(child: CircularProgressIndicator())
                                  : _image == null
                                      ? Image.network(
                                          userImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: GestureDetector(
                                onTap: () {
                                  pickedImage();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(Icons.camera_alt),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Set up your profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Update your profile to connect your doctor with",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 12.5),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "better impression",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 12.5),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "Registration",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: read,
                            controller: _fName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required";
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText: "First Name",
                              hintStyle: TextStyle(color: Colors.black45),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: read,
                            controller: _lName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required";
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Last Name",
                              hintStyle: TextStyle(color: Colors.black45),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: read,
                      controller: _email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: read,
                      controller: _mobile,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else if (value.length < 10) {
                          return "atlest 10 digit";
                        }
                      },
                      maxLength: 10,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        filled: true,
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(color: Colors.black45),
                        border: InputBorder.none,
                        counter: Offstage(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Gender",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  circle = true;
                                });
                              },
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: circle == false ? 0 : 3.5,
                                        color: circle == false
                                            ? Colors.grey
                                            : Colors.black),
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  circle = true;
                                });
                              },
                              child: Text(
                                "Male",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  circle = false;
                                });
                              },
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: circle == true ? 0 : 3.5,
                                        color: circle == true
                                            ? Colors.grey
                                            : Colors.black),
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  circle = false;
                                });
                              },
                              child: Text(
                                "Female",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: selectCity,
                              onChanged: (value) {
                                setState(
                                  () {
                                    selectCity = value;
                                  },
                                );
                              },
                              items: city
                                  .map((e) => DropdownMenuItem(
                                        child: Text(
                                          e,
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        value: e,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Hobbies",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  box = !box;
                                });
                              },
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(color: Colors.grey),
                                child: Center(
                                    child: box == false
                                        ? SizedBox()
                                        : Icon(
                                            Icons.done,
                                            size: 15,
                                          )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  box = !box;
                                });
                              },
                              child: Text(
                                "Singing",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  box1 = !box1;
                                });
                              },
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: BoxDecoration(color: Colors.grey),
                                child: Center(
                                  child: box1 == false
                                      ? SizedBox()
                                      : Icon(
                                          Icons.done,
                                          size: 15,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  box1 = !box1;
                                });
                              },
                              child: Text(
                                "Dancing",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              read = !read;
                            });
                            // bool status = await FirebaseService.signUp(
                            //     email: _email.text, password: _passWord.text);

                            // if (status == true) {
                            if (read == false) {
                              print("============>>>>>>>>$_lName");
                              await allUserData();
                            }
                            //     .then(
                            //   (value) => Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => BottomBarScreen(),
                            //     ),
                            //   ),
                            // );
                            // }
                          }
                        },
                        child: Text(
                          read == true ? "edit" : "update",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
