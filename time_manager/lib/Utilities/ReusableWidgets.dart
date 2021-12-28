import 'package:flutter/material.dart';

class ListDeleteBackground extends StatelessWidget {
  const ListDeleteBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(32),
      child: const Icon(Icons.delete),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key? key, this.leadingColor, this.title, this.subTitle}) : super(key: key);
  final Color? leadingColor;
  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Container(
          height: 64,
          width: 64,
          decoration: leadingColor != null ? BoxDecoration(shape: BoxShape.circle, color: leadingColor ?? Colors.black) : null,
        ),
        title: title != null ?Text(title ??'') : null,
        subtitle: subTitle != null ?Text(subTitle ??'') : null
      ),
    );
  }
}
