import 'package:app_flutter/provider.dart/workout_chosed.dart';
import 'package:app_flutter/provider.dart/workout.dart';
import 'package:app_flutter/screen/work_out/workout_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkOutListSceen extends StatefulWidget {
  static const routeName = '/list-workout';
  const WorkOutListSceen({Key? key}) : super(key: key);

  @override
  _WorkOutListSceenState createState() => _WorkOutListSceenState();
}

class _WorkOutListSceenState extends State<WorkOutListSceen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<WorkOutProvider>(context, listen: false).fetchProducts();
  }

  @override
  void initState() {
    super.initState();
    _refreshProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    final _workOutProvider = Provider.of<WorkOutProvider>(context);
    final _practicedProvider = Provider.of<PracticedProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('List'),
          actions: [
            IconButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                      context, WorkOutUpdateScreen.routeName);
                  debugPrint('$result');
                },
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 35,
                ))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
                reverse: true,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final item = _workOutProvider.items[index];
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ListTile(
                        title: Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        subtitle:
                            Text('${item.kcalBurn.round()} kcal - 30 minutes'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _workOutProvider
                                    .removeProduct(item)
                                    .then((value) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Deleted item'),
                                    duration: Duration(microseconds: 1200),
                                  ));
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _practicedProvider.addToPracticed(item);
                              },
                            ),
                          ],
                        )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                      height: 10,
                    ),
                itemCount: _workOutProvider.items.length),
          )),
        ));
  }
}
