import 'package:flutter/material.dart';
import 'package:work_calendar/modules/login/login_page.dart';
import 'package:work_calendar/shared/app_colors.dart';
import 'package:work_calendar/shared/success_alert.dart';
import 'package:work_calendar/view_models/auth/change_password_view_model.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChangePasswordPage> {

  String? _errorUsernameText;
  String? _errorCurrentPasswordText;
  String? _errorNewPasswordText;
  String? _errorConfirmPasswordText;

  final TextEditingController _txtUsernameCtrl = TextEditingController();
  final TextEditingController _txtCurrentPasswordCtrl = TextEditingController();
  final TextEditingController _txtNewPasswordCtrl = TextEditingController();
  final TextEditingController _txtConfirmPasswordCtrl = TextEditingController();

  @override

  void initState() {
    super.initState();

    _errorUsernameText = null;
    _errorCurrentPasswordText = null;
    _errorNewPasswordText = null;
    _errorConfirmPasswordText = null;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: screenHeight * 0.2,
            left: screenHeight * 0.02,
            right: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              _getTextFieldWidget(_txtUsernameCtrl, 'Username', _errorUsernameText, false),
              SizedBox(height: screenHeight * .025),
              _getTextFieldWidget(_txtCurrentPasswordCtrl, 'Current Password', _errorCurrentPasswordText, true),
              SizedBox(height: screenHeight * .025),
              _getTextFieldWidget(_txtNewPasswordCtrl, 'New Password', _errorNewPasswordText, true),
              SizedBox(height: screenHeight * .025),
              _getTextFieldWidget(_txtConfirmPasswordCtrl, 'Confirm Password', _errorConfirmPasswordText, true),
              SizedBox(height: screenHeight * .04),
              _getLoginButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTextFieldWidget(TextEditingController controller, String lable, String? errorText, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          label: Text(lable),
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          )
      ),
    );
  }

  Widget _getLoginButtonWidget() {
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onChangePasswordPressed,
        child: const Text(
          'Change your password',
          style: TextStyle(
              fontSize: 18.0
          ),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
            primary: AppColors.bluePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )
        ),
      ),
    );
  }

  bool validate() {

    bool isValid = true;

    if(_txtUsernameCtrl.text.isEmpty){
      setState(() {
        _errorUsernameText = 'Username is required!';
      });
      isValid = false;
    }

    if(_txtCurrentPasswordCtrl.text.isEmpty){
      setState(() {
        _errorCurrentPasswordText = 'Current password is required!';
      });
      isValid = false;
    }

    if(_txtNewPasswordCtrl.text.isEmpty){
      setState(() {
        _errorNewPasswordText = 'New password is required!';
      });
      isValid = false;
    }

    if(_txtConfirmPasswordCtrl.text.isEmpty){
      setState(() {
        _errorConfirmPasswordText = 'Confirm password is required!';
      });
      isValid = false;
    }

    if(_txtNewPasswordCtrl.text != _txtConfirmPasswordCtrl.text){
      setState(() {
        _errorConfirmPasswordText = 'Confirm password is not match';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _onChangePasswordPressed() async {
    var changePasswordViewModel = ChangePasswordViewModel();
    String username = _txtUsernameCtrl.text;
    String currentPassword = _txtCurrentPasswordCtrl.text;
    String newPassword = _txtNewPasswordCtrl.text;

    if(validate()) {
      await changePasswordViewModel.changePassword(username, currentPassword, newPassword);
      if (changePasswordViewModel.error == '') {
        SuccessAlert().successAlert(
          context: context,
          content: 'Change password successfully!',
          okFunction: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => const LoginPage(),
              )
            )
          }
        );
      } else {
        setState(() {
          _errorUsernameText = 'Incorrect username or password';
        });
        setState(() {
          _errorCurrentPasswordText = 'Incorrect username or password';
        });
      }
    }
  }
}
