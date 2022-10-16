import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  // const ItemCard({
  //   Key? key,
  // }) : super(key: key);
  final dynamic? uid;
  final String name;
  final int age;
  final Function? onUpdate;
  final Function? onDelete;
  ItemCard(this.name, this.age, {this.uid, this.onUpdate, this.onDelete});
  dynamic _deleteAlert(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  if (onDelete != null) onDelete!();
                },
                child: const Text("DELETE")),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {},
      confirmDismiss: (DismissDirection direction) async {
        return await _deleteAlert(context);
      },
      key: uid ?? UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      child: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(
              bottom: 20,
              left: 15,
              right: 15,
            ),
            elevation: 5,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text('$name'),
                  subtitle: Text(
                    '$age',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_horiz_outlined),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: ListTile(
                          title: Text(
                            'Update',
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: const Icon(Icons.edit),
                          onTap: () {
                            if (onUpdate != null) onUpdate!();
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          title: Text(
                            'Delete',
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: const Icon(Icons.delete),
                          onTap: () {
                            _deleteAlert(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
