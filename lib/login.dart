import 'package:flutter/material.dart';
// import 'package:loginscreen/local_auth.dart';
// import 'package:loginscreen/register.dart';
import 'homepage.dart';
import 'local_auth.dart';
import 'register.dart';

class mylogin extends StatefulWidget {
  const mylogin({super.key});
  @override
  State<mylogin> createState() => _myloginState();
}

class _myloginState extends State<mylogin> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();

  @override
  void initState() {
    super.initState();
    // tự điền email (và password nếu muốn) từ SharedPreferences
    LocalAuth.getSavedEmail().then((e) {
      if (e != null) _emailCtrl.text = e;
      // Nếu muốn auto-fill password luôn:
      LocalAuth.getSavedPassword().then((p) { if (p != null) _passCtrl.text = p; });
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // HÀM kiểm tra email (đơn giản & đủ cho bài tập)
  bool _isValidEmail(String email) {
    final reg = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    return reg.hasMatch(email);
  }

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      _toast('Vui lòng nhập Email và Password');
      return;
    }
    if (!_isValidEmail(email)) {
      _toast('Email không đúng cú pháp (vd: abc@gmail.com)');
      return;
    }

    final ok = await LocalAuth.validateLogin(email: email, password: pass);
    if (!ok) {
      // Sai thông tin → báo lỗi + gợi ý sang đăng ký
      _toast('Sai email hoặc mật khẩu');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Chưa có tài khoản?'),
          content: const Text('Bạn muốn tạo tài khoản mới không?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // đóng dialog
                // sang Register và CHỜ nhận dữ liệu điền sẵn khi quay lại
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
                if (result is Map) {
                  _emailCtrl.text = result['email'] ?? _emailCtrl.text;
                  _passCtrl.text  = result['password'] ?? _passCtrl.text;
                  setState(() {});
                }
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      );
      return;
    }

    await LocalAuth.setLoggedIn(true);

// chuyển sang Home và thay thế Login (không cho quay lại bằng nút back)
if (!mounted) return;
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home')),
);

// nếu muốn xoá sạch stack:
// Navigator.pushAndRemoveUntil(
//   context,
//   MaterialPageRoute(builder: (_) => const MyHomePage()),
//   (_) => false,
// );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // *** GIỮ nguyên bố cục giao diện bạn đã làm ***
    // CHỈ THAY: gán controllers & onTap cho các ô/nút trong _welcomesection
    return Scaffold(
      body: Stack(
        children: [
          const _background(),
          _welcomesection(
            emailCtrl: _emailCtrl,
            passCtrl: _passCtrl,
            onLogin: _handleLogin,
            onSignUpTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              );
              if (result is Map) {
                _emailCtrl.text = result['email'] ?? _emailCtrl.text;
                _passCtrl.text  = result['password'] ?? _passCtrl.text;
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}

//background
class _background extends StatelessWidget {
  const _background();

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Stack(
        children: [
          Container(color: Colors.white),
          _circle(left: 30, top: 150, size: 40, color: const Color.fromRGBO(195, 210, 255, 1)),
          _circle(left: 180, top: 60, size: 40, color: const Color.fromRGBO(255, 220, 220, 1)),
          _circle(right: 30, top: 120, size: 40, color: const Color.fromRGBO(255, 180, 230, 1)),
          _circle(right: 30, button: 80, size: 45, color: const Color.fromRGBO(255, 178, 210, 1)),
          _circle(left: 40, button: 100, size: 45, color: const Color.fromRGBO(161, 255, 200, 1)),
        ],
      )
    );
  }
Positioned _circle({
  double? left,
  double? right,
  double? top,
  double? button,
  required double size,
  required Color color,
})  {
return Positioned(
  left: left,
  right: right,
  top: top,
  bottom: button,
  child: Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  ),

 );

}
}

class _welcomesection extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final VoidCallback onLogin;
  final VoidCallback onSignUpTap;

  const _welcomesection({
    // super.key,
    required this.emailCtrl,
    required this.passCtrl,
    required this.onLogin,
    required this.onSignUpTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          // tăng top để Welcome + ảnh thấp xuống giống mockup
          padding: const EdgeInsets.fromLTRB(24, 140, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // GIỮ NGUYÊN kích thước & ảnh như bạn yêu cầu
              SizedBox(
                height: size.height * 0.3,
                child: Image.asset(
                  "img/Research paper-pana.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // ---- Nhóm form: cùng một padding 2 bên, cùng bề rộng ----
              // Email
              SizedBox(
                width: 350,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(242, 240, 240, 1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      hintText: 'Email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Password
              SizedBox(
                width: 350,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 48,
                  decoration: BoxDecoration(
                    color:  const Color.fromRGBO(242, 240, 240, 1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      hintText: 'Password',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // LOGIN button (cùng width và cùng mép với 2 ô trên)
              SizedBox(
                width: 250,
                child: GestureDetector(
                  onTap: () => onLogin(),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(168, 131, 255, 1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Text('OR', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ?  "),
                  GestureDetector(
                    onTap: () => onSignUpTap(),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

