// Future<String> _findingAddressDialog(TextEditingController tc)async{
//   int searchStage = 0;
//
//   Widget _addressList(String keyword){
//     Address_API? pickedAddress;
//
//     Widget _selectAddressBox(Address_API address, int index){
//       Color backgrouundColor;
//       if(index.isEven){
//         backgrouundColor = Colors.white;
//       }else {backgrouundColor = Colors.black26;}
//
//       return GestureDetector(
//         onTap: (){
//           if(address.isIndividualHouse == '1'){
//             Navigator.pop(context, address.roadAddr);
//           }
//           else if(address.isIndividualHouse == '0' && address.dong.isNotEmpty && address.dong != ['']){
//             setState(() {
//               pickedAddress = address;
//               searchStage = 1;
//             });
//           }else{
//             setState(() {
//               searchStage = 2;
//             });
//           }
//         },
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
//           decoration: BoxDecoration(
//               color: backgrouundColor
//           ),
//           child: Column(
//             children: [
//               Text(address.roadAddr),
//               Text(address.oldAddr),
//             ],
//           ),
//         ),
//       );
//     }
//
//     if(searchStage == 0){
//       return Expanded(
//           child: FutureBuilder(
//               future: fetchAddressList(keyword),
//               builder: (context, snapshot){
//                 if(snapshot.connectionState == ConnectionState.waiting){
//                   return Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation(Color(mainColor)),
//                     ),
//                   );
//                 }else if(snapshot.hasError){
//                   return Center(child: Text(snapshot.error.toString()));
//                 }
//                 List<Address_API> res = snapshot.data as List<Address_API>;
//                 return ListView.builder(
//                   itemCount: res.length,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index){
//                     return _selectAddressBox(res[index],index);
//                   },
//                 );
//               }
//           )
//       );
//     }
//     else if(searchStage == 1){
//       return ListView.builder(
//           shrinkWrap: true,
//           itemCount: pickedAddress?.dong.length,
//           itemBuilder: (context, index){
//             Color backgrouundColor = index.isEven? Colors.white : Colors.black26;
//
//             return GestureDetector(
//               onTap: (){},
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
//                 decoration: BoxDecoration(color: backgrouundColor),
//                 child: Text(pickedAddress?.dong[index]),
//               ),
//             );
//           }
//       );
//     }
//     else {
//       return Container();
//     }
//   }
//
//   setState((){
//     _isSearchedAddress = false;
//   });
//   var res = await showDialog(
//       context: context,
//       builder: (BuildContext context){
//         return StatefulBuilder(
//             builder: (context, setState){
//               return AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(1),
//                   ),
//                   title: Text('주소검색'),
//                   content:Container(
//                     width: 600,
//                     constraints: const BoxConstraints(
//                       minHeight: 500,
//                       maxHeight: 800,
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: double.maxFinite,
//                           margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//                           child: TextField(
//                               controller: tc,
//                               autofocus: true,
//                               onSubmitted: (value){
//                                 setState((){
//                                   _isSearchedAddress = true;
//                                 });
//                               },
//                               cursorColor: Colors.black,
//                               textInputAction: TextInputAction.search,
//                               style: const TextStyle(fontSize: 17),
//                               decoration: InputDecoration(
//                                   hintText: '반포대로',
//                                   focusedBorder: _outlineInputBorder(),
//                                   enabledBorder: _outlineInputBorder(),
//                                   border: _outlineInputBorder(),
//                                   suffixIcon: Padding(
//                                     padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
//                                     child: IconButton(
//                                       icon: const Icon(Icons.search, size: 40),
//                                       color: Colors.black,
//                                       onPressed: () {
//                                         setState((){
//                                           _isSearchedAddress = true;
//                                         });
//                                       },
//                                     ),
//                                   )
//                               )
//                           ),
//                         ),
//                         _isSearchedAddress? _addressList(tc.text)
//                             : const Center(child: Text('검색어를 입력해주세요'),
//                         )
//                       ],
//                     ),
//                   )
//               );
//             }
//         );
//       }
//   );
//   return res;
// }
//
// Widget _textField1(TextEditingController tc, String labelText) {
//   return Expanded(
//       child: Container(
//         margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//         child: TextField(
//           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//           controller: tc,
//           cursorColor: Colors.black,
//           textInputAction: TextInputAction.search,
//           style: const TextStyle(fontSize: 17),
//           decoration: InputDecoration(
//             labelText: labelText,
//             labelStyle: const TextStyle(color: Colors.black),
//             focusedBorder: _outlineInputBorder(),
//             enabledBorder: _outlineInputBorder(),
//             border: _outlineInputBorder(),
//           ),
//         ),
//       ));
// }