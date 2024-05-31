import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.orange[50],
      onTap: (index) {
        if(index != selectedIndex){
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/favorite');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/logout');
              break;
          }
        }
      },
      showSelectedLabels: true,
      showUnselectedLabels: false,
    );
  }
}
