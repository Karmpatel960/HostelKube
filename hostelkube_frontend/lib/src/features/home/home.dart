import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'transactions/transactions.dart';
import 'profile/profile.dart';
import 'foodmenu/foodmenu.dart';


class HomeScreen extends StatelessWidget {
  final ThemeMode themeMode;

  const HomeScreen({Key? key, this.themeMode = ThemeMode.light}) : super(key: key);

  static void setThemeMode(ThemeMode themeMode) {
    runApp(HomeScreen(themeMode: themeMode));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Prince Hostel',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0; // Define _currentIndex as an instance variable

  final List<Widget> _pages = [
    HomePageContent(),
    ReceiptScreen(),
    FoodmenuScreen(),
    ProfileScreen(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Prince Hostel',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              showNotificationDialog(context);
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: IndexedStack(
  index: _currentIndex,
  children: _pages,
),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 255, 1.0),
                    Color.fromRGBO(0, 0, 255, 1.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/lmage11.png', // Replace with the path to your logo image
                    height: 80, // Adjust the height as needed
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Features',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Fee Payment'),
              onTap: () {
                Navigator.pop(context);
                // Add code to handle fee payment here
              },
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: Text('Light Bill Payment'),
              onTap: () {
                Navigator.pop(context);
                // Add code to handle light bill payment here
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Bill Receipt'),
              onTap: () {
                Navigator.pop(context);
                // Add code to handle bill receipt here
              },
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text('Any Issue'),
              onTap: () {
                Navigator.pop(context);
                // Add code to handle any issue here
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                // Add code to navigate to the "About Us" screen here
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6), // Icon for theme change
              title: Text('Dark Theme'), // Theme change option
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  // Toggle the theme when the switch is changed
                  ThemeMode newThemeMode = value ? ThemeMode.dark : ThemeMode.light;
                  Navigator.pop(context);
                  HomeScreen.setThemeMode(newThemeMode);
                },
              ),
            ),
          ],
        ),
      ),
    
    bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Theme.of(context).bottomAppBarColor,
    selectedItemColor: Color.fromARGB(255, 51, 163, 255),
    unselectedItemColor: Theme.of(context).brightness == Brightness.dark
  ? Colors.white // Set to white when the theme is dark (black)
  : Colors.black, // Set to black when the theme is light (white)
    selectedFontSize: 12,
    unselectedFontSize: 9,

    currentIndex: _currentIndex,
    onTap: (index) {
      setState(() {
        _currentIndex = index;
      });
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long),
        label: 'Receipt',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.food_bank),
        label: 'Food',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  ),
    );
  }

  void showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification Reminder'),
          content: Text('You have pending tasks.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class TopBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromRGBO(0, 133, 255, 1.0), Color.fromRGBO(0, 133, 255, 1.0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12.0,
            spreadRadius: 3.0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Room Number: 101',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Check-out Date: August 25, 2023',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Text(
              'Hello, User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MyImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        Image.asset('assets/Rectangle5.png'),
        Image.asset('assets/pexels-pixabay-50987.jpg'),
        Image.asset('assets/pexels-spencer-davis-4393021.jpg'),
      ],
      options: CarouselOptions(
        height: 220,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
    );
  }
}


class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBox(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Daily Services',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button tap for Room Service
                  },
                  child: ServiceContainer(
                     imageAsset: 'assets/Image1.png',
                     serviceName: 'Fee Payment',
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button tap for Restaurant Menu
                  },
                  child: ServiceContainer(
                     imageAsset: 'assets/Image2.png',
  serviceName: 'Pay Light Bill',
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button tap for Local Laundry Service
                  },
                  child: ServiceContainer(
                     imageAsset: 'assets/Image3.png',
  serviceName: 'Daily Menu',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button tap for Local Offer
                  },
                  child: ServiceContainer(
                     imageAsset: 'assets/Image5.png',
                     serviceName: 'Print Receipt',
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button tap for Local Parking
                  },
                  child: ServiceContainer(
                     imageAsset: 'assets/Image6.png',
  serviceName: 'Print Light Bill',
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Handle the button tap for Pool
                  },
                  child: ServiceContainer(
                     imageAsset: 'assets/Image4.png',
  serviceName: 'Add Issues',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Hostel Services',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 220,
            decoration: BoxDecoration(
              color: Color(0xFF0085FF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12.0,
                  spreadRadius: 3.0,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: MyImageCarousel(),
          ),
        ],
      ),
    );
  }
}

class ServiceContainer extends StatelessWidget {
  final String imageAsset;
  final IconData? iconData;
  final String serviceName;

  ServiceContainer({
    required this.imageAsset,
    this.iconData,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDarkTheme ? Colors.white : Colors.black;
  final boxColor = isDarkTheme ? Colors.black : Colors.white;

    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(71, 221, 254, 1.0),
            Color.fromRGBO(71, 221, 254, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
        color: borderColor, // Border color based on the theme
        width: 2, // Border width
      ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageAsset,
              height: 30, // Adjust the size as needed
              width: 30, // Adjust the size as needed
            ),
            SizedBox(height: 5),
            Text(
              serviceName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
