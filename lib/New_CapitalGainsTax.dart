import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Resume_CapitalGainsTaxPage extends StatefulWidget {
  const Resume_CapitalGainsTaxPage({Key? key}) : super(key: key);

  @override
  State<Resume_CapitalGainsTaxPage> createState() => _Resume_CapitalGainsTaxPageState();
}

class _Resume_CapitalGainsTaxPageState extends State<Resume_CapitalGainsTaxPage> {

  bool _ischecked = false;

  final TextEditingController _transferPriceTC = TextEditingController();
  final TextEditingController _acquisitionPriceTC = TextEditingController();
  final TextEditingController _neededPriceTC = TextEditingController();
  final TextEditingController _transferDateTC = TextEditingController();
  final TextEditingController _acquisitionDateTC = TextEditingController();
  final TextEditingController _startLivingDateTC = TextEditingController();
  final TextEditingController _endLivingDateTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:  Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: ListView(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Expanded(
                        child:  Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                      const Text(
                        "2022년 5월 세법개정(안) 반영",
                        style: TextStyle(fontSize: 17),
                      ),
                      Expanded(
                        child:  Container(
                            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 50,
                            )),
                      ),
                    ]),
                Row(
                  children: [
                    _smallTitle('거래대상'),
                    _customButton('주택'),
                    _customButton('분양권'),
                    _customButton('토지'),
                    _customButton('기타')
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('대상주택'),
                    _customButton('1주택'),
                    _customButton('2주택'),
                    _customButton('3주택 이상'),
                    _customButton('기타')
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('규제지역'),
                    Checkbox(
                        value: _ischecked,
                        onChanged: (bool? value){
                          setState(() {
                            _ischecked = value!;
                          });
                        }
                    ),
                    _optionText('취득시점 조정대상지역')
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('추가사항'),
                    Checkbox(
                        value: _ischecked,
                        onChanged: (bool? value){
                          setState(() {
                            _ischecked = value!;
                          });
                        }
                    ),
                    _optionText('기본공제'),
                    Checkbox(
                        value: _ischecked,
                        onChanged: (bool? value){
                          setState(() {
                            _ischecked = value!;
                          });
                        }
                    ),
                    _optionText('공동명의'),
                    Checkbox(
                        value: _ischecked,
                        onChanged: (bool? value){
                          setState(() {
                            _ischecked = value!;
                          });
                        }
                    ),
                    _optionText('다주택에서 전환'),
                    Checkbox(
                        value: _ischecked,
                        onChanged: (bool? value){
                          setState(() {
                            _ischecked = value!;
                          });
                        }
                    ),
                    _optionText('임대주택'),
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('양도가액'),
                    _textField1(_transferPriceTC,'단위(만원)')
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('취득가액'),
                    _textField1(_acquisitionPriceTC,'단위(만원)')
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('필요경비'),
                    _textField1(_neededPriceTC, '단위(만원)')
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline_sharp),
                    const SizedBox(width: 5,),
                    const Text('보유정보', style: TextStyle(fontSize: 17),),
                    Expanded(
                      child:  Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: const Divider(
                            color: Colors.black,
                            height: 50,
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('양도일자'),
                    _textField2(_transferDateTC, '20220725')
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('취득일자'),
                    _textField2(_acquisitionDateTC, '19980218')
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline_sharp),
                    const SizedBox(width: 5,),
                    const Text('거주정보', style: TextStyle(fontSize: 17),),
                    Expanded(
                      child:  Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: const Divider(
                            color: Colors.black,
                            height: 50,
                          )
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('간편선택'),
                    Checkbox(
                        value: _ischecked,
                        onChanged: (bool? value){
                          setState(() {
                            _ischecked = value!;
                          });
                        }
                    ),
                    _optionText('보유기간과 동일'),
                    Checkbox(
                        value: _ischecked,
                        onChanged: (bool? value){
                          setState(() {
                            _ischecked = value!;
                          });
                        }
                    ),
                    _optionText('거주기간 없음'),
                  ],
                ),
                Row(
                  children: [
                    _smallTitle('취득일자'),
                    _textField2(_startLivingDateTC, '19980218'),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(Icons.arrow_forward_rounded),
                    ),
                    _textField2(_endLivingDateTC, '20220725'),
                  ],
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent
                    ),
                    onPressed: (){
                      if(_checkFormIsCompleted()){
                        setState(() {

                        });
                      }
                      else{
                        setState(() {

                        });
                      }
                    },
                    child: const Text(
                      '계산하기',style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  bool _checkFormIsCompleted(){
    return true;
  }

  Widget _textField1(TextEditingController tc, String labelText){
    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: tc,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.black),
              focusedBorder: _outlineInputBorder(),
              enabledBorder: _outlineInputBorder(),
              border: _outlineInputBorder(),
            ),
          ),
        )
    );
  }
  Widget _textField2(TextEditingController tc, String hintText){
    return Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: tc,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black38),
              focusedBorder: _outlineInputBorder(),
              enabledBorder: _outlineInputBorder(),
              border: _outlineInputBorder(),
            ),
          ),
        )
    );
  }



  OutlineInputBorder _outlineInputBorder() {
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(10)));
  }

  Widget _optionText(String txt){
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Text(txt,
        style: TextStyle(fontSize: 17),
      ),
    );
  }

  Widget _smallTitle(String txt){
    return Container(
      width: 120,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Text(txt,style: const TextStyle(fontSize: 20),),
    );
  }

  Widget _customButton(String text){
    return Expanded
      (child: ConstrainedBox(
      constraints: const BoxConstraints(
          minWidth: 100
      ),
      child: Container(
          margin: const EdgeInsets.fromLTRB(4, 10, 0, 10),
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.black38
          ),
          child: InkWell(
            onTap: (){},
            child: Center(
              child:  Text(
                text,
                style: const TextStyle(
                    color: Colors.white,fontSize: 17),
              ),
            ),
          )
      ),
    ));
  }
}



class CapitalGainsTax{

}
