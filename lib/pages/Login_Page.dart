import 'package:flutter/material.dart';
import 'project_details_page.dart';
import 'Projects_model.dart';

class LoginPage extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;

  LoginPage({required this.toggleTheme});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedLanguage = 'Türkçe';
  bool _isLoginMode = true;
  ThemeMode _currentThemeMode = ThemeMode.system;

  final List<String> _languages = ['Türkçe', 'English'];
  final List<ThemeMode> _themeModes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Map<String, Map<String, String>> _localizedTexts = {
    'Türkçe': {
      'appName': 'Projify',
      'welcomeText': 'Hoş Geldiniz!',
      'createAccount': 'Hesap Oluştur',
      'login': 'Giriş Yap',
      'register': 'Kayıt Ol',
      'username': 'Kullanıcı Adı',
      'email': 'E-posta',
      'password': 'Şifre',
      'confirmPassword': 'Şifreyi Onayla',
      'noAccount': 'Hesabınız yok mu? Kayıt Olun',
      'haveAccount': 'Zaten bir hesabınız var mı? Giriş Yapın',
      'selectLanguage': 'Dil Seçin',
      'selectTheme': 'Tema Seçin',
      'lightTheme': 'Açık Tema',
      'darkTheme': 'Koyu Tema',
      'systemTheme': 'Sistem Teması',
    },
    'English': {
      'appName': 'Projify',
      'welcomeText': 'Welcome!',
      'createAccount': 'Create Account',
      'login': 'Login',
      'register': 'Register',
      'username': 'Username',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'noAccount': 'Don\'t have an account? Register',
      'haveAccount': 'Already have an account? Login',
      'selectLanguage': 'Select Language',
      'selectTheme': 'Select Theme',
      'lightTheme': 'Light Theme',
      'darkTheme': 'Dark Theme',
      'systemTheme': 'System Theme',
    },
  };

  String _getLocalizedText(String key) {
    return _localizedTexts[_selectedLanguage]?[key] ?? key;
  }

  void _selectLanguage(String? language) {
    if (language != null) {
      setState(() {
        _selectedLanguage = language;
      });
    }
  }

  void _selectTheme(ThemeMode? themeMode) {
    if (themeMode != null) {
      setState(() {
        _currentThemeMode = themeMode;
        widget.toggleTheme(themeMode);
      });
    }
  }

  String _getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return _getLocalizedText('systemTheme');
      case ThemeMode.light:
        return _getLocalizedText('lightTheme');
      case ThemeMode.dark:
        return _getLocalizedText('darkTheme');
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  void _handleAuth() {
    if (_isLoginMode) {
      _performLogin();
    } else {
      _performRegistration();
    }
  }

  void _performLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      User currentUser = User(
        id: '1',  // Örnek bir id
        username: username,
        email: '${username}@example.com', // Basit bir örnek e-posta
        currentProjects: [],  // Mevcut projeler
        completedProjects: [],  // Tamamlanmış projeler
        totalDelayedProjects: 0,  // Gecikmiş projeler
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectDetailsPage(
            projects: [],             // Mevcut projeler
            currentUser: currentUser,  // Doğru kullanıcı nesnesi
            initialLanguage: _selectedLanguage,
            initialThemeMode: _currentThemeMode,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getLocalizedText('emptyFields'))),
      );
    }
  }

  void _performRegistration() {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getLocalizedText('fillAllFields'))),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getLocalizedText('passwordMismatch'))),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_getLocalizedText("register")} ${_getLocalizedText("success")}: $username')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.dashboard,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          _getLocalizedText('appName'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        PopupMenuButton<ThemeMode>(
                          initialValue: _currentThemeMode,
                          onSelected: _selectTheme,
                          itemBuilder: (BuildContext context) {
                            return _themeModes.map((ThemeMode themeMode) {
                              return PopupMenuItem<ThemeMode>(
                                value: themeMode,
                                child: Text(_getThemeModeName(themeMode)),
                              );
                            }).toList();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.palette, color: Theme.of(context).colorScheme.secondary),
                              SizedBox(width: 5),
                              Text(_getThemeModeName(_currentThemeMode)),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        PopupMenuButton<String>(
                          initialValue: _selectedLanguage,
                          onSelected: _selectLanguage,
                          itemBuilder: (BuildContext context) {
                            return _languages.map((String language) {
                              return PopupMenuItem<String>(
                                value: language,
                                child: Text(language),
                              );
                            }).toList();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.language, color: Theme.of(context).colorScheme.secondary),
                              SizedBox(width: 5),
                              Text(_selectedLanguage),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Column(
                children: [
                  Text(
                    _isLoginMode ? _getLocalizedText('welcomeText') : _getLocalizedText('createAccount'),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 150),
                    padding: EdgeInsets.all(24),
                    constraints: BoxConstraints(
                      minHeight: 400, // Buraya istediğiniz minimum yükseklik değerini yazabilirsiniz
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isLoginMode ? _getLocalizedText('login') : _getLocalizedText('register'),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: _getLocalizedText('username'),
                            prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.secondary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                            ),
                          ),
                        ),
                        if (!_isLoginMode) SizedBox(height: 16),
                        if (!_isLoginMode)
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: _getLocalizedText('email'),
                              prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.secondary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: _getLocalizedText('password'),
                            prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.secondary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                            ),
                          ),
                          obscureText: true,
                        ),
                        if (!_isLoginMode) SizedBox(height: 16),
                        if (!_isLoginMode)
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: _getLocalizedText('confirmPassword'),
                              prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.secondary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
                              ),
                            ),
                            obscureText: true,
                          ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _handleAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Theme.of(context).colorScheme.onSurface,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Text(_isLoginMode ? _getLocalizedText('login') : _getLocalizedText('register')),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: _toggleAuthMode,
                          child: Text(
                            _isLoginMode ? _getLocalizedText('noAccount') : _getLocalizedText('haveAccount'),
                            style: TextStyle(
                            ),
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
