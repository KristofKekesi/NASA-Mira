import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:nasamira/pages/roverSpecPage.dart';
import 'package:nasamira/widgets/localization.dart';
import 'package:nasamira/widgets/update.dart';

List<dynamic> hardCodeData = [];
var roverGridTitle = AutoSizeGroup();
int counter = 0;

double getGrid(context) {
  return MediaQuery.of(context).size.width * .4 -
      MediaQuery.of(context).size.width * .0125;
}

class _RoverGridInner extends StatelessWidget {
  final data;

  const _RoverGridInner({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> roverList = [];
    for (var index = 0; index < data.length; index++) {
      roverList.add(
        Tooltip(
          message: AppLocalizations.of(context).translate("more"),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoverSpecPage(
                          dataSector: index,
                          apiEnabled: data[index]["api-enabled"],
                          url: data[index]["url"],
                          mission: data[index]["mission"],
                          nick: data[index]["nick"],
                          type: data[index]["type"],
                          launch: data[index]["launch"],
                          arrive: data[index]["arrive"],
                          connectionLost: data[index]["connection-lost"],
                          end: data[index]["end"],
                          defaultPosition: data[index]["default"],
                          operator: data[index]["operator"],
                          manufacturer: data[index]["manufacturer"],
                        )),
              );
            },
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * .0125),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular((MediaQuery.of(context).size.width +
                            MediaQuery.of(context).size.height) /
                        2 *
                        .04),
                  ),
                ),
                width: getGrid(context),
                height: MediaQuery.of(context).size.height * .2,
                child: Padding(
                  padding: EdgeInsets.all((MediaQuery.of(context).size.width +
                          MediaQuery.of(context).size.height) /
                      2 *
                      .03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Conditional.single(
                            context: context,
                            conditionBuilder: (BuildContext context) =>
                                data[index]["mission"] == null,
                            widgetBuilder: (BuildContext context) =>
                                Container(),
                            fallbackBuilder: (BuildContext context) => Text(
                              data[index]["mission"],
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    (MediaQuery.of(context).size.height * .02),
                              ),
                            ),
                          ),
                          AutoSizeText(
                            data[index]["nick"],
                            group: roverGridTitle,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  (MediaQuery.of(context).size.height * .025),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate("state"),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      (MediaQuery.of(context).size.height *
                                          .02),
                                ),
                              ),
                              Conditional.single(
                                context: context,
                                conditionBuilder: (BuildContext context) =>
                                    data[index]["status"] == "active",
                                widgetBuilder: (BuildContext context) => Text(
                                  AppLocalizations.of(context)
                                      .translate("active"),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        (MediaQuery.of(context).size.height *
                                            .025),
                                  ),
                                ),
                                fallbackBuilder: (BuildContext context) => Text(
                                  AppLocalizations.of(context)
                                      .translate("inactive"),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        (MediaQuery.of(context).size.height *
                                            .025),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: MediaQuery.of(context).size.width * .1,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width * .825,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 0,
        runSpacing: 0,
        children: roverList,
      ),
    );
  }
}

class RoverGrid extends StatefulWidget {
  @override
  _RoverGridState createState() => _RoverGridState();
}

class _RoverGridState extends State<RoverGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('lib/data.json'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            hardCodeData = json.decode(snapshot.data.toString());
            if (counter == 0) {
              counter++;
              update(hardCodeData).then((e) {
                if (updated == true) {
                  setState(() {});
                }
              });
            }
            if (updated == false) {
              return _RoverGridInner(data: hardCodeData);
            } else {
              return _RoverGridInner(data: localUpdate);
            }
          } else {
            return Container();
          }
        });
  }
}
