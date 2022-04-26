import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/controller/bottom_bar.dart';
import 'package:task/view/home_screen.dart';

class BottomBarScreen extends StatelessWidget {
  BottomBarScreen({Key? key}) : super(key: key);

  BottomBar bottomBar = Get.put(BottomBar());

  List<dynamic> icons = [
    Icons.home,
    Icons.favorite,
    Icons.book,
    Icons.doorbell,
    Icons.person,
  ];

  List<dynamic> screen = [
    HomeScreen(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black12,
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                icons.length,
                (index) => GestureDetector(
                  onTap: () {
                    bottomBar.changeIndex(index);
                  },
                  child: bottomBar.bottomIndex == index
                      ? CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(
                            icons[index],
                            size: 25,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          icons[index],
                          size: 25,
                          color: Colors.black45,
                        ),
                ),
              ),
            ),
          )),
      body: Obx(() => screen[bottomBar.bottomIndex.value]),
    );
  }
}
