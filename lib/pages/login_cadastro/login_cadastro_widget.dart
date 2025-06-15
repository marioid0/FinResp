import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';

import 'login_cadastro_model.dart';
export 'login_cadastro_model.dart';

class LoginCadastroWidget extends StatefulWidget {
  const LoginCadastroWidget({super.key});

  static const String routeName = 'loginCadastro';
  static const String routePath = '/loginCadastro';

  @override
  State<LoginCadastroWidget> createState() => _LoginCadastroWidgetState();
}

class _LoginCadastroWidgetState extends State<LoginCadastroWidget>
    with TickerProviderStateMixin {
  late LoginCadastroModel _model;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginCadastroModel());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );

    _model.nomeCreateTextController ??= TextEditingController();
    _model.nomeCreateFocusNode ??= FocusNode();

    _model.emailAddressCreateTextController ??= TextEditingController();
    _model.emailAddressCreateFocusNode ??= FocusNode();

    _model.passwordCreateTextController ??= TextEditingController();
    _model.passwordCreateFocusNode ??= FocusNode();

    _model.passwordConfirmTextController ??= TextEditingController();
    _model.passwordConfirmFocusNode ??= FocusNode();

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                // Header with animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildHeader(),
                  ),
                ),
                // Tab content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildTabContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // Logo or Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'FinResp',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gerencie suas finanças com inteligência',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _model.tabBarController,
              labelColor: Colors.white,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              tabs: const [
                Tab(text: 'Entrar'),
                Tab(text: 'Cadastrar'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _model.tabBarController,
              children: [
                _buildLoginTab(),
                _buildSignUpTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              const SizedBox(height: 20),
              _buildTextField(
                controller: _model.emailAddressTextController,
                focusNode: _model.emailAddressFocusNode,
                labelText: 'Email',
                hintText: 'Digite seu email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _model.passwordTextController,
                focusNode: _model.passwordFocusNode,
                labelText: 'Senha',
                hintText: 'Digite sua senha',
                prefixIcon: Icons.lock_outline,
                obscureText: !_model.passwordVisibility,
                suffixIcon: IconButton(
                  icon: Icon(
                    _model.passwordVisibility
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => safeSetState(
                    () => _model.passwordVisibility = !_model.passwordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildGradientButton(
                text: 'Entrar',
                onPressed: () async {
                  GoRouter.of(context).prepareAuthEvent();
                  final user = await authManager.signInWithEmail(
                    context,
                    _model.emailAddressTextController.text,
                    _model.passwordTextController.text,
                  );
                  if (user != null) {
                    context.goNamedAuth(HomePageWidget.routeName, context.mounted);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Implement forgot password
                },
                child: Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpTab() {
    return AnimationLimiter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _model.nomeCreateTextController,
                  focusNode: _model.nomeCreateFocusNode,
                  labelText: 'Nome',
                  hintText: 'Digite seu nome completo',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _model.emailAddressCreateTextController,
                  focusNode: _model.emailAddressCreateFocusNode,
                  labelText: 'Email',
                  hintText: 'Digite seu email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _model.passwordCreateTextController,
                  focusNode: _model.passwordCreateFocusNode,
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_model.passwordCreateVisibility,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _model.passwordCreateVisibility
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => safeSetState(
                      () => _model.passwordCreateVisibility = !_model.passwordCreateVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _model.passwordConfirmTextController,
                  focusNode: _model.passwordConfirmFocusNode,
                  labelText: 'Confirmar Senha',
                  hintText: 'Confirme sua senha',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_model.passwordConfirmVisibility,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _model.passwordConfirmVisibility
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => safeSetState(
                      () => _model.passwordConfirmVisibility = !_model.passwordConfirmVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildGradientButton(
                  text: 'Criar Conta',
                  onPressed: () async {
                    if (_model.passwordCreateTextController.text !=
                        _model.passwordConfirmTextController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('As senhas não coincidem')),
                      );
                      return;
                    }

                    GoRouter.of(context).prepareAuthEvent();
                    final user = await authManager.createAccountWithEmail(
                      context,
                      _model.emailAddressCreateTextController.text,
                      _model.passwordCreateTextController.text,
                    );
                    if (user != null) {
                      await UsuariosTable().insert({
                        'user_id': currentUserUid,
                        'nome': _model.nomeCreateTextController.text,
                        'email': _model.emailAddressCreateTextController.text,
                      });
                      context.goNamedAuth(HomePageWidget.routeName, context.mounted);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}