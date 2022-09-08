class Address {
  Address(this.roadAddr, this.oldAddr, this.pnu, this.isIndividualHouse,
      this.dong_list);

  String? roadAddr;
  String? oldAddr;
  String? pnu;
  int? isIndividualHouse;
  List? dong_list;

  Address.fromJson(Map<String, dynamic> parsedJson) {
    this.roadAddr = parsedJson['roadAddr'];
    this.oldAddr = parsedJson['oldAddr'];
    this.pnu = parsedJson['pnu'];
    this.isIndividualHouse = int.parse(parsedJson['isIndividualHouse']);
    this.dong_list = parsedJson['dong'];
  }

  Map toJson() {
    return {
      'roadAddr': roadAddr,
      'oldAddr': oldAddr,
      'pnu': pnu,
      'isIndividualHouse': isIndividualHouse,
      'dong_list': dong_list,
    };
  }

}
