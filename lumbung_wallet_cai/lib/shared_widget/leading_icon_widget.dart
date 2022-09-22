import 'package:flutter/material.dart';

class LeadingIconWidget extends StatelessWidget {
  const LeadingIconWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        (title[0]).toUpperCase(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ContentTagLabelWidget extends StatelessWidget {
  const ContentTagLabelWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Wrap(
        spacing: 10,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 4,
                backgroundColor: Colors.green,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
