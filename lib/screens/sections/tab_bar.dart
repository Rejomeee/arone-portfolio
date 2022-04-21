import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/components/white_container.dart';
import 'package:flutter_my_portfolio/constant/data.dart';

class AppTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: const BoxDecoration(
        color: Color(0xff5A72EA),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            SizedBox(width: 16),
            SizedBox(
              width: 32,
              height: 32,
              child: CircleAvatar(
                backgroundImage: AssetImage(Data.AVATAR),
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(width: 16),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${Data.NAME}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    // text: ' ●',
                    text: '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xffFF5A59),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
