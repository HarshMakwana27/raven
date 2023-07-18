import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () => {},
                child: Image.asset(
                  "assets/images/raven.png",
                  width: 35,
                ),
              ),
            ),
            Text('Raven',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      body: Stack(children: [
        Container(
          width: width,
          height: height,
          child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              "assets/images/pxfuel.jpg",
              fit: BoxFit.fill,
            ),
          ),
        ),
        const Center(
          child: Text(
            'okat',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "lak"),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "lak"),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "lak")
          ]),
      // backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
