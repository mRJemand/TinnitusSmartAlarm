import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/tip.dart';
import 'package:tinnitus_smart_alarm/screens/tip_detail_screen.dart';
import 'package:tinnitus_smart_alarm/services/tips_manager.dart';

class TipItem extends StatefulWidget {
  final Tip tip;

  const TipItem({
    Key? key,
    required this.tip,
  }) : super(key: key);

  @override
  State<TipItem> createState() => _TipItemState();
}

class _TipItemState extends State<TipItem> {
  late List<int> favorites;
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favorites = await TipsManager.loadFavoriteTips();
    setState(() {
      favorites.forEach((element) {
        if (element == widget.tip.id) {
          widget.tip.isFavorite = true;
        }
      });
    });
  }

  persistFavorites(int id, bool status) async {
    setState(() {
      if (status) {
        favorites.add(id);
        TipsManager.saveFavoriteTips(favorites);
      } else {
        favorites.removeWhere((element) => element == id);
        TipsManager.saveFavoriteTips(favorites);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TipDetailScreen(tip: widget.tip)),
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
              IconButton(
                icon: Icon(
                  Icons.star,
                ),
                color:
                    widget.tip.isFavorite == true ? Colors.yellow[700] : null,
                onPressed: () async {
                  // TipsManager tipsManager = TipsManager();
                  List<int> tipFavorites = await TipsManager.loadFavoriteTips();
                  if (widget.tip.isFavorite == null ||
                      widget.tip.isFavorite == false) {
                    widget.tip.isFavorite = true;
                    persistFavorites(widget.tip.id, true);
                  } else {
                    widget.tip.isFavorite = false;
                    persistFavorites(widget.tip.id, false);
                  }
                },
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
                        widget.tip.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.tip.objective,
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
