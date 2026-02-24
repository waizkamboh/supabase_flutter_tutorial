import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_tutorial/crud/update_notes.dart';

class GetRealTimeNotesWithChannelScreen extends StatefulWidget {
  const GetRealTimeNotesWithChannelScreen({super.key});

  @override
  State<GetRealTimeNotesWithChannelScreen> createState() => _GetRealTimeNotesWithChannelScreenState();
}

class _GetRealTimeNotesWithChannelScreenState extends State<GetRealTimeNotesWithChannelScreen> {
  final supaBase = Supabase.instance.client;
  RealtimeChannel? channel;
  void listenChannel(){
    final channel = supaBase.channel('public:;notes')
        .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notes',
        callback: (payload){
          print('New record: ${payload.newRecord}');
        }
    ).onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'notes',
        callback: (payload){
          print('Update: ${payload.newRecord}');
        }
    ).onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'notes',
        callback: (payload){
          print('Delete: $payload}');
        }
    ).subscribe();
  }
  void listenChannelOnParticularRow(){
    channel = supaBase.channel('public:notes:id=eq.14')
       .onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'notes',
        filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: 14
        ),
        callback: (payload){
          print('Update: ${payload.newRecord}');
        }
    ).subscribe();
  }

  @override
  void initState() {
     listenChannel();
    //listenChannelOnParticularRow();
    super.initState();
  }

  @override
  void dispose() {
    channel?.unsubscribe();
    super.dispose();
  }

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
