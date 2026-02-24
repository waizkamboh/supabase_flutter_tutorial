import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {

  final categoryName = TextEditingController();
  final categoryIcon = TextEditingController();
  final supaBase = Supabase.instance.client;
  bool loading = false;

  addCategory() async{
    setState(() {
      loading = true;
    });
    try{
      await supaBase.from('categories').insert({
        'name' : categoryName.text,
        'icon_url' : categoryIcon.text,
      });
    }catch(e){
      print(e);
    }finally{

      setState(() {
        loading = false;

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notes'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

             TextField(
               controller: categoryName,
               decoration: InputDecoration(
                 hintText: 'Notes Name',

               ),
             ),

            const SizedBox(height: 30),

            TextField(
              controller: categoryName,
              decoration: InputDecoration(
                hintText: 'Notes Description',

              ),
            ),
            const SizedBox(height: 30),
            loading? CircularProgressIndicator():
            ElevatedButton(
                onPressed: (){
                  addCategory();
                },
                child: Text('Add Notes')
            ),

            ElevatedButton(
                onPressed: (){
                },
                child: Text('Gets Notes')
            ),


          ],
        ),
      ),
    );
  }
}