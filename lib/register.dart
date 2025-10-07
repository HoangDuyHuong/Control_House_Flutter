import 'package:flutter/material.dart';
import 'local_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final reg = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    return reg.hasMatch(email);
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _handleRegister() async {
    final username = _usernameCtrl.text.trim();
    final email    = _emailCtrl.text.trim();
    final pass     = _passCtrl.text;

    if (username.isEmpty || email.isEmpty || pass.isEmpty) {
      _toast('Vui lòng nhập đủ Username/Email/Password');
      return;
    }
    if (!_isValidEmail(email)) {
      _toast('Email không đúng cú pháp (vd: abc@gmail.com)');
      return;
    }

    await LocalAuth.saveAccount(username: username, email: email, password: pass);
    await LocalAuth.setLoggedIn(false); // sau đăng ký quay về login

    // Quay về Login và TRẢ dữ liệu để tự điền
    if (!mounted) return;
    Navigator.pop(context, {
      'email': email,
      'password': pass,   // nếu không muốn auto-fill pass, bỏ dòng này
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _background(),
          // Trong _RegisterSection hiện tại của bạn:
          // - Gắn controller cho các ô
          // - Gán onTap của nút Register = _handleRegister
          _RegisterSection(
            usernameCtrl: _usernameCtrl,
            emailCtrl: _emailCtrl,
            passCtrl: _passCtrl,
            onRegister: _handleRegister,
          ),
          const _BackButtonOverlay(),
        ],
      ),
    );
  }
}


/* ================== BACKGROUND ================== */
class _background extends StatelessWidget {
  const _background();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: const [
          ColoredBox(color: Colors.white),

          // Giữ vị trí & màu bóng như login.dart
          _Circle(left: 30,  top: 150, size: 40, color: Color.fromRGBO(195, 210, 255, 1)),
          _Circle(left: 180, top: 60,  size: 40, color: Color.fromRGBO(255, 220, 220, 1)),
          _Circle(right: 30, top: 120, size: 40, color: Color.fromRGBO(255, 180, 230, 1)),
          _Circle(right: 30, bottom: 80, size: 45, color: Color.fromRGBO(255, 178, 210, 1)),
          _Circle(left: 40,  bottom: 100, size: 45, color: Color.fromRGBO(161, 255, 200, 1)),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double? left, right, top, bottom;
  final double size;
  final Color color;
  const _Circle({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.size,
    required this.color,
    // super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left, right: right, top: top, bottom: bottom,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

/* ================== REGISTER SECTION ================== */
class _RegisterSection extends StatelessWidget {
  final TextEditingController usernameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final VoidCallback onRegister;

  const _RegisterSection({
    // super.key,
    required this.usernameCtrl,
    required this.emailCtrl,
    required this.passCtrl,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 210, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 24),

            const Text('Username', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _InputBox(hint: 'Username', icon: Icons.person_outline, controller: usernameCtrl, keyboardType: TextInputType.name),
            const SizedBox(height: 16),

            const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _InputBox(hint: 'Email', icon: Icons.email_outlined, controller: emailCtrl, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),

            const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _InputBox(hint: 'Password', icon: Icons.lock_outline, controller: passCtrl, obscure: true),

            const SizedBox(height: 35),

            // Nút Register khác khung input
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.70, // 85% bề ngang, bạn chỉnh 0.75/0.7 tùy ý
                child: GestureDetector(
                onTap: onRegister,    
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E7CFF),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 20),

            Transform.translate(
              offset: const Offset(0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have an account ?  '),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* ===== INPUT BOX dùng chung – nhận controller ===== */
class _InputBox extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscure;

  const _InputBox({
    // super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F0F0), // xám nhạt
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller, 
          keyboardType: keyboardType,
          obscureText: obscure,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.black87),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

/* ================== BACK BUTTON OVERLAY ================== */
class _BackButtonOverlay extends StatelessWidget {
  const _BackButtonOverlay();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8),
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }
}
