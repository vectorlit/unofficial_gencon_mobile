import 'package:unofficial_gencon_mobile/database.dart';
import 'package:unofficial_gencon_mobile/models/eventmodel.dart';
import 'package:unofficial_gencon_mobile/network.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This is the standard compressed view for downloaded events.
class EventCompressedView extends StatelessWidget {
  final EventModel model;
  final DateFormat compressedFormat = DateFormat('EEE@HH:mm');
  final Color colorUnavailableTicketsBackground = Color.fromRGBO(160, 160, 160, 1);
  final Color colorAvailableTicketsBackground = ColorScheme.light().background;
  final Color colorRegularText = ColorScheme.light().onSurface;
  final Color colorUnavailableTicketsText = Color.fromRGBO(180, 30, 30, 1);

  EventCompressedView(this.model) : assert(model != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:EdgeInsets.fromLTRB(4, 4, 4, 0),
      color: model.availableTickets > 0 ? colorAvailableTicketsBackground : colorUnavailableTicketsBackground,
      child: InkWell(
        onTap: (){
          Route route = MaterialPageRoute(builder: (context) => EventFullView(model));
          Navigator.push(context, route);
        },
        child: Container(
          margin:EdgeInsets.fromLTRB(5, 3, 5, 3),
          child: Column(
            children: <Widget>[
              Stack(
                children:[
                  Row( 
                    children: <Widget>[
                      Expanded(
                        child: 
                            Text(model.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                              overflow: TextOverflow.ellipsis,
                              ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Text(
                          "\$${model.cost}", 
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(20, 230, 20, 1),
                          ),
                        ),
                        flex: 2
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Text>[
                      Text("Avail:",
                          style: TextStyle(
                            fontSize: 18
                          ),),
                      Text("${model.availableTickets}",
                          style: TextStyle(
                            fontSize: 18,
                            color: model.availableTickets > 0 ? colorRegularText : colorUnavailableTicketsText,
                          ),)
                    ]
                  ),
                ]
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          model.description,
                          overflow: TextOverflow.ellipsis,
                          style:TextStyle(
                            fontSize: 14
                          )
                        ),
                      ]
                    ),
                  ),
                  Text("${compressedFormat.format(model.startDateTime)}(${(model.endDateTime.difference(model.startDateTime)).inHours}hrs)",
                          style: TextStyle(
                            fontSize: 16
                          ),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // _CompressedEventViewState createState() => _CompressedEventViewState();
}

// This is the standard expanded (full) view for downloaded events.
class EventFullView extends StatelessWidget {
  final EventModel model;
  
  final Color colorLinkText = Color.fromRGBO(30, 30, 210, 1);
  final DateFormat compressedFormat = DateFormat('EEE@HH:mm');

  EventFullView(this.model);

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(model.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), flex: 2),
                Expanded(child: Text("Avl. Tickets: ${model.availableTickets}", style: TextStyle(fontSize: 14), textAlign: TextAlign.right), flex: 1)
              ],
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("${model.groupCompany}", style: TextStyle(fontSize: 14)), flex: 2),
                  Expanded(child: Text("${model.minimumPlayers}-${model.maximumPlayers} Players", style: TextStyle(fontSize: 14), textAlign: TextAlign.right), flex: 2),
                ]
              ),
              margin: EdgeInsets.fromLTRB(5, 4, 0, 0),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // flutterWebviewPlugin.launch(
                            //   model.liveURL
                            // );
                            var route = PageRouteBuilder( 
                              pageBuilder: (_, __, ___) => WebviewScaffold(
                                  url: model.liveURL,
                                  appBar: AppBar(title: Text(model.title)
                                ),
                              )
                            );
                            Navigator.push(context, route);
                          },
                          child: Text(model.id, style: TextStyle(color: colorLinkText)))
                      ]
                    ), 
                    flex: 2
                  ),
                  Expanded(child: Text(model.minimumAge, textAlign: TextAlign.right,), flex: 1)
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(model.eventType), flex: 2),
                  Expanded(child: Text("\$${model.cost}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.right,), flex: 1)
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text("${compressedFormat.format(model.startDateTime)}(${(model.endDateTime.difference(model.startDateTime)).inHours}hrs)"),
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Text(model.location)
                ],
              ),
              margin: EdgeInsets.fromLTRB(5, 4, 0, 0),
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Text("Description:", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            Container(
              child: Text(model.description),
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Text("Long Description:", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            Container(
              child: Text(model.longDescription),
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            ),


            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("Game System:", style: TextStyle(fontWeight: FontWeight.bold)), flex: 1),
                  Expanded(child: Text("Rules Edition:", style: TextStyle(fontWeight: FontWeight.bold)), flex: 1)
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            Row(
              children: <Widget>[
                Expanded(child: Padding(child: Text(model.gameSystem), padding: EdgeInsets.fromLTRB(5, 0, 0, 0),), flex: 1),
                Expanded(child: Padding(child: Text(model.rulesEdition), padding: EdgeInsets.fromLTRB(5, 0, 0, 0)), flex: 1),
              ]
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("Experience Required:", style: TextStyle(fontWeight: FontWeight.bold)), flex: 1),
                  Expanded(child: Text("Materials Provided:", style: TextStyle(fontWeight: FontWeight.bold)), flex: 1)
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            Row(
              children: <Widget>[
                Expanded(child: Padding(child: Text(model.experienceRequired), padding: EdgeInsets.fromLTRB(5, 0, 0, 0),), flex: 1),
                Expanded(child: Padding(child: Text(model.materialsProvided), padding: EdgeInsets.fromLTRB(5, 0, 0, 0)), flex: 1),
              ]
            ),


            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text("Tournament:", style: TextStyle(fontWeight: FontWeight.bold)), flex: 1),
                  Expanded(child: Text("GM(s):", style: TextStyle(fontWeight: FontWeight.bold)), flex: 1)
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            Row(
              children: <Widget>[
                Expanded(child: Padding(child: Text(model.tournament), padding: EdgeInsets.fromLTRB(5, 0, 0, 0),), flex: 1),
                Expanded(child: Padding(child: Text(model.gms), padding: EdgeInsets.fromLTRB(5, 0, 0, 0)), flex: 1),
              ]
            ),


            Container(
              child: Row(
                children: <Widget>[
                  Text("Prerequisite:", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            Container(
              child: Text(model.prerequisite),
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            ),


            Container(
              child: Row(
                children: <Widget>[
                  Text("Web Address For More Info:", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            Container(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // flutterWebviewPlugin.launch(
                      //   model.liveURL
                      // );
                      var route = PageRouteBuilder( 
                        pageBuilder: (_, __, ___) => WebviewScaffold(
                            url: model.webAddressMoreInfo.startsWith("https") ? model.webAddressMoreInfo : "https://${model.webAddressMoreInfo}",
                            appBar: AppBar(title: Text(model.webAddressMoreInfo)
                          ),
                        )
                      );
                      Navigator.push(context, route);
                    },
                    child: Text(model.webAddressMoreInfo, style: TextStyle(color: colorLinkText)))
                ]
              ), 
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            ),


            Container(
              child: Row(
                children: <Widget>[
                  Text("Email Address For More Info:", style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              margin: EdgeInsets.fromLTRB(0, 4, 0, 0), 
            ),

            // TODO: FIX THIS. Email cannot launch properly. Need to launch an intent instead of a web address
            Container(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // flutterWebviewPlugin.launch(
                      //   model.liveURL
                      // );
                      var route = PageRouteBuilder( 
                        pageBuilder: (_, __, ___) => WebviewScaffold(
                            url: "mailto:${model.emailAddressMoreInfo}",
                            appBar: AppBar(title: Text(model.emailAddressMoreInfo)
                          ),
                        )
                      );
                      Navigator.push(context, route);
                    },
                    child: Text(model.emailAddressMoreInfo, style: TextStyle(color: colorLinkText)))
                ]
              ), 
              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            ),

            Container(
              child: Text(
                "Last updated: ${model.syncTime}\nIf this date is old, it could mean the event has simply not changed since then (no one has purchased tickets, etc)",
                style: TextStyle(fontStyle: FontStyle.italic)
              ),
              margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

// This is the downloader view for events. Consider splitting into a separate file.
class EventDownloaderView extends StatefulWidget {
  final DateTime startDate;

  EventDownloaderView({Key key, this.startDate}) : super(key: key);

  @override
  _EventDownloaderViewState createState() => _EventDownloaderViewState();
}

class _EventDownloaderViewState extends State<EventDownloaderView> {
  Future _getAllEventsAfterDate() async {
    // ConventionDatabase database = ConventionDatabase();
    var lastSyncTime = await ConventionDatabase.db.awaitCurrentStartDateTime;
    var networkStream = Network.getEventsAfterDate(lastSyncTime);

    networkStream.listen((data) {
      _updateProgressView(data);
    }).onDone(() {
      _isHidden = true;
    });

    // print("Network stream await for starting: ");
    // await for (var chunk in networkStream) {
    //   setState(() { 
    //     _maxCount = chunk.maxNumberOfEvents; 
    //     _progressCount += chunk.events.length; 
    //   });
    // }
    // print("Network stream await for ended.");
  }

  void _updateProgressView(EventCommitInfoModel data) {
    setState(() {
      _maxCount = data.maxNumberOfEvents; 
      _progressCount += data.currentNumberOfEvents; 
    });
  }

  int _maxCount = 0;
  int _progressCount = 0;
  bool _isHidden = false;

  Widget _buildProgressIndicator() {
    if (_isHidden) {
      return Container(height:0);
    }
    if (_maxCount > 0) {    
      return Column(children: <Widget>[
        Text('Downloading events: $_progressCount/$_maxCount'),
        LinearProgressIndicator(value: _progressCount / _maxCount)
      ],);
    } else {
      return Text('Downloading events...');
    }
  }

  @override
  void initState() {
    // AppStateModel.database.then((db) async {
      _getAllEventsAfterDate();
      super.initState();
    // }) ;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProgressIndicator();
  }
}



// This is the async lazy-load view of the compressed event view. It works but is slow and poorly implemented.
// Consider deleting or rewrite if possible.
class EventCompressedLazyLoadView extends StatefulWidget {
  final QueryOptions queryOptions;
  final int index;

  EventCompressedLazyLoadView({Key key, this.queryOptions, this.index}) : super(key: key);

  @override
  _EventCompressedLazyLoadViewState createState() => _EventCompressedLazyLoadViewState(queryOptions, index);
}

class _EventCompressedLazyLoadViewState extends State<EventCompressedLazyLoadView> {
  @override
  void initState() {
    // AppStateModel.database.then((db) async {
      _updateModel();
      super.initState();
    // }) ;
  }

  _EventCompressedLazyLoadViewState(this.queryOptions, this.index);

  void _updateModel() async {
    var passModel = await ConventionDatabase.db.getEventModel(index);
    if (mounted) {
      setState(() {
        model = passModel;
      });
    }
  }

  final DateFormat compressedFormat = DateFormat('EEE@HH:mm');
  final Color colorUnavailableTicketsBackground = Color.fromRGBO(160, 160, 160, 1);
  final Color colorAvailableTicketsBackground = ColorScheme.light().background;
  final Color colorRegularText = ColorScheme.light().onSurface;
  final Color colorUnavailableTicketsText = Color.fromRGBO(180, 30, 30, 1);
  final QueryOptions queryOptions;
  final int index;
  EventModel model;

  Widget _buildCompressedEventView() {
    if (model == null) {
      return Card(
        margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
        child: Center(
          child: CircularProgressIndicator(),
        ));
    } 
    else { 
      return Card(
        margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
        color: model.availableTickets > 0 ? colorAvailableTicketsBackground : colorUnavailableTicketsBackground,
        child: InkWell (
          onTap: (){
            Route route = MaterialPageRoute(builder: (context) => EventFullView(model));
            Navigator.push(context, route);
          },
          child: Container(
            margin:EdgeInsets.fromLTRB(5, 3, 5, 3),
            child: Column(
              children: <Widget>[
                Stack(
                  children:[
                    Row( 
                      children: <Widget>[
                        Expanded(
                          child: 
                              Text(model.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                                overflow: TextOverflow.ellipsis,
                                ),
                          flex: 4,
                        ),
                        Expanded(
                          child: Text(
                            "\$${model.cost}", 
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromRGBO(20, 230, 20, 1),
                            ),
                          ),
                          flex: 2
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Text>[
                        Text("Avail:",
                            style: TextStyle(
                              fontSize: 18
                            ),),
                        Text("${model.availableTickets}",
                            style: TextStyle(
                              fontSize: 18,
                              color: model.availableTickets > 0 ? colorRegularText : colorUnavailableTicketsText,
                            ),)
                      ]
                    ),
                  ]
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            model.description,
                            overflow: TextOverflow.ellipsis,
                            style:TextStyle(
                              fontSize: 14
                            )
                          ),
                        ]
                      ),
                    ),
                    Text("${compressedFormat.format(model.startDateTime)}(${(model.endDateTime.difference(model.startDateTime)).inHours}hrs)",
                            style: TextStyle(
                              fontSize: 16
                            ),)
                  ],
                ),
              ],
            ),
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCompressedEventView();
  }
}