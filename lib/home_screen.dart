import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lecture_2/text_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isLoadingData = false;
  final databaseRef = FirebaseDatabase.instance.ref('Person');
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture 2'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextFieldWidget(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  hintText: 'ID',
                  validation: 'Please enter your id',
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  controller: _nameController,
                  hintText: 'Name',
                  validation: 'Please enter your name',
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  hintText: 'Age',
                  validation: 'Please enter your age',
                ),
                const SizedBox(height: 40),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        onPressed: performData,
                      ),
                const SizedBox(height: 20),
                Expanded(
                  child: FirebaseAnimatedList(
                    query: databaseRef,
                    itemBuilder: (context, snapshot, animation, index) {
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(5),
                          leading: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(snapshot.child('id').value.toString()),
                          ),
                          title: Text(snapshot.child('name').value.toString()),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void performData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        saveData();
      });
    }
  }

  Future<void> saveData() async {
    setState(() {
      isLoading = true;
    });
    await databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'id': _idController.text,
      'name': _nameController.text,
      'age': _ageController.text,
    }).then((value) {
      setState(() {
        isLoading = false;
        _idController.clear();
        _nameController.clear();
        _ageController.clear();
      });
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
