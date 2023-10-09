// import 'package:flutter/material.dart';

// class FoodmenuScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('food Screen'),
//     );
//   }
// }
import 'package:flutter/material.dart';

class HostelFeeInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Fee Information'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Hostel Fee Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hostel Fee Structure',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildFeeCard(
              title: 'Single Room',
              description: 'Single occupancy room with attached bathroom.',
              fee: '₹ 5,000/month',
            ),
            _buildFeeCard(
              title: 'Double Room',
              description: 'Double occupancy room with shared bathroom.',
              fee: '₹ 4,000/month',
            ),
            _buildFeeCard(
              title: 'Triple Room',
              description: 'Triple occupancy room with shared bathroom.',
              fee: '₹ 3,000/month',
            ),
            _buildFeeCard(
              title: 'Six Months Discount',
              description: 'Pay for six months upfront and get 10% off.',
              fee: '₹ 27,000 (Save ₹ 3,000)',
            ),
            _buildFeeCard(
              title: 'One Year Discount',
              description: 'Pay for one year upfront and get 20% off.',
              fee: '₹ 48,000 (Save ₹ 12,000)',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeCard({String? title, String? description, String? fee}) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description!,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              fee!,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

