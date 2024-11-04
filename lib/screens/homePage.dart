import 'package:contacts_manager/modal/contactModel.dart';
import 'package:contacts_manager/screens/addOrEditContactPage.dart';
import 'package:contacts_manager/screens/contactDetailPage.dart';
import 'package:contacts_manager/screens/profilePage.dart';
import 'package:contacts_manager/services/dbDatabase.dart';
import 'package:contacts_manager/utilis/assetImageConstant.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:contacts_manager/utilis/textConstants.dart';
import 'package:contacts_manager/widgets/appHeadings.dart';
import 'package:contacts_manager/widgets/appTextField.dart';
import 'package:contacts_manager/widgets/contactTileWidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  static const Widget horizDivider =
      Divider(thickness: 1, color: ColorConstants.appdivider);
  List<ContactModel>? contacts;
  DbDatabase _database = DbDatabase();
  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    contacts = await _database.contact();
    setState(() {});
  }

  bool isInList(int index) {
    return contacts![index].name.contains(searchValue) ||
        contacts![index].phoneNumber.contains(searchValue);
  }

  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appbg,
      body: Padding(
        padding: EdgeInsets.only(top: 30, left: 10, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppHeadings(text: TextConstants.mainHeading),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                AssetImageConstants().defaultProfile)),
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(255, 70, 70, 70)),
                  ),
                )
              ],
            ),
            searchBar(
              context,
            ),
            // expanded
            searchValue.isEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: contacts == null
                            ? 0
                            : contacts!
                                .length, // The number of items in the list
                        itemBuilder: (context, index) => Column(
                              children: [
                                ContactTileWidget(
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactDetailPage(
                                                    index: index,
                                                  )));
                                      getContacts();
                                    },
                                    image: contacts![index].image == null
                                        ? Image.asset(AssetImageConstants()
                                            .defaultProfile)
                                        : Image.memory(contacts![index].image!),
                                    name: contacts![index].name,
                                    number: contacts![index].phoneNumber),
                                horizDivider
                              ],
                            )))
                : Expanded(
                    child: contacts!.any(
                                (item) => item.name.contains(searchValue)) ||
                            contacts!.any((item) =>
                                item.phoneNumber.contains(searchValue))
                        ? ListView.builder(
                            itemCount: contacts == null
                                ? 0
                                : contacts!
                                    .length, // The number of items in the list
                            itemBuilder: (context, index) {
                              if (isInList(index)) {
                                return Column(
                                  children: [
                                    ContactTileWidget(
                                      onTap: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ContactDetailPage(
                                                      index: index,
                                                    )));
                                        getContacts();
                                      },
                                      image: contacts![index].image == null
                                          ? Image.asset(AssetImageConstants()
                                              .defaultProfile)
                                          : Image.memory(
                                              contacts![index].image!,
                                              fit: BoxFit.contain,
                                            ),
                                      name: contacts![index].name,
                                      number: contacts![index].phoneNumber,
                                    ),
                                    horizDivider
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            })
                        : Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No contact',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                      searchValue = '';
                                    });
                                  },
                                  child: const Text(
                                    'Exit',
                                    style: TextStyle(
                                        color: ColorConstants.appdark,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              ColorConstants.appmain),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)))),
                                )
                              ],
                            ),
                          ))
            //if continuation here
          ],
        ),
      ),
      floatingActionButton: floatingactionButton(),
    );
  }

  Widget floatingactionButton() {
    return Container(
      width: 70,
      height: 70,
      child: FloatingActionButton.extended(
        backgroundColor: ColorConstants.appmain,
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddOrEditContactPage()));
          getContacts();
        },
        label: Text(
          '+',
          style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.w200,
              color: ColorConstants.appdark),
        ),
        shape: CircleBorder(),
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      height: 45,
      decoration: BoxDecoration(
          color: ColorConstants.applight,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: ColorConstants.appmain,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: AppTextfield(
                onchange: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
                controller: searchController,
                hintText: 'search in contacts'),
          )
        ],
      ),
    );
  }
}
