class TextConstants {
  static const String mainHeading = 'My\nContacts';
  static const String addPageHeading = 'Add new contact';
  static const String updatePageHeading = 'Update contact';
}


  // Expanded(
  //               child: ListView.builder(
  //                   itemCount: contacts == null
  //                       ? 0
  //                       : contacts!.length, // The number of items in the list
  //                   itemBuilder: (context, index) => Column(
  //                         children: [
  //                           ContactTileWidget(
  //                               onTap: () async {
  //                                 await Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                         builder: (context) =>
  //                                             ContactDetailPage(
  //                                               index: index,
  //                                             )));
  //                                 getContacts();
  //                               },
  //                               image: contacts![index].image == null
  //                                   ? Image.asset(
  //                                       AssetImageConstants().defaultProfile)
  //                                   : Image.memory(contacts![index].image!),
  //                               name: contacts![index].name,
  //                               number: contacts![index].phoneNumber),
  //                           horizDivider
  //                         ],
  //                       )))