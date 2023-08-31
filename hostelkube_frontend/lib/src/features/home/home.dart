import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/src/router/router.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HostelKube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Hostel Management System',
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF204E5E), Color(0xFF407F8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Features',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBox(),
            SizedBox(height: 30),
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
                GestureDetector(
                  onTap: () {
                    // Handle the button tap for Room Service
                    // Add your code here
                  },
                  child: ServiceContainer(
                    iconData: Icons.room_service,
                    imageAsset: 'assets/Image2.png',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the button tap for Restaurant Menu
                    // Add your code here
                  },
                  child: ServiceContainer(
                    iconData: Icons.restaurant_menu,
                    imageAsset: 'assets/Image3.png',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                  Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
                  },
                  child: ServiceContainer(
                    iconData: Icons.local_laundry_service,
                    imageAsset: 'assets/Image4.png',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle the button tap for Local Offer
                    // Add your code here
                  },
                  child: ServiceContainer(
                    iconData: Icons.local_offer,
                    imageAsset: 'assets/Image5.png',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the button tap for Local Parking
                    // Add your code here
                  },
                  child: ServiceContainer(
                    iconData: Icons.local_parking,
                    imageAsset: 'assets/Image7.png',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle the button tap for Pool
                    // Add your code here
                  },
                  child: ServiceContainer(
                    iconData: Icons.pool,
                    imageAsset: 'assets/Image10.png',
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
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                   Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
                },
              ),
              IconButton(
                icon: Icon(Icons.attach_money),
                onPressed: () {
                   Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
                },
              ),
              SizedBox(width: 40),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                   Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                   Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
                },
              ),
            ],
          ),
        ),
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
          colors: [Color(0xFF204E5E), Color(0xFF407F8C)],
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

class ServiceContainer extends StatelessWidget {
  final IconData iconData;
  final String imageAsset;

  ServiceContainer({required this.iconData, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF305F72), Color(0xFF609DAB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
            Icon(
              iconData,
              color: Colors.white,
              size: 36,
            ),
            SizedBox(height: 10),
            Image.asset(
              imageAsset,
              height: 40,
              width: 40,
            ),
          ],
        ),
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
        Image.asset('assets/pexels-cottonbro-studio-5137969.jpg'),
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