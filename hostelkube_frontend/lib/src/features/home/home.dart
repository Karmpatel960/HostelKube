import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelkube_frontend/src/features/home/payment/payment.dart';
import 'package:hostelkube_frontend/src/features/home/payment/paymentlist.dart';
import 'transactions/transactions.dart';
import 'profile/profile.dart';
import 'foodmenu/foodmenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final String userId;

  const HomeScreen({Key? key, this.themeMode = ThemeMode.light, required this.userId})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(themeMode, userId);
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeMode _themeMode;


  _HomeScreenState(ThemeMode themeMode, String userId)
      : _themeMode = themeMode, // Initialize _themeMode here
        super() {
    // Additional constructor code, if needed
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prince Hostel',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: HomePage(userId: widget.userId, themeMode: _themeMode, onThemeChanged: _toggleTheme),
    );
  }
}


// class _HomeScreenState extends State<HomeScreen> {
//   ThemeMode _themeMode = ThemeMode.light;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Prince Hostel',
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//         themeMode: _themeMode, 
//       home: HomePage(userId: widget.userId, themeMode: widget.themeMode, onThemeChanged: _toggleTheme),
//     );
//   }

//   void _toggleTheme() {
//     setState(() {
//       _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     });
//   }
// }

class HomePage extends StatefulWidget {
  final String userId;
  final ThemeMode themeMode;
  final Function() onThemeChanged;

  HomePage({required this.userId, required this.themeMode, required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState(userId: userId, themeMode: themeMode, onThemeChanged: onThemeChanged);
}

class _HomePageState extends State<HomePage> {
  final String userId;
  final ThemeMode themeMode;
  final Function() onThemeChanged;

  ThemeMode _themeMode = ThemeMode.light;

  _HomePageState({required this.userId, required this.themeMode, required this.onThemeChanged}) {
    _themeMode = themeMode;
  }

  String userName = '';
  String roomNumber = 'Not Alloted'; 
  String checkout = 'Not Alloted'; 
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
        _themeMode = widget.themeMode;
        _isDarkTheme = _themeMode == ThemeMode.dark;
    fetchUserNameFromFirebase();
    
  }

  void fetchUserNameFromFirebase() async {
  // Replace 'userId' with the actual user ID of the logged-in user
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final name = await fetchUserName(userId);
  final numb = await fetchRoomNumberFromRoomsCollection(userId);
  final cdate = await getCheckOutDate(userId);
  setState(() {
    userName = name;
    roomNumber = numb;
    if (cdate != null) {
      // Format the DateTime into a string
      final formattedDate = DateFormat('dd/MM/yyyy').format(cdate);
      checkout = '$formattedDate';
    } else {
      checkout = 'Not Alloted';
    }
  });
}

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      widget.onThemeChanged();
      _isDarkTheme = !_isDarkTheme; // Toggle _isDarkTheme state
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

Future<String> fetchRoomNumberFromRoomsCollection(String userId) async {
  try {
    final roomsQuery = await FirebaseFirestore.instance.collection('rooms')
      .where('users', arrayContains: userId) // Check if the user is in the 'users' array
      .get();

    if (!roomsQuery.docs.isEmpty) {
      final roomData = roomsQuery.docs[0].data() as Map<String, dynamic>;
      final fetchedRoomNumber = roomData['roomNumber'];
      return fetchedRoomNumber;
    }
     return ''; 
  } catch (error) {
    print('Error fetching room number: $error');
     return ''; 
  }
}

Future<DateTime?> getCheckOutDate(String userId) async {
  // Query the Firestore collection to find the booking document by userId
  final QuerySnapshot bookingDocs = await FirebaseFirestore.instance
      .collection('bookings')
      .where('userId', isEqualTo: userId)
      .get();

  if (bookingDocs.docs.isNotEmpty) {
    final bookingData = bookingDocs.docs.first.data() as Map<String, dynamic>;
    final bookingDate = bookingData['timestamp'] as Timestamp;
    return bookingDate.toDate().add(Duration(days: 365));
  } else {
    return null; // No booking found for the user
  }
}



  int _currentIndex = 0; // Define _currentIndex as an instance variable



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
    HomePageContent(userName: userName,userId: userId,roomNumber: roomNumber,checkout:checkout),
    TransactionPage(userId: userId,),
    // FoodmenuScreen(),
    UserWeekMenuPage(),
    ProfileScreen(),
  ];

        return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Prince Hostel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
      body: _pages[_currentIndex],
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
                    height: 80,
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
            // Drawer items as you described
     
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Rooms'),
              onTap: () {
                  Navigator.of(context).push(
                   MaterialPageRoute(
                            builder: (context) => AvailableRoomsPage(userId: userId,userName: userName,),
                    ),);
                // Add code to handle fee payment here
              },
            ),
            ListTile(
              leading: Icon(Icons.lightbulb_outline),
              title: Text('Light Bill Payment'),
              onTap: () {
                 Navigator.of(context).push(
                   MaterialPageRoute(
                            builder: (context) => LightBillPaymentPage(userId: userId,userName: userName,),
                    ),);
                // Add code to handle light bill payment here
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Bill Receipt'),
              onTap: () {
                // Add code to handle bill receipt here
                 Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TransactionPage(userId: userId,),
        ),);
              },
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text('Any Issue'),
              onTap: () {
                // Add code to handle any issue here
                Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IssuePage(userId: userId,),
        ),
      );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                     Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AboutScreen(),
        ),
      );
                // Add code to navigate to the "About Us" screen here
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6), // Icon for theme change
              title: Text('Dark Theme'), // Theme change option
              trailing: Switch(
                 value: _isDarkTheme, // Use _isDarkTheme to control the Switch state
          onChanged: (value) {
            print('Switch value changed: $value');
            _toggleTheme(); // Toggle the theme when the switch changes
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
            ? Colors.white
            : Colors.black,
        selectedFontSize: 12,
        unselectedFontSize: 9,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Receipt'),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
  final String userName;
  final String roomNumber;
  final String checkOutDate; // Add this parameter

  TopBox({
    required this.userName,
    required this.roomNumber,
    required this.checkOutDate,
  }); // Constructor

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
                    'Room No: $roomNumber',
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
                    'Check-out: $checkOutDate', // Display the Check-out date
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
  final String roomNumber;
  final  String checkout;

  HomePageContent({required this.userName,required this.userId,required this.roomNumber,required this.checkout}); // Constructor
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBox(userName: userName,roomNumber: roomNumber,checkOutDate: checkout),
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
                            builder: (context) => LightBillPaymentPage(userId: userId,userName: userName,),
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
                       Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserWeekMenuPage(),
        ),);
                    
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
          builder: (context) => PaidBillsPage(userId: userId,),
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
          builder: (context) => IssuePage(userId: userId,),
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

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Our App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'About Us:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'We are a dedicated team of developers who built this app to make your life easier. Thank you for using our app!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
