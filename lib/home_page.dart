import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_special_days/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentNavIndex =0;


  @override
  Widget build(BuildContext context) {
    _showPopupMenu() {
      showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
        items: [
          PopupMenuItem<String>(child: const Text('menu option 1'), value: '1'),
          PopupMenuItem<String>(child: const Text('menu option 2'), value: '2'),
          PopupMenuItem<String>(child: const Text('menu option 3'), value: '3'),
        ],
        elevation: 8.0,
      ).then<void>((String itemSelected) {
        if (itemSelected == null) return;
        if (itemSelected == "1") {
          //code here
        } else if (itemSelected == "2") {
          //code here
        } else {
          //code here
        }
      });
    }

    Widget titleWidget = new Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 50, bottom: 10, right: 25),
      height: 100,
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          color: AppColors.appColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "My Special Days",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'BerkshireSwash'),
          ),
          GestureDetector(
            onTap: _showPopupMenu,
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      bottomNavigationBar: _getNavigationBar(context),
      body: Container(
        child: ListView(
          children: [
            titleWidget,
          ],
        ),
      ),
    );
  }

  _getNavigationBar(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: ClipPath(
            clipper: NavBarClipper(),
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.appColor_l4,
                    AppColors.appColor_l3,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          left: 10,
          bottom: 30,
          top: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.calendar_today_outlined,0),
              _buildNavItem(Icons.plus_one,1),
              _buildNavItem(Icons.access_alarm,2),
            ],
          ),
        )
      ],
    );
  }

  _buildNavItem(IconData icon,int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          currentNavIndex = index;
        });
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.appColor_l3,
        child: CircleAvatar(
          radius: 26,
          backgroundColor: currentNavIndex==index ? Colors.white.withOpacity(0.9): Colors.transparent,
          child: Icon(icon,color: currentNavIndex==index ? Colors.black:Colors.white),
        ),
      ),
    );
  }
}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    var sizeWith = size.width;
    var sizeHeight = size.height;
    double slope = 60.0;
    double bottomPadding = 20.0;
    path.lineTo(sizeWith / 3 - slope, 0);
    path.cubicTo(sizeWith / 3, 0, sizeWith / 3, sizeHeight - bottomPadding,
        sizeWith / 3 + slope, sizeHeight - bottomPadding);
    path.lineTo(2 * sizeWith / 3 - slope, sizeHeight - bottomPadding);
    path.cubicTo(2 * sizeWith / 3, sizeHeight - bottomPadding, 2 * sizeWith / 3,
        0, (2 * sizeWith / 3) + slope, 0);
    path.lineTo(sizeWith, 0);
    path.lineTo(sizeWith, sizeHeight);
    path.lineTo(0, sizeHeight);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
