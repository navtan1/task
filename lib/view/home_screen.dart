import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:task/api_services/user_api_services.dart';
import 'package:task/model/user_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.1),
                Colors.grey.shade200,
                Colors.grey.shade200,
                Colors.greenAccent.withOpacity(0.1)
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            SizedBox(
              height: 20,
            ),
            Tabs(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Popular Doctor",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Profile()
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 160,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: const [
                  Color(0xff4DC6FD),
                  Color(0xff00CCCB),
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: Center(
            child: Text(
              "Find Your Doctor",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            elevation: 10,
            shadowColor: Colors.black38,
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.close),
                hintText: "Search",
                filled: true,
                border: InputBorder.none,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Tabs extends StatelessWidget {
  Tabs({
    Key? key,
  }) : super(key: key);

  List<Map<String, dynamic>> tab = [
    {
      "title": "Dental",
      "image": "assets/tab1.png",
      "color1": Color(0xff2753F3),
      "color2": Color(0xff765AFC),
    },
    {
      "title": "Cardiologist",
      "image": "assets/tab2.png",
      "color1": Color(0xff0EBE7E),
      "color2": Color(0xff07D9AD),
    },
    {
      "title": "Eye Specialist",
      "image": "assets/tab3.png",
      "color1": Color(0xffFE7F44),
      "color2": Color(0xffFFCF68),
    },
    {
      "title": "Skin Specialist",
      "image": "assets/tab4.png",
      "color1": Color(0xffFF484C),
      "color2": Color(0xffFF6C60),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          tab.length,
          (index) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 65,
                  width: 75,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          tab[index]['color1'],
                          tab[index]['color2'],
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(tab[index]['image']),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                tab[index]['title'],
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: UserApiServices.getApiUser(),
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: snapshot.data!.users!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                  childAspectRatio: 0.8),
              itemBuilder: (context, index) {
                var info = snapshot.data!.users![index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: info.avatar == null
                            ? SizedBox()
                            : Image.network(
                                '${info.avatar}',
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${info.firstName}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${info.lastName}",
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 20,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.black12,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
