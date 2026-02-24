import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetCategory extends StatefulWidget {
  const GetCategory({super.key});

  @override
  State<GetCategory> createState() => _GetCategoryState();
}

class _GetCategoryState extends State<GetCategory> {
  final supaBase = Supabase.instance.client;
  List<Map<String, dynamic>> category = [];
  bool loading = false;
  getCategory() async{
    setState(() {
      loading = true;
    });
    try{
      final result = await supaBase.from('categories').select();

      setState(() {
        category = result;
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
    getCategory();
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
          for(var index in category)
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> UpdateCategory(category: index,)));
              },
              title: Text(index['name']),
              subtitle: Text(index['icon_url']),
              trailing: IconButton(
                onPressed: () async{
                  await supaBase.from('categories').delete().eq('id', index['id']);
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