import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:calculator_frontend/widgets/NavigationBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class MobileHomepage extends StatefulWidget {
  const MobileHomepage({Key? key}) : super(key: key);

  @override
  State<MobileHomepage> createState() => _MobileHomepageState();
}

class _MobileHomepageState extends State<MobileHomepage> {
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
      endDrawerEnableOpenDragGesture: false,
      appBar: PreferredSize(
        preferredSize: Size(widgetSize.width, 200),
        child: Expanded(
          child: Container(
              color: _scrollPosition == 0 ? Colors.white : Colors.blueAccent,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Padding(
                padding: EdgeInsets.only(
                  left: (widgetSize.width > 1000)
                      ? widgetSize.width / 30
                      : widgetSize.width / 50,
                  right: (widgetSize.width > 1000)
                      ? widgetSize.width / 30
                      : widgetSize.width / 50,
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
                                    fontWeight: FontWeight.w700))),
                        const SizedBox(
                          width: 20,
                        ),
                        //  The problem is I was using the context of the widget that instantiated Scaffold.
                        //  Not the context of a child of Scaffold
                        Builder(builder: (context) {
                          return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: Icon(Icons.menu_rounded));
                        })
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
      endDrawer: Drawer(
        width: 250,
        child: ListView(
          children: [
            DrawerHeader(
              child: null,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/new_logo2.jpg'),
                      fit: BoxFit.fill)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('TAXAI 소개'),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('공지사항'),
            ),
            ListTile(
              leading: Icon(Icons.mail_sharp),
              title: Text('기술 문의'),
              onTap: () {
                _sendInquiryEmail();
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail_sharp),
              title: Text('제휴 문의'),
              onTap: () {
                _sendPartnerEmail();
              },
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
                    right: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
                  ),
                  child: Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 95,
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 88,
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
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                            text: TextSpan(
                                text:
                                    'TAXAI는 아파트, 주택, 조합원입주권, 분양권, 오피스텔의\n수백 가지의 비과세 유형과 증과 주택수, 감면주택 등의 \n',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20),
                                children: [
                              TextSpan(
                                  text:
                                      '세법 규정을 자동으로 판단해서 계산하는\n혁신적인 양도소득세 계산기',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  )),
                              TextSpan(text: ' 입니다.')
                            ])),
                        Image.asset(
                          'assets/images/tax_consulting_illustration.jpg',
                          height: 400,
                          width: 500,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                            text: TextSpan(
                                text:
                                    'TAXAI는 15년간 재산 관련 세금 컨설팅을\n전문적으로 해온 현직 세무사가 직접 설계한 \n',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20),
                                children: [
                              TextSpan(text: '프로그램으로서'),
                              TextSpan(
                                  text:
                                      '최신 법령과 예규, 판례 등을\n 주기적으로 업데이트하여 케이스별로 적용 가능한\n',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  )),
                              TextSpan(
                                  text: '수많은 절세 규정을 미리 검토',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  )),
                              TextSpan(text: '할 수 있으며,\n'),
                              TextSpan(
                                  text:
                                      '조정대상지역 및 공동주택 가격 등을 \n자동 조회하는 기능을 갖추고 있어\n'),
                              TextSpan(
                                  text:
                                      '세금 신고 관련 오류를 \n획기적으로 줄여줄 수 있습니다.',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  ))
                            ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          'assets/images/tax_consulting_illustration.jpg',
                          height: 400,
                          width: 500,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'TAXAXI는 추후 미래 세금을 컨설팅 하는 기능도 추가할 예정입니다.',
                          style: TextStyle(
                              fontSize: 21,
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
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
                    right: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
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
                            isMedium: true,
                            pushNamed: '/capgain',
                            title_1: '양도소득세',
                            title_2: 'AI 판단 계산기'),
                        NavigationBox(
                            imagepath: 'assets/images/calculate.png',
                            isMedium: true,
                            pushNamed: '/holding',
                            title_1: '보유세(종부세, 재산세)',
                            title_2: 'AI 판단 계산기'),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
                    right: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NavigationBox(
                                imagepath: 'assets/images/psychology.png',
                                isMedium: true,
                                pushNamed: '/',
                                title_1: '양도소득세 AI',
                                title_2: '컨설팅'),
                            NavigationBox(
                                imagepath: 'assets/images/psychology.png',
                                isMedium: true,
                                pushNamed: '/',
                                title_1: '매도 관련',
                                title_2: 'AI 컨설팅'),
                          ],
                        ),
                        SizedBox(
                          height: widgetSize.height / 45,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NavigationBox(
                                imagepath: 'assets/images/psychology.png',
                                isMedium: true,
                                pushNamed: '/',
                                title_1: '양도소득세 AI',
                                title_2: '컨설팅'),
                            NavigationBox(
                                imagepath: 'assets/images/psychology.png',
                                isMedium: true,
                                pushNamed: '/',
                                title_1: '매도 관련',
                                title_2: 'AI 컨설팅'),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: 70,
                    left: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
                    right: (widgetSize.width > 1000)
                        ? widgetSize.width / 30
                        : widgetSize.width / 50,
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
                    widgetSize.width < 700
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('(주) NEW EYE CORPORATION |'),
                              Text('주소 : 부산광역시 남구 수영로 295, 911호(대연동, 세웅빌딩)')
                            ],
                          )
                        : Text(
                            '(주) NEW EYE CORPORATION | 주소 : 부산광역시 남구 수영로 295, 911호(대연동, 세웅빌딩)'),
                    widgetSize.width < 700
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('대표자 김난이 | 사업자 등록번회: 457-86-02417'),
                                Row(
                                  children: [
                                    Text('| 이메일 : '),
                                    TextButton(
                                        onPressed: () {
                                          sendTAXAIEmail();
                                        },
                                        child: Text(
                                          'admin@taxai.co.kr',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 2),
                                        ))
                                  ],
                                )
                              ])
                        : Row(
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

  void _sendInquiryEmail() async {
    final Email email = Email(
      body: '',
      subject: 'TAXAI 문의사항',
      recipients: ['tech@taxai.co.kr'],
      cc: [''],
      bcc: [''],
      attachmentPaths: [''],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      showAlert('TAXAI 문의사항', 'tech@taxai.co.kr');
    }
  }

  void _sendPartnerEmail() async {
    final Email email = Email(
      body: '',
      subject: 'TAXAI 제휴문의',
      recipients: ['admin@taxai.co.kr'],
      cc: [''],
      bcc: [''],
      attachmentPaths: [''],
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
