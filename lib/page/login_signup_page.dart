import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../color/color.dart';
import '../widget/widget_box.dart';
import 'camp_navigation.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance; //사용자 등록이나 로그인 가능하게 만드는 함수 생성 가능케함

  String userName = "";
  String userEmail = "";
  String userPassWord = "";

  bool isSignupScreen = true;
  //bool showSpinner = false;
  //모든 텍스트 필드에 밸리데이션 기능 추가하는 GlobalKey
  final _formKey = GlobalKey<FormState>();

  // 사용자가 텍스트 폼 필드에 입력한 정보의 유효성을 확인하기 위한 함수
  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save(); // 폼 전체 state 저장하게 됨
    }
  }
  WidgetBox widgetBox = WidgetBox();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (result != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CampNavigation()));
      }  // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage('image/fall.jpg'), fit: BoxFit.fill),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("더 캠퍼",
                          style: TextStyle(color: ColorBox.backColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                         '캠핑하는 사람들',
                          style: const TextStyle(
                              letterSpacing: 1.0, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                )),
            //배경
            GestureDetector(
              onTap: () {
                setState(() {
                  isSignupScreen = false;
                });
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    SizedBox(height: 180,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '로그인',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isSignupScreen
                                      ? ColorBox.backColor
                                      : ColorBox.textColor),
                            ),
                            if (!isSignupScreen)
                              Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  width: 55,
                                  height: 2,
                                  color: ColorBox.backColor)
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                '회원가입',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? ColorBox.backColor
                                        : ColorBox.textColor),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  width: 55,
                                  height: 2,
                                  color: ColorBox.backColor,
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen)
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value.length < 3) {
                                        return "Please enter at last 4 characters";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userName = value!;
                                    },
                                    onChanged: (value) {
                                      userName = value;
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
                                          color: ColorBox.backColor,
                                        ),
                                        hintText: '닉네임',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: ColorBox.textColor),
                                        contentPadding: EdgeInsets.all(10)),
                                    key: const ValueKey(5),
                                  ),
                                  margin: EdgeInsets.only(left: 20,right: 20),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  child: TextFormField(
                                    keyboardType:
                                    TextInputType.emailAddress,
                                    key: const ValueKey(1),
                                    //유효성 검사
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains("@")) {
                                        return "Please enter at last 4 characters";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userEmail = value!;
                                    },
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: ColorBox.backColor,
                                        ),
                                        hintText: '가입 이메일',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: ColorBox.textColor),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  margin: EdgeInsets.only(left: 20,right: 20),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  child: TextFormField(
                                    obscureText: true,
                                    key: const ValueKey(2),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value.length < 4) {
                                        return "비밀번호를 확인해주세요.";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      userPassWord = value!;
                                    },
                                    onChanged: (value) {
                                      userPassWord = value;
                                    },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.password,
                                          color: ColorBox.backColor,
                                        ),
                                        hintText: '비밀번호',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: ColorBox.textColor),
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                  margin: EdgeInsets.only(left: 20,right: 20),
                                )
                              ],
                            )),
                      ),
                    if (!isSignupScreen)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  key: const ValueKey(3),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value.length < 6) {
                                      return "Password must ve at least 8 characters long.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
                                          color: ColorBox.backColor,
                                        ),
                                        hintText: '아이디',
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: ColorBox.textColor),
                                        contentPadding: EdgeInsets.all(10)),

                                ),
                                  margin: EdgeInsets.only(left: 20,right: 20),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: TextFormField(
                                  obscureText: true,
                                  key: const ValueKey(4),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value.length < 4) {
                                      return "Please enter at last 4 characters";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    userPassWord = value!;
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.password_sharp,
                                        color: ColorBox.backColor,
                                      ),
                                      hintText: '비밀번호',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: ColorBox.textColor),
                                      contentPadding: EdgeInsets.all(10)),
                                ),
                                margin: EdgeInsets.only(left: 20,right: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    if(!isSignupScreen)
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        width: 380,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isSignupScreen) {
                              _tryValidation();
                              try {
                                final newUser = await _authentication
                                    .createUserWithEmailAndPassword(
                                  email: userEmail,
                                  password: userPassWord,
                                );

                                await FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(newUser.user!.uid)
                                    .set({
                                  "userName": userName,
                                  "email": userEmail,
                                }); //파이어베이스에 user 라는 컬렉션에 name,email argument 생성

                                if (newUser.user != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CampNavigation()));
                                }
                              } catch (error) {
                                print(error);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("이메일이나 패스워드를 확인해주세요."),
                                  backgroundColor: Colors.blue,
                                ));
                              }
                            }
                            if (!isSignupScreen) {

                              _tryValidation();
                              try {
                                final newUser =
                                await _authentication.signInWithEmailAndPassword(
                                  email: userEmail,
                                  password: userPassWord,
                                );
                                if (newUser.user != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CampNavigation()));

                                }
                              } catch (error) {
                                print(error);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("이메일이나 패스워드를 확인해주세요."),
                                  backgroundColor: Colors.blue,
                                ));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              primary: ColorBox.backColor),
                          child: Center(
                            child: Text("로그인"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if(isSignupScreen)
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Container(
                        width: 380,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isSignupScreen) {

                              _tryValidation();
                              try {
                                final newUser = await _authentication
                                    .createUserWithEmailAndPassword(
                                  email: userEmail,
                                  password: userPassWord,
                                );
                                await FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(newUser.user!.uid)
                                    .set({
                                  "userName": userName,
                                  "email": userEmail,
                                }); //파이어베이스에 user 라는 컬렉션에 name,email argument 생성

                                if (newUser.user != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CampNavigation()));
                                }

                              } catch (error) {
                                print(error);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("이메일이나 패스워드를 확인해주세요."),
                                  backgroundColor: Colors.blue,
                                ));
                              }
                            }
                            if (!isSignupScreen) {
                              _tryValidation();
                              try {
                                final newUser =
                                await _authentication.signInWithEmailAndPassword(
                                  email: userEmail,
                                  password: userPassWord,
                                );
                                if (newUser.user != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CampNavigation()));
                                }
                              } catch (error) {
                                print(error);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("이메일이나 패스워드를 확인해주세요."),
                                  backgroundColor: Colors.blue,
                                ));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              primary: ColorBox.backColor),
                          child: Center(
                            child: Text("회원가입"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    widgetBox.loginContainer(() {
                      signup(context);
                    }, "구글 로그인", "lib/asset/google_lo.png")
                  ],
                ),
              ),
            ),
            //구글 로그인 버튼
          ],
        ),
      ),
    );
  }

}