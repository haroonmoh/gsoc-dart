import 'package:flutter/material.dart';
import 'package:gsoc_application/classes/fc_user.dart';


class FlutterCommunityLogin extends StatefulWidget {
  const FlutterCommunityLogin({Key? key, required this.loginCallback}) : super(key: key);

  final Function loginCallback;

  @override
  State<FlutterCommunityLogin> createState() => _FlutterCommunityLoginState();
}

class _FlutterCommunityLoginState extends State<FlutterCommunityLogin> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          width: double.infinity,
          color: const Color(0xFF0578bf),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 150, 50, 130),
            child: Image.asset(
              'assets/fc_circle.png',
              height: 80,
            ),
          ),
        ),
        const SizedBox(
          height: 150,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
            onPressed: () async {
              final FCAdminUser fcAdminUser = FCAdminUser();
              bool authStatus = await fcAdminUser.githubSignIn(context); 
              if(authStatus) {
                widget.loginCallback(true, fcAdminUser);
              }
            },
            child: const Text('Login with Github'),
            style: ElevatedButton.styleFrom(
              primary: Colors.black87
            ),
          ),
        ),
      ]),
    );
  }
}
