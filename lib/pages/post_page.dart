import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/components/my_textfield.dart';
import 'package:crud_app/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostPage extends StatefulWidget {
  PostPage({super.key});

  

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // text field controller
  final TextEditingController controller = TextEditingController();

  // post message
  void postMessage(){

    // only post message if there is somthing in textfield

    if(controller.text.isNotEmpty){
      String message = controller.text;
      database.addPost(message);

      // clear the controller
      controller.clear();

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P O S T S"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            // Post
            StreamBuilder(
              stream: database.getPostStream(), 
              builder: (context, snapshot){
                // show loading  circle
                if(snapshot.connectionState== ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }

                // get all post
                final posts = snapshot.data!.docs;

                // no data
                if(snapshot.data == null || posts.isEmpty){
                  return Center(child: Text("No Data"),);
                }

                // return as a list
                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index){
                      // get each idividual post
                      final post = posts[index];

                      // get data from each post
                      String message = post['PostMessage'];
                      String userEmail = post['UserEmail'];
                      Timestamp timestamp = post['TimeStamp'];

                      // return as a list tile

                      return ListTile(
                        title: Text(message),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(userEmail, style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                            Text(timestamp.toDate().toString(), style: TextStyle(color: Theme.of(context).colorScheme.secondary),)
                          ],
                        ),

                      );
                    }
                  )
                );

              }
            ),

            // post message
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: MyTextField(hintText: "Say somthing....", obscureText: false, controller: controller )),
                      const SizedBox(width: 10,),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(6)
                        ),
                        
                        child: IconButton(onPressed: postMessage, icon: Icon(Icons.send, size: 30,)))
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}