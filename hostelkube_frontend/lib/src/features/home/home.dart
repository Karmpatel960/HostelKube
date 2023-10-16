import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transactions/transactions.dart';
import 'profile/profile.dart';
import 'foodmenu/foodmenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostelkube_frontend/src/features/features.dart';


class HomeScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final String userId; // Add userId here

  const HomeScreen({Key? key, this.themeMode = ThemeMode.light, required this.userId}) : super(key: key);

  // Remove the static method setThemeMode
  //  static void setThemeMode(ThemeMode themeMode) {
  //   runApp();
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prince Hostel',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: HomePage(userId: userId), // Pass userId here
    );
  }
}

class HomePage extends StatefulWidget {
  final String userId; // Add userId here

  HomePage({required this.userId}); 
  @override
  _HomePageState createState() => _HomePageState(userId: userId);
}

class _HomePageState extends State<HomePage> {
  final String userId; // Add a userId parameter

  _HomePageState({required this.userId});
  String userName = '';

  @override
  void initState() {
    super.initState();
    fetchUserNameFromFirebase();
  }

  void fetchUserNameFromFirebase() async {
  // Replace 'userId' with the actual user ID of the logged-in user
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final name = await fetchUserName(userId);

  setState(() {
    userName = name;
  });
}

Future<String> fetchUserName(String userId) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      final name = data['name'] as String;

      return name;
    } else {
      return ''; // Return a default value if the user document doesn't exist
    }
  } catch (error) {
    print('Error fetching user name: $error');
    return ''; // Handle the error and return a default value
  }
}


  int _currentIndex = 0; // Define _currentIndex as an instance variable



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
    HomePageContent(userName: userName,userId: userId,),
    TransactionPage(userId: userId,),
    // FoodmenuScreen(),
    FoodMenuPage(),
    ProfileScreen(),
  ];
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
                    'assets/name.png', // Replace with the path to your logo image
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
              title: Text('Rooms'),
              onTap: () {
                // Add code to handle fee payment here
              },
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: Text('Light Bill Payment'),
              onTap: () {
                // Add code to handle light bill payment here
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Bill Receipt'),
              onTap: () {
                // Add code to handle bill receipt here
              },
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text('Any Issue'),
              onTap: () {
                // Add code to handle any issue here
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                     Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminHomePage(userId: userId,),
        ),
      );
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
                  // HomeScreen.setThemeMode(newThemeMode);
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

  final String userName; // Add this parameter

  TopBox({required this.userName}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end, // Adjusted this line
            children: [
              Row(
                children: [
                  Icon(
                    Icons.room,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Room No: Not Alloted',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 4), // Increased the gap here
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Check-out: Not Alloted',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
               Row(
                children: [
                  SizedBox(width: 15),
                  Text(
                    '',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 20,
            child: Text(
              'Hello, $userName',
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
        Image.asset(
          'assets/Rectangle5.png',
          fit: BoxFit.cover, // Adjust the BoxFit property here
        ),
        Image.asset(
          'assets/pexels-pixabay-50987.jpg',
          fit: BoxFit.cover, // Adjust the BoxFit property here
        ),
        Image.asset(
          'assets/pexels-spencer-davis-4393021.jpg',
          fit: BoxFit.cover, // Adjust the BoxFit property here
        ),
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
  final String userId; // Add this parameter
  final String userName; // Add this parameter

  HomePageContent({required this.userName,required this.userId}); // Constructor
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBox(userName: userName),
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
                       Navigator.of(context).push(
                   MaterialPageRoute(
                            builder: (context) => AvailableRoomsPage(userId: userId,userName: userName,),
                    ),);
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
                     Navigator.of(context).push(
                   MaterialPageRoute(
                            builder: (context) => AvailableRoomsPage(userId: userId,userName: userName,),
                    ),);
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
                  Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TransactionPage(userId: userId,),
        ),);
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
                     Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TransactionPage(userId: userId,),
        ),
      );
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
      // Navigate to the AdminPage when the button is tapped
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IssuePage(),
        ),
      );
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
