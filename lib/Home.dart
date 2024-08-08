import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mknews/ApiResponse.dart';
import 'package:mknews/NewsDetails.dart';
import 'package:mknews/Web.dart';
import 'package:mknews/database/sqldb.dart';
import 'package:mknews/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mknews/Setting.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabBarController;
  var topHeadLinesArticlesList = <Article>[];
  var sportsArticlesList = <Article>[];
  var businessArticlesList = <Article>[];
  var online=true;


  init() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String? country = sharedPreferences.getString("country") ?? "eg";
        MyDatabase().deleteSavedArticles();
        getArticles(
            "https://newsapi.org/v2/top-headlines?country=$country&apiKey=c82acb2e60864a5dadf8b307afcbf31f",
            topHeadLinesArticlesList,"HeadlineArticles");
        getArticles(
            "https://newsapi.org/v2/top-headlines?category=sports&country=$country&apiKey=c82acb2e60864a5dadf8b307afcbf31f",
            sportsArticlesList,"SportsArticles");
        getArticles(
            "https://newsapi.org/v2/top-headlines?category=business&country=$country&apiKey=c82acb2e60864a5dadf8b307afcbf31f",
            businessArticlesList,"BusinessArticles");
      }
    } on SocketException catch (_) {
      online=false;
      getOfflineHeadlineArticles();
      getOfflineSportsArticles();
      getOfflineBusinessArticles();
    }


  }

  getArticles(String url, List<Article> articles,String tableName) async {
    var response = await get(Uri.parse(url));
    articles.addAll(ApiResponse.fromJson(json.decode(response.body)).articles!);
    MyDatabase().saveOfflineArticles(articles, tableName);
    setState(() {});
  }

  @override
  void initState() {
    tabBarController = TabController(length: 3, vsync: this);
    init();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              "images/logo.png",
              width: 100,
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
          PopupMenuButton(
              onOpened: () {},
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Settings()));
                }
                else {
                  FirebaseAuth.instance.signOut().then((value) =>Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Login())) );

                }
              },
              elevation: 3,
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 0,
                      child: Text("Settings"),
                    ),
                const PopupMenuItem(
                  value: 1,
                  child: Text("Sign out"),
                ),
                  ],
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ))
        ],
        bottom: TabBar(
          labelColor: const Color(0xFF7C0F21),
          unselectedLabelColor: const Color(0xff7B0F21),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          indicatorColor: const Color(0xFF7C0F21),
          tabs: const [
            Tab(
              text: "HEADLINES",
            ),
            Tab(
              text: "SPORTS",
            ),
            Tab(
              text: "BUSINESS",
            )
          ],
          controller: tabBarController,
        ),
      ),
      body: Container(
        color: Colors.blue[100],
        child: TabBarView(controller: tabBarController, children: [
          ...List.generate(3, (index) {
            var listToShow = index == 0
                ? topHeadLinesArticlesList
                : index == 1
                    ? sportsArticlesList
                    : businessArticlesList;
            return listToShow.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7C0F21)),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 3),
                    child: ListView(
                      children: [
                        ...List.generate(
                            listToShow.length,
                            (i) => InkWell(
                                  onTap: () {
                                    if (listToShow[i].description != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetails(listToShow[i]),
                                          ));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Web(
                                                listToShow[i].title!,
                                                listToShow[i].url!),
                                          ));
                                    }
                                  },
                                  child: Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 6),
                                                  child: Text(
                                                    listToShow[i]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                ),
                                                Text(
                                                  listToShow[i]
                                                      .title
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                  maxLines: 4,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 30.0),
                                                  child: Text(
                                                      listToShow[i]
                                                          .publishedAt
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 11)),
                                                )
                                              ],
                                            ),
                                          )),
                                            ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                child: listToShow[i].urlToImage ==
                                                    null||!online
                                                    ? Container(
                                                    width: 150,
                                                    color: Colors.grey)
                                                    :  Container(
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(listToShow[i].urlToImage!),
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),),
                                        ],
                                      ),
                                    ),
                                  )),
                                ))
                      ],
                    ),
                  );
          })
        ]),
      ),
    );
  }

  void getOfflineHeadlineArticles() async {
   List<Article> list= await MyDatabase().getOfflineArticles("HeadlineArticles");
    topHeadLinesArticlesList.addAll(list);
    setState(() {});
  }

  void getOfflineSportsArticles() async{
    List<Article> list= await MyDatabase().getOfflineArticles("SportsArticles");
    sportsArticlesList.addAll(list);
    setState(() {});
  }

  void getOfflineBusinessArticles() async{
    List<Article> list= await MyDatabase().getOfflineArticles("BusinessArticles");
    businessArticlesList.addAll(list);
    setState(() {});
  }
}
