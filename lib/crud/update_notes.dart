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
      }).eq('id', widget.note['id']);
    }catch(e){
      print(e);
    }finally{

      setState(() {
        loading = false;

      });
    }
  }
  @override
  void initState() {
    notesName.text = widget.note['name'];
    notesDesc.text = widget.note['description'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Notes'),
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
                    updateNotes();
                  },
                  child: Text('Update Notes')
              ),



            ],
          ),
        ),
      ),
    );
  }
}