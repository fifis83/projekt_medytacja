import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:projekt_medytacja/options.dart';
import 'package:projekt_medytacja/results.dart';

Widget appBarContent(int round, BuildContext context, [String? time]) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      // for correct spacing
      Text(
        "Finish",
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
      ),

      Text('Round $round'),

      CupertinoButton(
        child: Text("Finish"),
        onPressed: () {
          if (time != null) DataUtils.finishRound(time);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      DataUtils.curSesh.isNotEmpty ? Results() : Options(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
    ],
  );
}


