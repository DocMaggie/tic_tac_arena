import 'package:flutter/material.dart';
import 'package:tic_tac_arena/api/get_games_api.dart';
import 'package:tic_tac_arena/api/logout_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/ui_components/form_title.dart';
import 'package:tic_tac_arena/ui_components/form_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<dynamic> games = [];

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  void getInitData() async {
    games = await getGames(Parameters(
      offset: 0,
      limit: 100
    ));
    print("Length: " + games.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Tic Tac Arena'),
          actions: <Widget>[
            Text(loggedInUser != null ? loggedInUser!.username : ''),
            Tooltip(
              message: 'Logout',
              child: IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext subcontext) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text('Are you sure you want to leave Tic Tac Arena?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(subcontext).pop();
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(subcontext).pop();
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext loggingOutContext) {
                                  return const AlertDialog(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Please wait...'),
                                      ]
                                    ),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[],
                                  );
                                },
                              );
                              await logout(context);
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.videogame_asset),
                text: 'Games'
              ),
              Tab(
                icon: Icon(Icons.account_box),
                text: 'Leaderboard'
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: games.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(games[index]['id'].toString()),
                    onTap: () {
                      // Handle item tap
                    },
                  );
                },
              ),
            ),
            Text('test 2')
          ],
        ),
      ),
    );

  }
}
