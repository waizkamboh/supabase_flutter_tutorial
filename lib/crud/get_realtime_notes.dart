import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_tutorial/crud/update_notes.dart';

class GetRealTimeNotesScreen extends StatefulWidget {
  const GetRealTimeNotesScreen({super.key});

  @override
  State<GetRealTimeNotesScreen> createState() => _GetRealTimeNotesScreenState();
}

class _GetRealTimeNotesScreenState extends State<GetRealTimeNotesScreen> {
   final supaBase = Supabase.instance.client;
  // List<Map<String, dynamic>> notes = [];
  // bool loading = false;
  // getRealTimeNotes() async{
  //   try{
  //     supaBase.from('notes').stream(primaryKey: ['id']).listen((data){
  //       setState(() {
  //         notes = data;
  //       });
  //     });
  //   }catch (e){
  //     print(e);
  //   }
  // }
  //
  //
  // @override
  // void initState() {
  //   getRealTimeNotes();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Real Time Notes'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),

      ),
      body: StreamBuilder(
        stream: supaBase.from('notes').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data?? [];
          return ListView(
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
          );
        }
      ),
    );
  }
}
