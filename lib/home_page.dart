import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_special_days/colors.dart';
import 'package:my_special_days/tabbars/add_special_day.dart';
import 'package:my_special_days/tabbars/calendar.dart';
import 'package:my_special_days/tabbars/show_special_days.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentNavIndex = 1;
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
  }

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
      ).then<void>(
        (String itemSelected) {
          if (itemSelected == null) return;
          if (itemSelected == "1") {
            //code here
          } else if (itemSelected == "2") {
            //code here
          } else {
            //code here
          }
        },
      );
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
                color: Colors.white, fontSize: 30, fontFamily: 'BitterRegular'),
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
        child: Column(
          children: [
            titleWidget,
            Expanded(
              child: PageView(
                controller: _pageController,
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    currentNavIndex = index;
                  });
                },
                children: [
                  Calendar(),
                  ShowSpecialDays(),
                  AddSpecialDay(),
                ],
              ),
            ),
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
              _buildNavItem(SvgPicture.asset("assets/icons/calendarblack.svg"),
                  SvgPicture.asset("assets/icons/calendarwhite.svg"), 0),
              _buildNavItem(SvgPicture.asset("assets/icons/listblack.svg"),
                  SvgPicture.asset("assets/icons/listwhite.svg"), 1),
              _buildNavItem(SvgPicture.asset("assets/icons/addblack.svg"),
                  SvgPicture.asset("assets/icons/add.svg"), 2),
            ],
          ),
        )
      ],
    );
  }

  _buildNavItem(Widget iconSelected, Widget iconNotSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
          currentNavIndex = index;
        });
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.appColor_l3,
        child: CircleAvatar(
          radius: 26,
          backgroundColor: currentNavIndex == index
              ? Colors.white.withOpacity(0.9)
              : Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            child: currentNavIndex == index ? iconSelected : iconNotSelected,
          ),
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
