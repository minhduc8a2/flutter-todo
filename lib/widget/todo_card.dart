import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateToEditPage;
  final Function(String) deleteById;
  final Function(Map) markCompleted;
  const ToDoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateToEditPage,
      required this.deleteById,
      required this.markCompleted});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => deleteById(item['_id']),
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(16),
            )
          ],
        ),
        child: Card(
          child: ListTile(
            onTap: () => navigateToEditPage(item),
            minVerticalPadding: 24,
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(
              utf8.decode((item['content'] as String).codeUnits),
              style: TextStyle(
                  decoration: (item['completed'] as bool)
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'completed') {
                  markCompleted(item);
                }
              },
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'completed',
                    child: Text('Mark completed'),
                  ),
                ];
              },
            ),
          ),
        ));
    ;
  }
}
