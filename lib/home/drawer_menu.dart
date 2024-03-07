import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:selfstudy/app_config.dart';

class DrawerMenu extends StatefulWidget {

  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => CreateSList();
}
class CreateSList extends State<DrawerMenu>{

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    final double DH = MediaQuery.of(context).size.height;

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Header of the Drawer
            Material(
              color: Colors.blueAccent,
              child: InkWell(
                onTap: (){
                  /// Close Navigation drawer before
                  // Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()),);
                },
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      bottom: 24
                  ),
                  child: Column(
                    children: const[
                      CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(AppConfig.LOGO_URL+"SelfStudyLogo.png"),
                      ),
                      SizedBox(height: 12,),
                      Text('Self Study',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white
                        ),),
                      const Text('skandsolution@gmail.com',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                        ),),

                    ],
                  ),
                ),
              ),
            ),

            /// Header Menu items
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text('Profile'),
                  onTap: (){
                    /// Close Navigation drawer before
                    // Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text('Upload'),
                  onTap: (){
                    /// Close Navigation drawer before
                    // Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen()),);
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.workspaces),
                //   title: Text('Workflow'),
                //   onTap: (){},
                // ),
                // ListTile(
                //   leading: Icon(Icons.update),
                //   title: Text('Updates'),
                //   onTap: (){},
                // ),
                const Divider(color: Colors.black45,),
                // ListTile(
                //   leading: Icon(Icons.account_tree_outlined),
                //   title: Text('Plugins'),
                //   onTap: (){},
                // ),
                ListTile(
                  leading: Icon(Icons.notifications_outlined),
                  title: Text('Notifications'),
                  onTap: (){},
                ),
              ],
            )
          ],
        ),
      ),
    );

  }

} //CreateSList