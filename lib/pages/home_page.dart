import 'package:flutter/material.dart';
import 'package:tic_tac_arena/api/create_new_game_api.dart';
import 'package:tic_tac_arena/api/get_game_by_id_api.dart';
import 'package:tic_tac_arena/api/get_games_api.dart';
import 'package:tic_tac_arena/api/get_users_api.dart';
import 'package:tic_tac_arena/api/join_game_api.dart';
import 'package:tic_tac_arena/api/logout_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/models/game_status.dart';
import 'package:tic_tac_arena/models/user.dart';
import 'package:tic_tac_arena/pages/user_details_page.dart';
import 'package:tic_tac_arena/ui_components/form_title.dart';
import 'package:tic_tac_arena/ui_components/form_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<dynamic> games = [];
  List<dynamic> users = [];

  String selectedDropdownOptionDisplayedText = 'All';
  String selectedDropdownOptionValue = '';

  bool loadingGames = false;
  bool loadingUsers = false;

  TextStyle regularFont = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
    decoration: TextDecoration.none
  );
  TextStyle boldFont = const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decoration: TextDecoration.none
  );

  @override
  void initState() {
    super.initState();
    getGamesRef(null);
    getUsersRef(null);
  }

  void getGamesRef(String? directUrl) async {
    loadingGames = true;
    setState(() {});
    games = await getGames(GamesParameters(
      offset: 0,
      limit: 10,
      status: selectedDropdownOptionValue
    ), directUrl);
    loadingGames = false;
    setState(() {});
  }

  void getUsersRef(String? directUrl) async {
    loadingUsers = true;
    setState(() {});
    users = await getUsers(UsersParameters(
      offset: 0,
      limit: 10
    ), directUrl);
    loadingUsers = false;
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
          title: const Text('Tic Tac Arena'),
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
                            child: const Text('No'),
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
                            child: const Text('Yes'),
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  DropdownButton<String>(
                                    iconSize: 30.0,
                                    value: selectedDropdownOptionDisplayedText,
                                    items: gameStatuses.map<DropdownMenuItem<String>>(
                                      (GameStatus gameStatus) {
                                        return DropdownMenuItem(
                                          value: gameStatus.displayedText,
                                          child: Text(gameStatus.displayedText),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDropdownOptionDisplayedText = value!;
                                        selectedDropdownOptionValue = gameStatuses.firstWhere((element) => element.displayedText == value).value;
                                        getGamesRef(null);
                                      });
                                    }
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SizedBox(
                                      height: 25.0,
                                      width: 25.0,
                                      child: loadingGames ? const CircularProgressIndicator() : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Tooltip(
                                      message: 'Refresh games',
                                      child: IconButton(
                                        onPressed: () async {
                                          getGamesRef(null);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            Theme.of(context).colorScheme.inversePrimary
                                          ),
                                        ),
                                        icon: const Icon(Icons.refresh)
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'New game',
                                    child: IconButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext subcontext) {
                                            return AlertDialog(
                                              title: const Text('New game'),
                                              content: const Text('Would you like to create a new lobby?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(subcontext).pop();
                                                  },
                                                  child: const Text('No'),
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
                                                              Text('Creating new lobby...'),
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
                                                    viewedGame = Game.fromJson(await createNewGame());
                                                    Navigator.of(context).pushNamed('/game');
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          Theme.of(context).colorScheme.inversePrimary
                                        ),
                                      ),
                                      icon: const Icon(Icons.add)
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Tooltip(
                                message: 'Previous page' + (gamesPreviousLink != null ? '' : ' (no previous page)'),
                                child: IconButton(
                                  onPressed: gamesPreviousLink != null && !loadingGames ? () async {
                                    getGamesRef(gamesPreviousLink);
                                  } : null,
                                  icon: const Icon(Icons.arrow_back)
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text.rich(
                                      TextSpan(
                                        text: '',
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(text: 'Showing games ', style: regularFont),
                                          TextSpan(text: (gameItemsFrom != null ? gameItemsFrom.toString() : ''), style: boldFont),
                                          TextSpan(text: ' to ', style: regularFont),
                                          TextSpan(text: (gameItemsTo != null ? gameItemsTo.toString() : ''), style: boldFont),
                                          TextSpan(text: ' of ', style: regularFont),
                                          TextSpan(text: (gameCount != null ? gameCount.toString() : ''), style: boldFont)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Tooltip(
                                message: 'Next page' + (gamesNextLink != null ? '' : ' (no next page)'),
                                child: IconButton(
                                  onPressed: gamesNextLink != null && !loadingGames ? () async {
                                    getGamesRef(gamesNextLink);
                                  } : null,
                                  icon: const Icon(Icons.arrow_forward)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: games.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Icon(Icons.videogame_asset),
                                title: Text(
                                  games[index]['first_player']['username'] +
                                  ' vs. ' +
                                  (games[index]['second_player'] != null ? games[index]['second_player']['username'] : '?')
                                ),
                                dense: true,
                                isThreeLine: true,
                                subtitle: Text(
                                  gameStatuses.firstWhere((element) => games[index]['status'] == element.value).displayedText,
                                  style: TextStyle(
                                    color: gameStatuses.firstWhere((element) => games[index]['status'] == element.value).statusColor,
                                  ),
                                ),
                                trailing: Text('Game ID: ${games[index]['id']}'),
                                onTap: () {
                                  if (games[index]['status'] == 'open' && games[index]['first_player']['id'] != loggedInUser!.id) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext subcontext) {
                                        return AlertDialog(
                                          title: const Text('Confirmation'),
                                          content: const Text('Would you like to join as second player?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(subcontext).pop();
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                joinGame(games[index]['id']);
                                                getGameById(games[index]['id']);
                                                viewedGame = Game.fromJson(await getGameById(games[index]['id']));
                                                Navigator.of(context).pushNamed('/game');
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    viewedGame = Game.fromJson(games[index]);
                                    Navigator.of(context).pushNamed('/game');
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  height: 25.0,
                                  width: 25.0,
                                  child: loadingUsers ? const CircularProgressIndicator() : null,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Tooltip(
                                  message: 'Refresh users',
                                  child: IconButton(
                                    onPressed: () async {
                                      getUsersRef(null);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.inversePrimary
                                      ),
                                    ),
                                    icon: const Icon(Icons.refresh)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Tooltip(
                                message: 'Previous page' + (usersPreviousLink != null ? '' : ' (no previous page)'),
                                child: IconButton(
                                  onPressed: usersPreviousLink != null && !loadingUsers ? () async {
                                    getUsersRef(usersPreviousLink);
                                  } : null,
                                  icon: const Icon(Icons.arrow_back)
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text.rich(
                                      TextSpan(
                                        text: '',
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(text: 'Showing users ', style: regularFont),
                                          TextSpan(text: (userItemsFrom != null ? userItemsFrom.toString() : ''), style: boldFont),
                                          TextSpan(text: ' to ', style: regularFont),
                                          TextSpan(text: (userItemsTo != null ? userItemsTo.toString() : ''), style: boldFont),
                                          TextSpan(text: ' of ', style: regularFont),
                                          TextSpan(text: (userCount != null ? userCount.toString() : ''), style: boldFont)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Tooltip(
                                message: 'Next page' + (usersNextLink != null ? '' : ' (no next page)'),
                                child: IconButton(
                                  onPressed: usersNextLink != null && !loadingUsers ? () async {
                                    getUsersRef(usersNextLink);
                                  } : null,
                                  icon: const Icon(Icons.arrow_forward)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: Text.rich(
                                  TextSpan(
                                    text: '',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: users[index]['username'], style: boldFont),
                                      TextSpan(text: ' (ID: ' + users[index]['id'].toString() + ')', style: regularFont)
                                    ],
                                  ),
                                ),
                                dense: true,
                                isThreeLine: true,
                                subtitle: Text.rich(
                                  TextSpan(
                                    text: '',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: 'Winrate: ', style: regularFont),
                                      TextSpan(text: (users[index]['win_rate'] * 100).toStringAsFixed(2) + '%', style: boldFont)
                                    ],
                                  ),
                                ),
                                trailing: Text.rich(
                                  TextSpan(
                                    text: '',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: 'Total games: ', style: regularFont),
                                      TextSpan(text: users[index]['game_count'].toString(), style: boldFont)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    UserDetailsPage.routeName,
                                    arguments: User(
                                      id: users[index]['id'],
                                      username: users[index]['username'],
                                      gameCount: users[index]['game_count'],
                                      winRate: users[index]['win_rate']
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
