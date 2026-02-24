import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_tutorial/crud/get_notes.dart';

class UpdateNotesScreen extends StatefulWidget {
  final Map<String, dynamic>  note;
  const UpdateNotesScreen({super.key, required this.note});

  @override
  State<UpdateNotesScreen> createState() => _UpdateNotesScreenState();
}

class _UpdateNotesScreenState extends State<UpdateNotesScreen> {

  final notesName = TextEditingController();
  final notesDesc = TextEditingController();
  final supaBase = Supabase.instance.client;
  bool loading = false;

  updateNotes() async{
    setState(() {
      loading = true;
    });
    try{
      await supaBase.from('notes').update({
        'name' : notesName.text,
        'description' : notesDesc.text,
      }).eq('id', value);
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
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>GetNotesScreen()));
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