// ignore_for_file: avoid_unnecessary_containers
import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:calculator_frontend/widgets/MediumText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class HoldingTaxPage extends StatefulWidget {
  const HoldingTaxPage({Key? key}) : super(key: key);

  @override
  State<HoldingTaxPage> createState() => _HoldingTaxPageState();
}

class _HoldingTaxPageState extends State<HoldingTaxPage>
    with SingleTickerProviderStateMixin {
  //SingleTickProviderStateMixin Tab bar controller 애니메이션 처리를 위해(즉, vsync 사용을 위해)
  late TabController _tabController; //TabView

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateofchangeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();

  final mainColor = 0xff80cfd5;
  final mainColor_grey = 0xff666666;
  final bar = ['설명', '주의사항'];
  bool _expand = false;

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;
  bool _isChecked6 = false;
  bool _isChecked7 = false;
  bool _isChecked8 = false;
  bool _isChecked9 = false;

  final years = ['2021년', '2022년', '2023년']; //대상연도
  late List<bool> _isSelected;

  String? selected_item = null;
  List item_list = ['item1', 'item2', 'item3'];

  String description_path = 'assets/txt/HoldingTax_description.txt';
  String precaution_path = 'assets/txt/HoldingTax_precaution.txt';
  String description_txt = '';
  String precaution_txt = '';

  // 텍스트 파일 가져오기
  void loadTxt() async {
    String description = await rootBundle.loadString(description_path);
    setState(() {
      description_txt = description;
    });
  }

  void loadTxt2() async {
    String precaution = await rootBundle.loadString(precaution_path);
    setState(() {
      precaution_txt = precaution;
    });
  }

  @override
  void initState() {
    loadTxt();
    loadTxt2(); //설명은 되는데, 주의사항은 text file load가 안됨.
    this._tabController = TabController(length: bar.length, vsync: this);
    _isSelected = [false, true, false];

    // // addListener로 상태 모니터링 가능
    // _amountController.addListener(() {
    //   // controller의 text 프로퍼티로 연결된 TextField에 입력된 값을 얻음.
    //   print('두 번째 text field : ${_amountController.text}');
    // });
    super.initState();
  } //initState() 위젯 생성될 때 호출됨.

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _rateofchangeController.dispose();
    _focusNode.dispose();
    super.dispose();
  } //dispose() 위젯 종료될 때(pop) 호출됨.(Controller 객체 제거될 때 변수에 할당된 메모리 제거하기 위해)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
              Top_Container(context),
              const SizedBox(
                height: 70,
              ),
              Diver_Title(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    MediumText(text: '주택수 선택'),
                    const SizedBox(
                      width: 50,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked1,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked1 = value!;
                          });
                        }),
                    _optionText('1세대 1주택'),
                    const SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked2,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked2 = value!;
                          });
                        }),
                    _optionText('1세대 2주택'),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked3,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked3 = value!;
                          });
                        }),
                    _optionText('1세대 3주택 이상'),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    MediumText(text: '세액공제'),
                    const SizedBox(
                      width: 70,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked3,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked3 = value!;
                          });
                        }),
                    _optionText('연령공제'),
                    const SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked4,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked4 = value!;
                          });
                        }),
                    _optionText('보유기간공제'),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    MediumText(text: '세부계산'),
                    const SizedBox(
                      width: 70,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked5,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked5 = value!;
                          });
                        }),
                    _optionText('세부담 상한 반영'),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Divider_Title2(),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    MediumText(text: '추가사항'),
                    const SizedBox(
                      width: 70,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked6,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked6 = value!;
                          });
                        }),
                    _optionText('조정대상지역'),
                    const SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked7,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked7 = value!;
                          });
                        }),
                    _optionText('도시지역분 포함'),
                    const SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked8,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked8 = value!;
                          });
                        }),
                    _optionText('공동명의'),
                    const SizedBox(
                      width: 20,
                    ),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        side: BorderSide(width: 1, color: Color(mainColor)),
                        checkColor: Colors.white,
                        value: _isChecked9,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked9 = value!;
                          });
                        }),
                    _optionText('세부계산'),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MediumText(text: '공시가격'),
                    const SizedBox(
                      width: 70,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        focusNode: _focusNode,
                        controller: _amountController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(fontSize: 17),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 15, right: 10, top: 10, bottom: 10),
                          hintText: '금액 입력',
                          hintStyle: const TextStyle(color: Colors.black38),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MediumText(text: '자산추가'),
                    const SizedBox(
                      width: 70,
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          height: 40,
                          decoration:
                              const BoxDecoration(color: Colors.black38),
                          child: InkWell(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                '주택',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () {},
                  child: const Text(
                    '계산',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      )),
    );
  }

  Padding Divider_Title2() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Icon(
            Icons.arrow_drop_down_circle,
            size: 25,
            color: Colors.black54,
          ),
        ),
        LargeText(
          text: '자산내역',
          size: 20,
          color: Colors.black54,
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 35, right: 20),
              child: Container(
                color: Colors.black38,
                height: 5,
              )),
        ),
        LargeText(text: '삭제', size: 20, color: Colors.grey.withOpacity(.5))
      ]),
    );
  }

  Checkbox checkBox(bool _isChecked) {
    return Checkbox(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        side: BorderSide(width: 1, color: Color(mainColor)),
        checkColor: Colors.white,
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
        });
  }

  Widget Year() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Row(
        children: [
          MediumText(text: '대상연도'),
          const SizedBox(
            width: 70,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: LayoutBuilder(builder: (context, constraints) {
                return Center(
                  child: ToggleButtons(
                      constraints: BoxConstraints(
                          minHeight: 40,
                          minWidth: (constraints.maxWidth - 5) / 3),
                      fillColor: Color(mainColor),
                      color: Color(mainColor_grey),
                      selectedColor: Colors.white,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            years[0],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            years[1],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            years[2],
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                      onPressed: (int idx) {
                        setState(() {
                          for (int i = 0; i < _isSelected.length; i++) {
                            _isSelected[i] = i == idx;
                          }
                        });
                      },
                      isSelected: _isSelected),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget Top_Container(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: _expand ? 780 : 310,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: .02),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 50,
                width: 220,
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  controller: _tabController,
                  tabs: bar.map((_title) {
                    return Tab(
                      text: _title,
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: <Widget>[
                Description(),
                Precaution(),
              ]),
            ),
            IconButton(
                padding: const EdgeInsets.only(bottom: 10),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
                icon: _expand
                    ? Icon(
                        Icons.keyboard_arrow_up_sharp,
                        size: 40,
                      )
                    : Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 40,
                      ))
          ],
        ),
      ),
    );
  }

  Widget Diver_Title() {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 30, right: 15),
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

  Widget Description() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        child: Text(
          description_txt,
          overflow: TextOverflow.fade,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget Precaution() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Text(
          '주의사항',
          overflow: TextOverflow.fade,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _optionText(String txt) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 3),
      child: Text(
        txt,
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
