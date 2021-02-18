import 'package:fluam_app/util/StringUtil.dart';
import 'package:flutter/material.dart';

class AddSiteUI extends StatefulWidget {
  final bool firstSite;

  const AddSiteUI({Key key, this.firstSite = false}) : super(key: key);

  @override
  _AddSiteUIState createState() => _AddSiteUIState();
}

class _AddSiteUIState extends State<AddSiteUI> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      physics: NeverScrollableScrollPhysics(),
      children: [_AddSiteMainPage(widget.firstSite)],
    ));
  }
}

class _AddSiteMainPage extends StatefulWidget {
  final bool firstSite;

  const _AddSiteMainPage(this.firstSite, {Key key}) : super(key: key);

  @override
  _AddSiteMainPageState createState() => _AddSiteMainPageState();
}

class _AddSiteMainPageState extends State<_AddSiteMainPage> {
  int loadStatus = -1;
  TextEditingController urlTextController = TextEditingController();

  @override
  void initState() {
    urlTextController.text = "https://";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.firstSite
                ? "Welcome! Add Your First Flarum Site"
                : "Add Flarum Site",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .15,
                right: MediaQuery.of(context).size.width * .15,
                bottom: 40),
            child: TextFormField(
              enabled: loadStatus != 1,
              controller: urlTextController,
              decoration: InputDecoration(labelText: "URL (must use https)"),
              onChanged: (String text) {
                if (StringUtil.isHTTPSUrl(text)) {
                  if (loadStatus != 1 && loadStatus != 0) {
                    setState(() {
                      loadStatus = 0;
                    });
                  }
                } else {
                  if (loadStatus != 1 && loadStatus != -1) {
                    setState(() {
                      loadStatus = -1;
                    });
                  }
                }
              },
            ),
          ),
          SizedBox(
            height: 48,
            width: 48,
            child: Builder(
              builder: (BuildContext context) {
                if (loadStatus == 1) {
                  return FloatingActionButton(
                    backgroundColor: Colors.grey,
                    elevation: 3,
                    onPressed: null,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                } else {
                  return FloatingActionButton(
                    backgroundColor:
                        loadStatus == 0 ? Colors.blueAccent : Colors.grey,
                    elevation: 3,
                    onPressed: loadStatus == 0
                        ? () {
                            setState(() {
                              loadStatus = 1;
                            });

                            /// getting info
                          }
                        : null,
                    child: Icon(Icons.navigate_next),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
