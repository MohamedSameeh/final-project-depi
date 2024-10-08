import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key});

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = "";
  String email = "";
  String phone = "";
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime(1989, 12, 12);

  Future<Map<String, dynamic>?> _fetchUserData() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser?.uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          fullName = data['user name'];
          email = data['Email'];
          phone = data['phone number'];
        } else {
          print('Document data is null');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print("error.............$e");
    }
  }

  @override
  void initState() {
    super.initState();
    dateController.text = formatDate(selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = formatDate(selectedDate);
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Text('Loading Your Data...');
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Name: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(fullName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Email: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(email,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Phone Number: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(phone,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal)),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dateController,
                          decoration:
                              InputDecoration(labelText: 'Date of Birth'),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(left: 10, right: 10, top: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red,
                      ),
                      child: MaterialButton(
                        minWidth: 70,
                        onPressed: () async {
                          //go to update screen
                          Navigator.pushReplacementNamed(
                              context, 'updateUserInformation');
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
