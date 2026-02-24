import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_tutorial/crud/get_notes.dart';
import 'package:supabase_flutter_tutorial/crud/get_realtime_notes.dart';
import 'package:supabase_flutter_tutorial/get_real_time_notes_with_channel.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {

  final notesName = TextEditingController();
  final notesDesc = TextEditingController();
  final supaBase = Supabase.instance.client;
  bool loading = false;

  addNotes() async{
    setState(() {
      loading = true;
    });
    try{
      await supaBase.from('notes').insert({
        'name' : notesName.text,
        'description' : notesDesc.text,
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
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

               TextField(
                 controller: notesName,
                 decoration: InputDecoration(
                   hintText: 'Notes Name',
                   border: OutlineInputBorder()

                 ),
               ),

              const SizedBox(height: 30),

              TextField(
                controller: notesDesc,
                decoration: InputDecoration(
                  hintText: 'Notes Description',
                    border: OutlineInputBorder()


                ),
              ),
              const SizedBox(height: 30),
              loading? CircularProgressIndicator():
              ElevatedButton(
                  onPressed: (){
                    addNotes();
                  },
                  child: Text('Add Notes')
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                  onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (_)=>GetRealTimeNotesWithChannelScreen()));
                  },
                  child: Text('Gets Notes')
              ),


            ],
          ),
        ),
      ),
    );
  }
}