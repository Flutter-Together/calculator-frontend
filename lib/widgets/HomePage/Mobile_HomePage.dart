import 'package:calculator_frontend/widgets/LargeText.dart';
import 'package:calculator_frontend/widgets/NavigationBox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html';
import 'package:url_launcher/url_launcher.dart';

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

  Future launchLoginUrl() async {
    final Uri login_url = Uri.parse(
        'https://taxai.auth.ap-northeast-2.amazoncognito.com/login?client_id=165n75nfnnvlphe5vlom6lsu9q&response_type=token&scope=aws.cognito.signin.user.admin&redirect_uri=https://taxai.co.kr/callback');
    // 해당 url이 실행가능한지 확인
    if (!await canLaunchUrl(login_url)) {
      throw 'Could not launch $login_url';
    } else {
      // webOnlyWindowName : '_blank' => URL is loaded into a new window, or tab. This is the default
      // webOnlyWindowName: '_self' => URL replaces the current page
      // webOnlyWindowName: '_parent' => URL is loaded into the parent frame
      // _top	URL replaces any framesets that may be loaded
      // name	The name of the window (does not specify the title of the window)
      launchUrl(login_url,
          mode: LaunchMode.platformDefault, webOnlyWindowName: '_self');
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgetSize = MediaQuery.of(context).size;
    var current_login_url = window.location.href;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      endDrawerEnableOpenDragGesture: false,
      appBar: PreferredSize(
        preferredSize: Size(widgetSize.width, 200),
        child: Container(
            decoration: BoxDecoration(
              color: _scrollPosition == 0 ? Colors.white : Colors.blueAccent,
              border: Border(
                  bottom: BorderSide(
                      width: .3, color: Colors.grey)),
            ),
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
                  Row(
                    children: [
                      _scrollPosition == 0
                          ? Image.asset(
                        'assets/images/logo_color_col.png',
                        height: 40,
                        width: 70,
                        fit: BoxFit.contain,
                      )
                          : Image.asset(
                        'assets/images/white_logo_col.png',
                        height: 40,
                        width: 70,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'TAXAI',
                        style: TextStyle(
                            fontSize: 25,
                            color: _scrollPosition == 0
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            launchLoginUrl();
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: _scrollPosition == 0
                                  ? Colors.blueAccent
                                  : Colors.black38,
                              padding: EdgeInsets.all(10)),
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
                            icon: Icon(Icons.menu_rounded, color: _scrollPosition == 0
                                ? Colors.black
                                : Colors.white,));
                      })
                    ],
                  )
                ],
              ),
            )),
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              width: double.maxFinite,
              height: 70,
              color: Colors.blueAccent,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/white_logo_col.png',
                    height: 50,
                    width: 70,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'TAXAI',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel, color: Colors.white, size: 30,)),
                  const SizedBox(width: 10,)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .3, color: Colors.grey),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.home, color: Colors.blueAccent,),
                title: Text('TAXAI 소개',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .3, color: Colors.grey),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.notifications, color: Colors.blueAccent,),
                title: Text('공지사항',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .3, color: Colors.grey),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.mail_sharp, color: Colors.blueAccent,),
                title: Text('기술 문의',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onTap: () {
                  sendInquiryEmail();
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .3, color: Colors.grey),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.contact_mail_sharp, color: Colors.blueAccent,),
                title: Text('제휴 문의',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onTap: () {
                  sendPartnerEmail();
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .3, color: Colors.grey),
                ),
              ),
              child: ListTile(
                  leading: Icon(Icons.info, color: Colors.blueAccent,),
                  title: Text('특허 정보',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onTap: () {
                    showPatentDialog();
                  }),
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
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blueAccent,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(5, 5),
                                        color:
                                            Colors.blueAccent.withOpacity(.7),
                                        blurRadius: 7)
                                  ]),
                              text: 'T A X A I',
                              children: [
                                TextSpan(
                                    text: '\nAI가 판단하는 세금 계산기',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        shadows: [
                                          Shadow(color: Colors.white)
                                        ])),
                              ])),
                      const SizedBox(
                        height: 50,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: '세금 계산 시 고려사항은\n'
                                  '왜 이렇게 복잡하고 어려울까?\n\n'
                                  '전문가도 수많은 법령이나 예규 판례를\n'
                                  '이해는 할 수 있지만\n'
                                  '모두 기억하고 있을 순 없는데\n'
                                  '프로그램은 기억하지 않을까?\n\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blueAccent,
                                  fontSize: 18),
                              children: [
                                TextSpan(
                                    text: '라는 질문으로 이 프로그램을\n기획하게 되었습니다.',
                                    style: TextStyle(color: Colors.black)),
                              ])),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/images/homepage_image.png',
                        height: 400,
                        width: 500,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '수많은 세금관련 규정을 정리하고도식화 하고 \n'
                                '프로그래밍화 하는 과정을 거쳐\n'
                                '프로그램을 완성하게 되었습니다.\n\n'
                                '앞으로도 개정되는 법령과 예규, 판례를\n'
                                '주기적으로 업데이트하여\n'
                                '세금 관련 판단을 하는데\n도움이 되도록 하겠습니다.',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        'assets/images/homepage_image2.png',
                        height: 400,
                        width: 500,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Text(
                          'TAXAI 는 \n미래 세금을 컨설팅을 지원하는 기능도 \n 추가 할 예정입니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Container(
                        height: 300,
                        width: 450,
                        decoration: BoxDecoration(border: Border.all()),
                        child: Center(
                          child: Text('이미지'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text('김동현 세무사 (기술고문)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              '- 세무사, USA EA\n'
                              '- (前) LH 토지보상(평택 고덕단지, 부산 명지 등) 세무 자문\n'
                              '- (前) 부산 수영세무서 국세 심사위원\n'
                              '- (前) 우리은행 TAX컨설팅팀 (상속, 증여, 양도 컨설팅 전문)\n'
                              '- (現) AI TAX CONSULTING 대표 세무사',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          TextButton(
                              onPressed: () {
                                sendInquiryEmail();
                              },
                              child: Text('- 컨설팅 문의 : TECH@TAXAI.CO.KR',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )))
                        ],
                      ),
                    ],
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
                      size: 35,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NavigationBox(
                              isCalculator: true,
                              imagepath: 'assets/images/calculator_line.png',
                              isMedium: true,
                              pushNamed: '/capgain',
                              title_1: '양도소득세',
                              title_2: 'AI 판단 계산기'),
                          SizedBox(
                            width: 30,
                          ),
                          NavigationBox(
                              isCalculator: true,
                              imagepath: 'assets/images/calculator_line.png',
                              isMedium: true,
                              pushNamed: '/holding',
                              title_1: '보유세(종부세, 재산세)',
                              title_2: 'AI 판단 계산기'),
                          Opacity(
                              opacity: 0,
                              child: NavigationBox(
                                  isCalculator: true,
                                  imagepath: '',
                                  isMedium: false,
                                  pushNamed: '',
                                  title_1: '',
                                  title_2: ''))
                        ],
                      ),
                    ),
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
                      size: 35,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NavigationBox(
                                  isCalculator: false,
                                  imagepath:
                                      'assets/images/consultant_line.png',
                                  isMedium: true,
                                  pushNamed: '/',
                                  title_1: '양도소득세 AI',
                                  title_2: '컨설팅'),
                              SizedBox(
                                width: 30,
                              ),
                              NavigationBox(
                                  isCalculator: false,
                                  imagepath:
                                      'assets/images/consultant_line.png',
                                  isMedium: true,
                                  pushNamed: '/',
                                  title_1: '매도 관련',
                                  title_2: 'AI 컨설팅'),
                              Opacity(
                                  opacity: 0,
                                  child: NavigationBox(
                                      isCalculator: true,
                                      imagepath: '',
                                      isMedium: false,
                                      pushNamed: '',
                                      title_1: '',
                                      title_2: ''))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NavigationBox(
                                  isCalculator: false,
                                  imagepath:
                                      'assets/images/consultant_line.png',
                                  isMedium: true,
                                  pushNamed: '/',
                                  title_1: '양도소득세 AI',
                                  title_2: '컨설팅'),
                              SizedBox(
                                width: 30,
                              ),
                              NavigationBox(
                                  isCalculator: false,
                                  imagepath:
                                      'assets/images/consultant_line.png',
                                  isMedium: true,
                                  pushNamed: '/',
                                  title_1: '매도 관련',
                                  title_2: 'AI 컨설팅'),
                              Opacity(
                                  opacity: 0,
                                  child: NavigationBox(
                                      isCalculator: true,
                                      imagepath: '',
                                      isMedium: false,
                                      pushNamed: '',
                                      title_1: '',
                                      title_2: ''))
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: 60,
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
                      'assets/images/logo_color_col.png',
                      height: 70,
                      width: 70,
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
                              Text('대표자 김난이 | 사업자 등록번호: 457-86-02417 | 이메일'),
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
    final Uri inquiry_url = Uri(
      scheme: 'mailto',
      path: 'tech@taxai.co.kr',
      query: 'subject=[TAXAI 문의사항]', //add subject and body here
    );

    if (await canLaunchUrl(inquiry_url)) {
      await launchUrl(inquiry_url);
    } else {
      showAlert('TAXAI 문의사항', 'tech@taxai.co.kr');
      throw 'Could not launch $inquiry_url';
    }
  }

  sendPartnerEmail() async {
    final Uri partner_url = Uri(
      scheme: 'mailto',
      path: 'admin@taxai.co.kr',
      query: 'subject=[TAXAI 제휴문의]', //add subject and body here
    );

    if (await canLaunchUrl(partner_url)) {
      await launchUrl(partner_url);
    } else {
      showAlert('TAXAI 제휴문의', 'admin@taxai.co.kr');
      throw 'Could not launch $partner_url';
    }
  }

  sendTAXAIEmail() async {
    final Uri taxai_url = Uri(
      scheme: 'mailto',
      path: 'admin@taxai.co.kr',
      query: 'subject=[TAXAI]', //add subject and body here
    );

    if (await canLaunchUrl(taxai_url)) {
      await launchUrl(taxai_url);
    } else {
      showAlert('TAXAI', 'admin@taxai.co.kr');
      throw 'Could not launch $taxai_url';
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

  Future<void> showPatentDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Image.asset(
                'assets/images/application_number.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        });
  }
}
