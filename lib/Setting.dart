import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:mknews/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  late DropDownState dropDownState;
  late SharedPreferences sp;
  String country="";
  String? oldCountry;
  late List<SelectedListItem> countriesList;

  init() async {
    countriesList = [
      SelectedListItem(name: "Egypt", value: "eg"),
      SelectedListItem(name: "Argentina", value: "ar"),
      SelectedListItem(name: "Uae", value: "ae"),
      SelectedListItem(name: "Mexico", value: "mx"),
      SelectedListItem(name: "Morocco", value: "ma"),
      SelectedListItem(name: "Usa", value: "us")
    ];
    sp = await SharedPreferences.getInstance();
    String? code = sp.getString("country");
    country = countriesList
        .firstWhere((element) => element.value == code,
        orElse: () => countriesList[0])
        .name;
    oldCountry = country;
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
    dropDownState = DropDownState(
      DropDown(
        bottomSheetTitle: const Text(
          "Countries",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: [
          ...List.generate(
              countriesList.length, (index) => countriesList[index])
        ],
        selectedItems: (selectedItems) {
          country = selectedItems[0].name.toString();
          sp.setString("country", selectedItems[0].value.toString());
          setState(() {});
        },
        enableMultipleSelection: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.black,
            onPressed: () {
              if (oldCountry == country)
                Navigator.pop(context);
              else
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(),), (route) => false);
              },
          ),
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            InkWell(
              onTap: () {
                dropDownState.showModal(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.location_on, size: 25),
                  title: const Text("Country",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  trailing: Text(country),
                  minLeadingWidth: 10,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: const ListTile(
                leading: Icon(Icons.language, size: 25),
                title: Text("Language",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                trailing: Text("Arabic"),
                minLeadingWidth: 10,
              ),
            )
          ],
        ));
  }
}
