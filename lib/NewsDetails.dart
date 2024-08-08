import 'package:flutter/material.dart';
import 'package:mknews/ApiResponse.dart';
import 'package:mknews/Web.dart';

class NewsDetails extends StatefulWidget {
  Article article;

  NewsDetails(this.article, {super.key});

  @override
  State<NewsDetails> createState() {
    return DetailsState();
  }
}

class DetailsState extends State<NewsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.article.source!.name!,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  child: Text(
                widget.article.description!,
                maxLines: 5,
                style: TextStyle(fontSize: 20),
              )),
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 20),
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Text(
                          widget.article.publishedAt!,
                          style: TextStyle(fontSize: 15),
                        )),
                    Icon(Icons.create),
                    Text(
                      widget.article.author!,
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.article.urlToImage ?? "",
                    fit: BoxFit.fill,
                  )),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: MaterialButton(
                    color: Colors.blue,
                    minWidth: 40,
                    child: Text(
                      "Continue reading",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Web(
                                  widget.article.source!.name!,
                                  widget.article.url!)));
                    }),
              )
            ],
          ),
        ));
  }
}
