import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_tutorial/crud/update_notes.dart';

class GetNotesScreen extends StatefulWidget {
  const GetNotesScreen({super.key});

  @override
  State<GetNotesScreen> createState() => _GetNotesScreenState();
}

class _GetNotesScreenState extends State<GetNotesScreen> {
  final supaBase = Supabase.instance.client;
  List<Map<String, dynamic>> notes = [];
  bool loading = false;
  getNotes() async{
    setState(() {
      loading = true;
    });
    try{
      final result = await supaBase.from('notes').select();

      setState(() {
        notes = result;
      });
    }catch (e){
      print(e);
    }finally{
      setState(() {
        loading = false;
      });
    }
  }


  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Notes'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),

      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
      ListView(
        children: [
          for(var note in notes)
            ListTile(
              onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (_)=> UpdateNotesScreen(note: note,)));
              },
              title: Text(note['name']),
              subtitle: Text(note['description']),
              trailing: IconButton(
                onPressed: () async{
                  await supaBase.from('notes').delete().eq('id', note['id']);
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              ),
            )
        ],
      ),
    );
  }
}
