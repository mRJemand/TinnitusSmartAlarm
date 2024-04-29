import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/tip.dart';
import 'package:tinnitus_smart_alarm/screens/tip_detail_screen.dart';

class TipItem extends StatelessWidget {
  final Tip tip;

  const TipItem({
    Key? key,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TipDetailScreen(tip: tip)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow[700],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        tip.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        tip.objective,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
