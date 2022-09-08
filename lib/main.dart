// Started with https://docs.flutter.dev/development/ui/widgets-intro
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:to_dont_list/event_items.dart';
import 'package:to_dont_list/to_do_items.dart';

List<Event> sprints = [];
List<Item> items1 = [Item(name: "Add tasks!")];
List<Item> items2 = [Item(name: "Add homework!")];
final _itemSet = <Item>{};

// class ToDoList extends StatefulWidget {
//   const ToDoList({key, required this.title}) : super(key: key);

//   @override
//   State createState() => _ToDoListState();

//   final String title;
// }

class TrackList extends StatefulWidget {
  const TrackList({key, required this.title}) : super(key: key);

  @override
  State createState() => _TrackListState();
  final String title;
}

class _TrackListState extends State<TrackList> {
  @override
  var eventController = TextEditingController();
  var markController = TextEditingController();
  var yearController = TextEditingController();
  var meetController = TextEditingController();
  //Form code comes from https://stackoverflow.com/questions/54480641/flutter-how-to-create-forms-in-popup
  Future<void> _EventInfoPopupForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Contact Us'),
          content: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: eventController,
                decoration: InputDecoration(hintText: 'Event'),
              ),
              TextFormField(
                controller: markController,
                decoration: InputDecoration(hintText: 'Mark'),
              ),
              TextFormField(
                controller: yearController,
                decoration: InputDecoration(hintText: 'Year'),
              ),
              TextFormField(
                controller: meetController,
                decoration: InputDecoration(hintText: 'Meet'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _handleTrackItem(
                    eventController.text,
                    double.parse(markController.text),
                    yearController.text,
                    meetController.text);
                Navigator.pop(context);
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _handleTrackItem(event, mark, year, meet) {
    Event _event = Event(event: event, mark: mark, year: year, meet: meet);
    sprints.insert(0, _event);
    eventController.clear();
    markController.clear();
    yearController.clear();
    meetController.clear();
  }

  void _handleEventEdit(Event event) {
    sprints.remove(event);
    _EventInfoPopupForm(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sprint Personal Records'),
        ),
        // drawer code from https://rushabhshah065.medium.com/flutter-navigation-drawer-tab-layout-e74074c249ce
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Text(
                  "Type of Event",
                  textAlign: TextAlign.justify,
                  textScaleFactor: 2.0,
                ),
              ),
              ListTile(
                  title: Text("Sprints"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const TrackList(title: 'Sprints');
                    }));
                  }),
              ListTile(
                title: Text("Distance"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SecondPage(title: 'Distance');
                  }));
                },
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: sprints.map((item) {
            return EventItem(
              event: item,
              eventEdit: _handleEventEdit,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _EventInfoPopupForm(context);
            }));
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({key, required this.title}) : super(key: key);
  @override
  State createState() => _SecondPageState();
  final String title;
}

// class _ToDoListState extends State<ToDoList> {
//   // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
//   final TextEditingController _inputController = TextEditingController();
//   final ButtonStyle yesStyle = ElevatedButton.styleFrom(
//       textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
//   final ButtonStyle noStyle = ElevatedButton.styleFrom(
//       textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

//   Future<void> _displayTextInputDialog(BuildContext context) async {
//     print("Loading Dialog");
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Item To Add'),
//             content: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   valueText = value;
//                 });
//               },
//               controller: _inputController,
//               decoration:
//                   const InputDecoration(hintText: "type something here"),
//             ),
//             actions: <Widget>[
//               ElevatedButton(
//                 key: const Key("OKButton"),
//                 style: yesStyle,
//                 child: const Text('OK'),
//                 onPressed: () {
//                   setState(() {
//                     _handleNewItem(valueText);
//                     Navigator.pop(context);
//                   });
//                 },
//               ),

//               // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
//               ValueListenableBuilder<TextEditingValue>(
//                 valueListenable: _inputController,
//                 builder: (context, value, child) {
//                   return ElevatedButton(
//                     key: const Key("CancelButton"),
//                     style: noStyle,
//                     onPressed: value.text.isNotEmpty
//                         ? () {
//                             setState(() {
//                               Navigator.pop(context);
//                             });
//                           }
//                         : null,
//                     child: const Text('Cancel'),
//                   );
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   String valueText = "";

//   //final List<Item> items = [const Item(name: "add more todos")];

//   void _handleListChanged(Item item, bool completed) {
//     setState(() {
//       // When a user changes what's in the list, you need
//       // to change _itemSet inside a setState call to
//       // trigger a rebuild.
//       // The framework then calls build, below,
//       // which updates the visual appearance of the app.

//       items1.remove(item);
//       if (!completed) {
//         print("Completing");
//         _itemSet.add(item);
//         items1.add(item);
//       } else {
//         print("Making Undone");
//         _itemSet.remove(item);
//         items1.insert(0, item);
//       }
//     });
//   }

//   void _handleDeleteItem(Item item) {
//     setState(() {
//       print("Deleting item");
//       items1.remove(item);
//     });
//   }

//   void _handleNewItem(String itemText) {
//     setState(() {
//       print("Adding new item");
//       Item item = Item(name: itemText);
//       items1.insert(0, item);
//       _inputController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Personal List'),
//         ),
//         // drawer code from https://rushabhshah065.medium.com/flutter-navigation-drawer-tab-layout-e74074c249ce
//         drawer: Drawer(
//           child: ListView(
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(color: Colors.green),
//                 child: Text(
//                   "Categories",
//                   textAlign: TextAlign.justify,
//                   textScaleFactor: 2.0,
//                 ),
//               ),
//               ListTile(
//                   title: Text("Personal"),
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return const ToDoList(title: 'Personal List');
//                     }));
//                   }),
//               ListTile(
//                 title: Text("School"),
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return const SecondPage(title: 'SecondPage');
//                   }));
//                 },
//               ),
//               Spacer(
//                 flex: 10,
//               ),
//               // Align(
//               //     alignment: Alignment.bottomRight,
//               //     child: FloatingActionButton(
//               //         child: const Icon(Icons.add),
//               //         onPressed: () {
//               //           _displayTextInputDialog(context);
//               //         }))
//             ],
//           ),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           children: items1.map((item) {
//             return ToDoListItem(
//               item: item,
//               completed: _itemSet.contains(item),
//               onListChanged: _handleListChanged,
//               onDeleteItem: _handleDeleteItem,
//             );
//           }).toList(),
//         ),
//         floatingActionButton: FloatingActionButton(
//             child: const Icon(Icons.add),
//             onPressed: () {
//               _displayTextInputDialog(context);
//             }));
//   }
// }

// Going to redo this page to be a list calender that orders the to dos by the dates that I will add in the first page
class _SecondPageState extends State<SecondPage> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);
  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Add'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "type something here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText);
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  //final List<Item> items = [const Item(name: "Add homework")];

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items2.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items2.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items2.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items2.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      items2.insert(0, item);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('School Work'),
        ),
        // drawer code from https://rushabhshah065.medium.com/flutter-navigation-drawer-tab-layout-e74074c249ce
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                child: Text(
                  "Categories",
                  textAlign: TextAlign.justify,
                  textScaleFactor: 2.0,
                ),
              ),
              ListTile(
                title: Text("Personal"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const TrackList(title: 'Personal List');
                  }));
                },
              ),
              ListTile(
                title: Text("School"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Spacer(
                flex: 10,
              ),
              // Align(
              //     alignment: Alignment.bottomRight,
              //     child: FloatingActionButton(
              //         child: const Icon(Icons.add),
              //         onPressed: () {
              //           _displayTextInputDialog(context);
              //         }))
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items2.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Sprint PRs',
    home: TrackList(
      title: 'Sprint PR',
    ),
  ));
}
