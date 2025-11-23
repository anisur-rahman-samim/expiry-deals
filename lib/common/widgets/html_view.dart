
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class HTMLView extends StatelessWidget {
  final String htmlData;

  const HTMLView({Key? key, required this.htmlData}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      shrinkWrap: true,
      style: {
        "body": Style(
          margin: Margins.zero,
          color: Colors.white
        //  padding: EdgeInsets.zero,
        ),
        // tables will have the below background color
        "table": Style(
          backgroundColor: Colors.white,
        ),
        // some other granular customizations are also possible
        "tr": Style(
          border: const Border(bottom: BorderSide(color: Colors.white,)),
        ),
        "th": Style(
        //  padding: const EdgeInsets.all(6),
          backgroundColor: Colors.white,
        ),
        "td": Style(
       //   padding: const EdgeInsets.all(6),
          alignment: Alignment.topLeft,
          color: Colors.white
        ),
        // text that renders h1 elements will be red
        "h1": Style(
          color: Colors.white,
          fontSize: FontSize.xxLarge,
          textAlign: TextAlign.justify,
        ),
        "h2": Style(
          color: Colors.white,
          fontSize: FontSize.xLarge,
          textAlign: TextAlign.justify,
        ),
        "h3": Style(
          color: Colors.white,
          fontSize: FontSize.large,
          textAlign: TextAlign.justify,
        ),
        "h4": Style(
          color: Colors.white,
          fontSize: FontSize.medium,
          textAlign: TextAlign.justify,
        ),
        "h5": Style(
          color: Colors.white,
          fontSize: FontSize.small,
          textAlign: TextAlign.justify,
        ),
        "h6": Style(
          color: Colors.white,
          fontSize: FontSize.xSmall,
          textAlign: TextAlign.justify,
        ),
        "p": Style(
          color: Colors.white,
          fontSize: FontSize.small,
          textAlign: TextAlign.justify,
        ),
        "span": Style(
          color: Colors.white,
          fontSize: FontSize.medium,
          textAlign: TextAlign.justify,
        ),
      },
    );
  }
}

