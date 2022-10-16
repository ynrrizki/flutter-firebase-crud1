import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud1/ui/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  // const Home({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference? users;

  // var users = [
  //   ItemCard('Yanuar Rizki Sanjaya', 17, uid: const Key('1')),
  //   ItemCard('Anto Aji', 20, uid: const Key('2')),
  //   ItemCard('Yadi Sujatmoko', 35, uid: const Key('3')),
  // ];

  void _formAdd(context) {
    showDialog(
        context: context,
        builder: (context) {
          users = firestore.collection('users');
          return AlertDialog(
            content: Container(
              height: 210,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Name'),
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Age'),
                      prefixIcon: Icon(Icons.access_alarm_sharp),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        /// INSERT DATA
                        users!.add({
                          'name': nameController.text,
                          'age': int.tryParse(ageController.text) ?? 0,
                        });

                        nameController.text = '';
                        ageController.text = '';
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width - 320),
                        child: const Text('Add Data'),
                      )),
                ],
              ),
            ),
          );
        });
  }

  void _formEdit(context, var id) {
    showDialog(
        context: context,
        builder: (context) {
          users = firestore.collection('users');
          return AlertDialog(
            content: StreamBuilder<DocumentSnapshot>(
                stream: users!.doc(id).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    nameController.text =
                        (snapshot.data!.data() as dynamic)['name'];
                    ageController.text =
                        (snapshot.data!.data() as dynamic)['age'].toString();
                    return Container(
                      height: 210,
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Name'),
                              prefixIcon: Icon(Icons.account_circle_outlined),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: ageController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Age'),
                              prefixIcon: Icon(Icons.access_alarm_sharp),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                /// UPDATE DATA
                                users!.doc(id).update({
                                  'name': nameController.text,
                                  'age': int.tryParse(ageController.text),
                                });
                                Navigator.of(context).pop(true);
                                nameController.text = '';
                                ageController.text = '';
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width -
                                            320),
                                child: const Text('Add Data'),
                              )),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Loading...'),
                    );
                  }
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    users = firestore.collection('users');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _formAdd(context);
        },
      ),
      appBar: AppBar(
        title: const Text('Firebase CRUD 1'),
      ),
      body: ListView(
        children: [
          /// GET ALL DATA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              'All users',
              style: GoogleFonts.poppins().copyWith(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: users!.snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.docs
                        .map(
                          (e) => ItemCard(
                            (e.data() as dynamic)['name'],
                            (e.data() as dynamic)['age'],
                            onUpdate: () {
                              _formEdit(context, e.id);
                            },
                            onDelete: () {
                              users!.doc(e.id).delete();
                            },
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return const Text('Loading');
                }
              }),
        ],
      ),
    );
  }
}
