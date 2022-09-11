import 'package:badges/badges.dart';
import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:calculator_frontend/widgets/MediumText.dart';
import 'package:calculator_frontend/widgets/Search_Address.dart';
import 'package:flutter/material.dart';

class Resume_HoldingTaxPage extends StatefulWidget {
  const Resume_HoldingTaxPage({Key? key}) : super(key: key);

  @override
  State<Resume_HoldingTaxPage> createState() => _Resume_HoldingTaxPageState();
}

class _Resume_HoldingTaxPageState extends State<Resume_HoldingTaxPage> {
  final List select_num_of_house = ['1세대 1주택', '1세대 2주택', '1세대 3주택 이상'];
  final List num_of_house = ['1', '2', '3+'];
  List<bool> _is_selected_num_of_house = [false, false, false];
  final List select_holdig_period = ['5년 미만', '5년 이상', '10년 이상', '15년 이상'];
  List<bool> _is_selected_holding_period = [false, false, false, false];
  final List select_age = ['60세 미만', '60세 이상', '65세 이상', '70세 이상'];
  List<bool> _is_selected_owner_1 = [false, false, false, false, false];
  List<bool> _is_selected_owner_2 = [false, false, false, false, false];
  List<bool> _is_selected_owner_3 = [false, false, false, false, false];
  List<bool> _is_selected_owner_4 = [false, false, false, false, false];
  List<bool> _is_selected_owner_5 = [false, false, false, false, false];
  final List select_owner = [
    '본인',
    '가족 구성원 A',
    '가족 구성원 B',
    '가족 구성원 C',
    '가족 구성원 D'
  ];
  List<bool> _is_selected_age = [false, false, false, false];
  final Color mainColor = Color(0xff80cfd5);
  int stage1 = 0;
  int stage2 = 0;
  int stage3 = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stage1 = 0;
    stage2 = 0;
    stage3 = 0;
  }

  @override
  Widget build(BuildContext context) {
    int index_selected =
        _is_selected_num_of_house.indexWhere((element) => element == true);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 40, bottom: 20),
                  child: LargeText(
                    text: '보유세 통합 계산',
                    size: 25,
                  ),
                ),
                Diver_Title(),
                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Selected_num_of_house(),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index_selected >= 1
                                ? Column(
                                    children: [
                                      Label('주소'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      LabelwithBadge_2('소유주'),
                                    ],
                                  )
                                : Label('주소'),
                            index_selected >= 1
                                ? SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [Text('주소1'), Search_Address(stage: stage1,)],
                                  ),
                            index_selected == 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [Text('주소1'), Search_Address(stage: stage2,)],
                                  )
                                : SizedBox(),
                            index_selected == 2
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [Text('주소1'), Search_Address(stage: stage3,)],
                                  )
                                : SizedBox(),
                          ],
                        ),
                        index_selected == 1
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Owenr_Row(1),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('주소2'),
                                          Search_Address(stage: stage1,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Owenr_Row(2),
                                ],
                              )
                            : SizedBox(),
                        index_selected == 2
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Owenr_Row(1),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('주소2'),
                                          Search_Address(stage: stage3,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Owenr_Row(2),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('주소3'),
                                          Search_Address(stage: stage3,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Owenr_Row(3),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('주소4'),
                                          Search_Address(stage: stage3,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Owenr_Row(4),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('주소5'),
                                          Search_Address(stage: stage3,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Owenr_Row(5),
                                ],
                              )
                            : SizedBox(),
                        const SizedBox(
                          height: 40,
                        ),
                        index_selected >= 1
                            ? SizedBox()
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      LabelwithBadge_1('보유기간'),
                                      CheckBox_holding_period(0),
                                      CheckBox_holding_period(1),
                                      CheckBox_holding_period(2),
                                      CheckBox_holding_period(3),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  Row(
                                    children: [
                                      LabelwithBadge_1('연령입력'),
                                      CheckBox_age(0),
                                      CheckBox_age(1),
                                      CheckBox_age(2),
                                      CheckBox_age(3),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: mainColor, minimumSize: Size(500, 50)),
                          onPressed: () {},
                          child: const Text(
                            '계산하기',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Owenr_Row(int idx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 120),
          child: Text('소유주$idx'),
        ),
        const SizedBox(
          height: 5,
        ),
        idx == 1
            ? Row(
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  CheckBox_owner_1(0),
                  CheckBox_owner_1(1),
                  CheckBox_owner_1(2),
                  CheckBox_owner_1(3),
                  CheckBox_owner_1(4)
                ],
              )
            : SizedBox(),
        idx == 2
            ? Row(
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  CheckBox_owner_2(0),
                  CheckBox_owner_2(1),
                  CheckBox_owner_2(2),
                  CheckBox_owner_2(3),
                  CheckBox_owner_2(4)
                ],
              )
            : SizedBox(),
        idx == 3
            ? Row(
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  CheckBox_owner_3(0),
                  CheckBox_owner_3(1),
                  CheckBox_owner_3(2),
                  CheckBox_owner_3(3),
                  CheckBox_owner_3(4)
                ],
              )
            : SizedBox(),
        idx == 4
            ? Row(
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  CheckBox_owner_4(0),
                  CheckBox_owner_4(1),
                  CheckBox_owner_4(2),
                  CheckBox_owner_4(3),
                  CheckBox_owner_4(4)
                ],
              )
            : SizedBox(),
        idx == 5
            ? Row(
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  CheckBox_owner_5(0),
                  CheckBox_owner_5(1),
                  CheckBox_owner_5(2),
                  CheckBox_owner_5(3),
                  CheckBox_owner_5(4)
                ],
              )
            : SizedBox(),
      ],
    );
  }

  SizedBox CheckBox_owner_1(int idx) {
    int count_selected_owner =
        _is_selected_owner_1.where((element) => element == true).length;
    int index_selected_owner =
        _is_selected_owner_1.indexWhere((element) => element == true);
    return SizedBox(
      width: idx == 0 ? 70 : 175,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                side: BorderSide(width: 1, color: mainColor),
                checkColor: Colors.white,
                activeColor: mainColor,
                value: _is_selected_owner_1[idx],
                onChanged: (bool? value) {
                  setState(() {
                    if (count_selected_owner == 0) {
                      _is_selected_owner_1[idx] = value!;
                    } else if (count_selected_owner == 1) {
                      if (index_selected_owner == idx) {
                        _is_selected_owner_1[idx] = !_is_selected_owner_1[idx];
                      }
                    }
                  });
                }),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            select_owner[idx],
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }

  SizedBox CheckBox_owner_2(int idx) {
    int count_selected_owner =
        _is_selected_owner_2.where((element) => element == true).length;
    int index_selected_owner =
        _is_selected_owner_2.indexWhere((element) => element == true);
    return SizedBox(
      width: idx == 0 ? 70 : 175,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                side: BorderSide(width: 1, color: mainColor),
                checkColor: Colors.white,
                activeColor: mainColor,
                value: _is_selected_owner_2[idx],
                onChanged: (bool? value) {
                  setState(() {
                    if (count_selected_owner == 0) {
                      _is_selected_owner_2[idx] = value!;
                    } else if (count_selected_owner == 1) {
                      if (index_selected_owner == idx) {
                        _is_selected_owner_2[idx] = !_is_selected_owner_2[idx];
                      }
                    }
                  });
                }),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            select_owner[idx],
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }

  SizedBox CheckBox_owner_3(int idx) {
    int count_selected_owner =
        _is_selected_owner_3.where((element) => element == true).length;
    int index_selected_owner =
        _is_selected_owner_3.indexWhere((element) => element == true);
    return SizedBox(
      width: idx == 0 ? 70 : 175,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                side: BorderSide(width: 1, color: mainColor),
                checkColor: Colors.white,
                activeColor: mainColor,
                value: _is_selected_owner_3[idx],
                onChanged: (bool? value) {
                  setState(() {
                    if (count_selected_owner == 0) {
                      _is_selected_owner_3[idx] = value!;
                    } else if (count_selected_owner == 1) {
                      if (index_selected_owner == idx) {
                        _is_selected_owner_3[idx] = !_is_selected_owner_3[idx];
                      }
                    }
                  });
                }),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            select_owner[idx],
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }

  SizedBox CheckBox_owner_4(int idx) {
    int count_selected_owner =
        _is_selected_owner_4.where((element) => element == true).length;
    int index_selected_owner =
        _is_selected_owner_4.indexWhere((element) => element == true);
    return SizedBox(
      width: idx == 0 ? 70 : 175,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                side: BorderSide(width: 1, color: mainColor),
                checkColor: Colors.white,
                activeColor: mainColor,
                value: _is_selected_owner_4[idx],
                onChanged: (bool? value) {
                  setState(() {
                    if (count_selected_owner == 0) {
                      _is_selected_owner_4[idx] = value!;
                    } else if (count_selected_owner == 1) {
                      if (index_selected_owner == idx) {
                        _is_selected_owner_4[idx] = !_is_selected_owner_4[idx];
                      }
                    }
                  });
                }),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            select_owner[idx],
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }

  SizedBox CheckBox_owner_5(int idx) {
    int count_selected_owner =
        _is_selected_owner_5.where((element) => element == true).length;
    int index_selected_owner =
        _is_selected_owner_5.indexWhere((element) => element == true);
    return SizedBox(
      width: idx == 0 ? 70 : 175,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                side: BorderSide(width: 1, color: mainColor),
                checkColor: Colors.white,
                activeColor: mainColor,
                value: _is_selected_owner_5[idx],
                onChanged: (bool? value) {
                  setState(() {
                    if (count_selected_owner == 0) {
                      _is_selected_owner_5[idx] = value!;
                    } else if (count_selected_owner == 1) {
                      if (index_selected_owner == idx) {
                        _is_selected_owner_5[idx] = !_is_selected_owner_5[idx];
                      }
                    }
                  });
                }),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            select_owner[idx],
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }

  SizedBox CheckBox_age(int idx) {
    int count_selected_age =
        _is_selected_age.where((element) => element == true).length;
    int index_selected_age =
        _is_selected_age.indexWhere((element) => element == true);
    return SizedBox(
      width: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                side: BorderSide(width: 1, color: mainColor),
                checkColor: Colors.white,
                activeColor: mainColor,
                value: _is_selected_age[idx],
                onChanged: (bool? value) {
                  setState(() {
                    if (count_selected_age == 0) {
                      _is_selected_age[idx] = value!;
                    } else if (count_selected_age == 1) {
                      if (index_selected_age == idx) {
                        _is_selected_age[idx] = !_is_selected_age[idx];
                      }
                    }
                  });
                }),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            select_age[idx],
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }

  SizedBox CheckBox_holding_period(int idx) {
    int count_selected_holding_period =
        _is_selected_holding_period.where((element) => element == true).length;
    int index_selected_holding_period =
        _is_selected_holding_period.indexWhere((element) => element == true);
    return SizedBox(
      width: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Theme(
            data: ThemeData(accentColor: Colors.black26),
            child: Transform.scale(
                scale: 1.1,
                child: Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    side: BorderSide(
                        width: 1,
                        color: stage1 == 2 ? mainColor : Colors.black26),
                    checkColor: Colors.white,
                    activeColor: mainColor,
                    value: _is_selected_holding_period[idx],
                    onChanged: (bool? value) async {
                      if (stage1 != 2) {
                        return _showDialog_stage();
                      } else if (stage1 == 2) {
                        setState(() {
                          if (count_selected_holding_period == 0) {
                            _is_selected_holding_period[idx] = value!;
                          } else if (count_selected_holding_period == 1) {
                            if (index_selected_holding_period == idx) {
                              _is_selected_holding_period[idx] =
                                  !_is_selected_holding_period[idx];
                            }
                          }
                        });
                      }
                    })),
          ),
          const SizedBox(
            width: 1,
          ),
          Text(
            select_holdig_period[idx],
            style: TextStyle(fontSize: 19),
          )
        ],
      ),
    );
  }

  Future<void> _showDialog_stage() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 750), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('앞의 단계를 먼저 진행해주세요',
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.center),
          );
        });
  }

  SizedBox Label(String label) =>
      SizedBox(width: 120, child: MediumText(text: label));

  LabelwithBadge_1(String label) => Row(
        children: [
          SizedBox(
            width: 90,
            child: Badge(
                alignment: Alignment.topLeft,
                toAnimate: false,
                padding: EdgeInsets.all(7),
                badgeColor: mainColor,
                badgeContent: Text(
                  num_of_house[0],
                  style: TextStyle(color: Colors.white),
                ),
                child: MediumText(text: label)),
          ),
          SizedBox(
            width: 30,
          )
        ],
      );

  LabelwithBadge_2(String label) => Row(
        children: [
          SizedBox(
            width: 80,
            child: Badge(
                alignment: Alignment.topLeft,
                toAnimate: false,
                padding: EdgeInsets.all(7),
                badgeColor: mainColor,
                badgeContent: Text(
                  '2+',
                  style: TextStyle(color: Colors.white),
                ),
                child: MediumText(text: label)),
          ),
          SizedBox(
            width: 40,
          )
        ],
      );

  Row Selected_num_of_house() {
    return Row(
      children: [
        Label('주택수 선택'),
        Wrap(
          spacing: 35,
          runSpacing: 10,
          children: [
            buildActionChip3(stage1),
            buildActionChip2(stage2),
            buildActionChip(stage3),
          ],
        ),
      ],
    );
  }

  ActionChip buildActionChip3(int stage) {
    int count_selected =
        _is_selected_num_of_house.where((element) => element == true).length;
    int index_selected =
        _is_selected_num_of_house.indexWhere((element) => element == true);
    return ActionChip(
        onPressed: () {
          if (count_selected == 0){
            setState(() {
              _is_selected_num_of_house[0] = !_is_selected_num_of_house[0];
              stage1 = 1;
            });
          }else if (count_selected == 1){
            setState(() {
              if (index_selected == 0) {
                _is_selected_num_of_house[0] = !_is_selected_num_of_house[0];
                stage1 = 0;
              }
            });
          }
        },
        labelPadding: EdgeInsets.all(5),
        backgroundColor:
            _is_selected_num_of_house[0] ? mainColor : Colors.white,
        elevation: 2,
        avatar: CircleAvatar(
          backgroundColor: _is_selected_num_of_house[0]
              ? Colors.white60
              : mainColor.withOpacity(.6),
          child: Text((num_of_house[0])),
        ),
        shadowColor: Colors.grey[100],
        padding: EdgeInsets.all(6),
        label: Text(
          select_num_of_house[0],
          style: TextStyle(
              color: _is_selected_num_of_house[0] ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17),
        ));
  }

  ActionChip buildActionChip2(int stage) {
    int count_selected =
        _is_selected_num_of_house.where((element) => element == true).length;
    int index_selected =
        _is_selected_num_of_house.indexWhere((element) => element == true);
    return ActionChip(
        onPressed: () {
          setState(() {
            if (count_selected == 0) {
              _is_selected_num_of_house[1] = !_is_selected_num_of_house[1];
              stage = 1;
            } else if (count_selected == 1) {
              if (index_selected == 1) {
                _is_selected_num_of_house[1] = !_is_selected_num_of_house[1];
                stage = 0;
              }
            }
          });
        },
        labelPadding: EdgeInsets.all(5),
        backgroundColor:
            _is_selected_num_of_house[1] ? mainColor : Colors.white,
        elevation: 2,
        avatar: CircleAvatar(
          backgroundColor: _is_selected_num_of_house[1]
              ? Colors.white60
              : mainColor.withOpacity(.6),
          child: Text((num_of_house[1])),
        ),
        shadowColor: Colors.grey[100],
        padding: EdgeInsets.all(6),
        label: Text(
          select_num_of_house[1],
          style: TextStyle(
              color: _is_selected_num_of_house[1] ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17),
        ));
  }

  ActionChip buildActionChip(int stage) {
    int count_selected =
        _is_selected_num_of_house.where((element) => element == true).length;
    int index_selected =
        _is_selected_num_of_house.indexWhere((element) => element == true);
    return ActionChip(
        onPressed: () {
          setState(() {
            if (count_selected == 0) {
              _is_selected_num_of_house[2] = !_is_selected_num_of_house[2];
              stage = 1;
            } else if (count_selected == 1) {
              if (index_selected == 2) {
                _is_selected_num_of_house[2] = !_is_selected_num_of_house[2];
                stage = 0;
              }
            }
          });
        },
        labelPadding: EdgeInsets.all(5),
        backgroundColor:
            _is_selected_num_of_house[2] ? mainColor : Colors.white,
        elevation: 2,
        avatar: CircleAvatar(
          backgroundColor: _is_selected_num_of_house[2]
              ? Colors.white60
              : mainColor.withOpacity(.6),
          child: Text(num_of_house[2]),
        ),
        shadowColor: Colors.grey[100],
        padding: EdgeInsets.all(6),
        label: Text(
          select_num_of_house[2],
          style: TextStyle(
              color: _is_selected_num_of_house[2] ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17),
        ));
  }

  Widget Diver_Title() {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: const Divider(
              color: Colors.red,
              height: 20,
            )),
      ),
      const Text(
        "2022년 7월 세법개정(안) 반영",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15, right: 30),
            child: const Divider(
              color: Colors.red,
              height: 20,
            )),
      ),
    ]);
  }
}
