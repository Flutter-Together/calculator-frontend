class Address {
  Address(
      this.roadAddr, this.oldAddr, this.pnu, this.isIndividualHouse, this.dong);

  String? roadAddr;
  String? oldAddr;
  int? pnu;
  int? isIndividualHouse;
  List? dong;

  Address.fromJson(Map<String, dynamic> parsedJson) {
    this.roadAddr = parsedJson['roadAddr'];
    this.oldAddr = parsedJson['oldAddr'];
    this.pnu = int.parse(parsedJson['pnu']);
    this.isIndividualHouse = int.parse(parsedJson['isIndividualHouse']);
    this.dong = parsedJson['dong'];
  }

// Map toJson() {
//   return {
//     'roadAddr': roadAddr,
//     'oldAddr': oldAddr,
//     'pnu': pnu,
//     'isIndividualHouse': isIndividualHouse,
//     'dong': dong,
//   };
// }
}
