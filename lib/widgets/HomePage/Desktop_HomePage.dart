import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:calculator_frontend/widgets/NavigationBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class DesktopHomepage extends StatefulWidget {
  const DesktopHomepage({Key? key}) : super(key: key);

  @override
  State<DesktopHomepage> createState() => _DesktopHomepageState();
}

class _DesktopHomepageState extends State<DesktopHomepage> {
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widgetSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // PreferredSize를 사용하면 AppBar와 같이 user 지정 width나 length 지정 가능
      appBar: PreferredSize(
        preferredSize: Size(widgetSize.width, 200),
        child: Container(
            color:
                _scrollPosition == 0 ? Colors.white : Colors.blueAccent,
            padding: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.only(
                left: (widgetSize.width > 1400) ? widgetSize.width / 20 : widgetSize.width / 100,
                right: (widgetSize.width > 1400) ? widgetSize.width / 20 : widgetSize.width / 100,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/new_logo2.jpg',
                    height: 50,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              primary: Colors.grey,
                              padding: EdgeInsets.all(20)),
                          child: Text(
                            'TAXIAI 소개',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: TextButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                primary: Colors.grey,
                                padding: EdgeInsets.all(20)),
                            child: Text('공지사항',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: TextButton(
                            onPressed: () {
                              sendInquiryEmail();
                            },
                            style: OutlinedButton.styleFrom(
                                primary: Colors.grey,
                                padding: EdgeInsets.all(20)),
                            child: Text('기술 문의',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 20),
                        child: TextButton(
                            onPressed: () {
                              sendPartnerEmail();
                            },
                            style: OutlinedButton.styleFrom(
                                primary: Colors.grey,
                                padding: EdgeInsets.all(20)),
                            child: Text('제휴 문의',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700))),
                      ),
                      OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              primary: Colors.indigo,
                              backgroundColor: Colors.black54,
                              padding: EdgeInsets.all(20)),
                          child: Text('로그인',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)))
                    ],
                  )
                ],
              ),
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: (widgetSize.width > 1400) ? widgetSize.width / 20 : widgetSize.width / 100,
                    right: (widgetSize.width > 1400) ? widgetSize.width / 20 : widgetSize.width / 100,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              RichText(
                                textAlign: TextAlign.start,
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 90,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.blueAccent),
                                      text: 'T A X A I',
                                      children: [
                                    TextSpan(
                                        text: '\n혁신적인 양도소득세 계산기',
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.black)),
                                  ])),
                              const SizedBox(
                                height: 15,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text:
                                          ' TAXAI는 아파트, 주택, 조합원입주권, 분양권, 오피스텔의\n 수백 가지의 비과세 유형과 증과 주택수, 감면주택 등의\n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20),
                                      children: [
                                    TextSpan(
                                        text:
                                            ' 세법 규정을 자동으로 판단해서 계산하는\n 혁신적인 양도소득세 계산기',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                        )),
                                    TextSpan(text: ' 입니다.')
                                  ]))
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                            child: Image.asset(
                              'assets/images/tax_consulting_illustration.jpg',
                              height: 500,
                              width: 600,
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      ),
                      AnimatedOpacity(
                        duration: const Duration(microseconds: 20),
                        opacity: _scrollPosition < 230 ? 0.5 : 1,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/tax_consulting_illustration.jpg',
                              height: 500,
                              width: 600,
                              fit: BoxFit.fitHeight,
                            ),
                            Spacer(),
                            RichText(
                              textAlign: TextAlign.start,
                                text: TextSpan(
                                    text:
                                        'TAXAI는 15년간 재산 관련 세금 컨설팅을 전문적으로 해온\n현직 세무사가 직접 설계한 프로그램으로서\n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20),
                                    children: [
                                  TextSpan(
                                      text:
                                          '최신 법령과 예규, 판례 등을 주기적으로 업데이트하여\n케이스별로 적용 가능한 수많은 절세 규정을 미리 검토',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      )),
                                  TextSpan(text: '할 수 있으며,\n'),
                                  TextSpan(
                                      text:
                                          '조정대상지역 및 공동주택 가격 등을 자동 조회하는 기능을 갖추고 있어\n'),
                                  TextSpan(
                                      text: '세금 신고 관련 오류를 획기적으로 줄여줄 수 있습니다.',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      ))
                                ])),
                          ],
                        ),
                      ),
                      Text(
                        'TAXAXI는 추후 미래 세금을 컨설팅 하는 기능도 추가할 예정입니다.',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widgetSize.width / 15,
                    right: widgetSize.width / 15,
                    bottom: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LargeText(
                      text: 'AI 세금 계산',
                    ),
                    SizedBox(
                      height: widgetSize.height / 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NavigationBox(
                            imagepath: 'assets/images/calculate.png',
                            isMedium: false,
                            pushNamed: '/capgain',
                            title_1: '양도소득세',
                            title_2: 'AI 판단 계산기'),
                        NavigationBox(
                            imagepath: 'assets/images/calculate.png',
                            isMedium: false,
                            pushNamed: '/holding',
                            title_1: '보유세(종부세, 재산세)',
                            title_2: 'AI 판단 계산기'),
                        Opacity(
                            opacity: 0,
                            child: NavigationBox(
                                imagepath: '',
                                isMedium: false,
                                pushNamed: '/',
                                title_1: '',
                                title_2: '')),
                        Opacity(
                          opacity: 0,
                          child: NavigationBox(
                              imagepath: '',
                              isMedium: false,
                              pushNamed: '/',
                              title_1: '',
                              title_2: ''),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: widgetSize.width / 15,
                    right: widgetSize.width / 15,
                    bottom: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LargeText(
                      text: 'TAXAI 컨설팅',
                    ),
                    SizedBox(
                      height: widgetSize.height / 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NavigationBox(
                            imagepath: 'assets/images/psychology.png',
                            isMedium: false,
                            pushNamed: '/',
                            title_1: '양도소득세 AI',
                            title_2: '컨설팅'),
                        NavigationBox(
                            imagepath: 'assets/images/psychology.png',
                            isMedium: false,
                            pushNamed: '/',
                            title_1: '매도 관련',
                            title_2: 'AI 컨설팅'),
                        NavigationBox(
                            imagepath: 'assets/images/psychology.png',
                            isMedium: false,
                            pushNamed: '/',
                            title_1: '양도소득세 AI',
                            title_2: '컨설팅'),
                        NavigationBox(
                            imagepath: 'assets/images/psychology.png',
                            isMedium: false,
                            pushNamed: '/',
                            title_1: '매도 관련',
                            title_2: 'AI 컨설팅'),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: 70,
                    left: (widgetSize.width > 1400) ? widgetSize.width / 20 : widgetSize.width / 100,
                    right: (widgetSize.width > 1400) ? widgetSize.width / 20 : widgetSize.width / 100,
                    bottom: 70),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/new_logo2.jpg',
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        '(주) NEW EYE CORPORATION | 주소 : 부산광역시 남구 수영로 295, 911호(대연동, 세웅빌딩)'),
                    Row(
                      children: [
                        Text('대표자 김난이 | 사업자 등록번회: 457-86-02417 | 이메일'),
                        TextButton(
                            onPressed: () {
                              sendTAXAIEmail();
                            },
                            child: Text(
                              'admin@taxai.co.kr',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2),
                            ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sendInquiryEmail() async {
    final Email email = Email(
      body: '',
      subject: 'TAXAI 문의사항',
      recipients: ['tech@taxai.co.kr'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      showAlert('TAXAI 문의사항', 'tech@taxai.co.kr');
    }
  }

  sendPartnerEmail() async {
    final Email email = Email(
      body: '',
      subject: 'TAXAI 제휴문의',
      recipients: ['admin@taxai.co.kr'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      showAlert('TAXAI 제휴문의', 'admin@taxai.co.kr');
    }
  }

  sendTAXAIEmail() async {
    final Email email = Email(
      body: '',
      subject: 'TAXAI',
      recipients: ['admin@taxai.co.kr'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      showAlert('TAXAI 문의사항', 'admin@taxai.co.kr');
    }
  }

  Future<void> showAlert(String title, String email) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('현재 메일을 바로 보낼 수 없습니다.'),
                Text('아래 이메일로 문의주시면 감사하겠습니다.'),
                Text(
                  email,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      Text('확인', style: TextStyle(fontWeight: FontWeight.bold)))
            ],
          );
        });
  }
}
