import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/constant.dart';

import '../firebase_service/firebase_service.dart';
import 'bottom_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final getstorage = GetStorage();
  bool ok = true;
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

    collectionReference.doc(kFirebaseAuth.currentUser!.uid).set({
      "first name": _fName.text,
      "Last name": _lName.text,
      "Email": _email.text,
      "Mobile": _mobile.text,
      "Image": imageUrl,
      "Password": _passWord.text,
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

  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _passWord = TextEditingController();

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
                    SizedBox(
                      height: 10,
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
                              child: _image == null
                                  ? Icon(Icons.person)
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
                    TextFormField(
                      obscureText: pass,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else if (value.length < 6) {
                          return "atlest 6 charater";
                        }
                      },
                      controller: _passWord,
                      decoration: InputDecoration(
                        // contentPadding:
                        //     EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.black45),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              pass = !pass;
                            });
                          },
                          child: pass == true
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.remove_red_eye),
                        ),
                        counter: Offstage(),
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
                              ok = false;
                            });
                            if (ok == false) {
                              bool status = await FirebaseService.signUp(
                                  password: _passWord.text, email: _email.text);
                              if (status == true) {
                                await getstorage.write("Email", _email.text);
                                await allUserData().then(
                                  (value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BottomBarScreen(),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: ok == true
                            ? Text(
                                "Submit",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                ),
                              )
                            : CircularProgressIndicator(),
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
