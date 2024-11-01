import 'package:flutter/material.dart';
import 'package:tiktok_home_page_bloc/ui/home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationBarTiktok extends StatefulWidget {
  const NavigationBarTiktok({super.key});

  @override
  _NavigationBarTiktokState createState() => _NavigationBarTiktokState();
}

class _NavigationBarTiktokState extends State<NavigationBarTiktok> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    const Text(
      'index 1',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    const Text(
      'index 2',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    const Text(
      'index 3',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
    const Text(
      'inedx 4',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.073,
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                height: 20,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/shopping-bag.svg',
                height: 20,
                color: Colors.white,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(top: 5.5),
                child: SvgPicture.asset(
                  'assets/icons/add-video.svg',
                  height: 30,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/inbox.svg',
                height: 20,
                color: Colors.white,
              ),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/profile.svg',
                height: 20,
                color: Colors.white,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),
          unselectedLabelStyle: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
