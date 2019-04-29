import 'package:unofficial_gencon_mobile/app_state_model.dart';
import 'package:unofficial_gencon_mobile/database.dart';
import 'package:unofficial_gencon_mobile/views/eventmodelviews.dart';
import 'package:unofficial_gencon_mobile/models/eventmodel.dart';
import 'package:flutter/material.dart';

enum NavigationIconViewDetailType { mapsInfo, searchEvents, myLists }

class NavigationIconViewDetail {
  NavigationIconViewDetailType navigationIconViewDetailType;
  String title;
  NavigationIconViewDetail(this.navigationIconViewDetailType, this.title);
}

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    NavigationIconViewDetail navigationIconViewDetail,
    Color color,
    TickerProvider vsync,
    AppStateModel appStateModel
  }):
    _icon = icon,
    _navigationIconViewDetail = navigationIconViewDetail,
    _color = color,
    _title = navigationIconViewDetail.title,
    item = BottomNavigationBarItem(
      icon: icon,
      activeIcon: activeIcon,
      title: Text(navigationIconViewDetail.title),
      backgroundColor: color,
    ),
    controller = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: vsync,
    ) {
      _animation = controller.drive(CurveTween(
        curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ));
    }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  final NavigationIconViewDetail _navigationIconViewDetail;

  Animation<double> _animation;

  FadeTransition transition(
    BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
        ? themeData.primaryColor
        : themeData.accentColor;
    }

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: Semantics(
            label: 'Placeholder for $_title tab',
            //child: _icon,
            child: 
              _getCurrentContentPane()
          ),
        ),
      ),
    );
  }

  Widget _getCurrentContentPane() {
    switch(_navigationIconViewDetail.navigationIconViewDetailType) {
      case NavigationIconViewDetailType.mapsInfo:
        return Container();
        break;
      case NavigationIconViewDetailType.searchEvents:
        return _getSearchEvents();
        break;
      case NavigationIconViewDetailType.myLists:
        return Container();
        break;
    }

    return null;
  }

  Widget _getSearchEvents() {
    return FutureBuilder( 
      future: _getEvents(500),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
              child: Center(
            child: Text("Loading..."),
          ));
        } else {
          // TODO: replace this with a stateful widget containing search controls and a saved-place scroll in the list.
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return EventCompressedView(snapshot.data[index]);
            },
          );
        }
      },
    );
  }

  // this was an attempt to get a lazy-loading view of the compressed event views. It works, but it is super slow and poorly implemented.
  Widget _getSearchEvents_lazytest() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return EventCompressedLazyLoadView(queryOptions: QueryOptions(), index: index);
      },
    );
  }

  Future<List<EventModel>> _getEvents(numEvents) async {
    var db = await AppStateModel.database;
    return db.getEventModels(numEvents);
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomInactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
        margin: const EdgeInsets.all(4.0),
        width: iconTheme.size - 8.0,
        height: iconTheme.size - 8.0,
        decoration: BoxDecoration(
          border: Border.all(color: iconTheme.color, width: 2.0),
        ));
  }
}

class ConventionHome extends StatefulWidget {
  const ConventionHome({
    Key key,
    this.optionsPage,
  }) : super(key: key);

  final Widget optionsPage;
  static const String routeName = '/material/bottom_navigation';

  @override
  _ConventionHomeState createState() => _ConventionHomeState();
}

class _ConventionHomeState extends State<ConventionHome>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  Container persistentNotificationBar;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
          //activeIcon: const Icon(Icons.collections),
          icon: const Icon(Icons.map),
          navigationIconViewDetail: NavigationIconViewDetail(NavigationIconViewDetailType.mapsInfo, 'Maps/Info'),
          color: Colors.deepPurple,
          vsync: this),
      NavigationIconView(
          //activeIcon: CustomIcon(),
          icon: const Icon(Icons.search),
          navigationIconViewDetail: NavigationIconViewDetail(NavigationIconViewDetailType.searchEvents, 'Search Events'),
          color: Colors.deepOrange,
          vsync: this),
      NavigationIconView(
          activeIcon: const Icon(Icons.cloud),
          icon: const Icon(Icons.list),
          navigationIconViewDetail: NavigationIconViewDetail(NavigationIconViewDetailType.myLists, 'My Lists'),
          color: Colors.teal,
          vsync: this),
    ];

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(children: transitions,);
  }

  @override
  Widget build(BuildContext context) {
    // _appStateModel =
    //     ScopedModel.of<AppStateModel>(context, rebuildOnChange: true);

    persistentNotificationBar = Container(
      child: EventDownloaderView(),
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(3),
    );

    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>(
              (NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom navigation'),
        actions: <Widget>[
          // MaterialDemoDocumentationButton(ConventionHome.routeName),
          PopupMenuButton<BottomNavigationBarType>(
            onSelected: (BottomNavigationBarType value) {
              setState(() {
                _type = value;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuItem<BottomNavigationBarType>>[
                  const PopupMenuItem<BottomNavigationBarType>(
                    value: BottomNavigationBarType.fixed,
                    child: Text('Fixed'),
                  ),
                  const PopupMenuItem<BottomNavigationBarType>(
                    value: BottomNavigationBarType.shifting,
                    child: Text('Shifting'),
                  )
                ],
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Container(child: _buildTransitionsStack())),
          persistentNotificationBar
        ]
      ),
      bottomNavigationBar: botNavBar,
    );
  }
}
