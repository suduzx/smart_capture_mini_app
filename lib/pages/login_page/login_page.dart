import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/base_widgets/my_text_field.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/enum/login_error_enum.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc/login_bloc.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc/login_event.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc/login_state.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc_dev/login_dev_bloc.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc_dev/login_dev_event.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc_dev/login_dev_state.dart';
import 'package:smart_capture_mobile/pages/login_page/widgets/login_page_welcome_input_widget.dart';
import 'package:smart_capture_mobile/pages/login_page/widgets/login_page_error_message_widget.dart';
import 'package:smart_capture_mobile/pages/login_page/widgets/login_page_welcome_user_widget.dart';
import 'package:smart_capture_mobile/pages/master_page_with_loading.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoadStatusController c = Get.put(LoadStatusController());
  late BuildContext providerContext;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      c.stopLoadingAndSync();
    });
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(const LoginState(title: '', message: '')),
        ),
        BlocProvider<LoginDevBloc>(
          create: (context) => LoginDevBloc(const LoginDevState(userLocal: null))
            ..add(const CheckUserLocalEvent()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginDevBloc, LoginDevState>(
              listener: (context, state) async {
            if (state is CheckUserLocalEventSuccess) {
              c.stopLoadingAndSync();
              if (state.userLocal != null) {
                userController.text = state.userLocal!.username;
              }
            }
            if (state is SignInEventSuccess) {
              userController.clear();
              passwordController.clear();
              providerContext
                  .read<LoginBloc>()
                  .add(InitUserInfoEvent(state.authInfo));
            }
            if (state is SignInEventError) {
              c.stopLoadingAndSync();
            }
          }),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) async {
              if (state is OtherAccountEventSuccess) {
                userController.clear();
                passwordController.clear();
                providerContext.read<LoginDevBloc>().add(const CheckUserLocalEvent());
              }
              if (state is InitUserInfoEventSuccess) {
                providerContext.read<LoginBloc>().add(const SyncAppParamEvent());
              }
              if (state is SyncAppParamEventSuccess) {
                c.stopLoadingAndSync();
                await Navigator.of(context).pushNamed('/my-home').then(
                    (value) => providerContext
                        .read<LoginDevBloc>()
                        .add(const CheckUserLocalEvent()));
              }
            },
          ),
        ],
        child: MasterPageWithLoading(
          childWidget: MPScaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              reverse: true,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 0,
                    child: Image.asset(
                      "assets/images/Illu_CRM_1.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocBuilder<LoginDevBloc, LoginDevState>(
                        builder: (context, state) {
                      providerContext = context;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 200),
                          SizedBox(
                            height: 65,
                            child: Image.asset(
                              "assets/images/logoMB.svg",
                              height: 65,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (state.userLocal != null &&
                              state.userLocal!.accessTokenInfo != null)
                            LoginPageWelcomeUserWidget(
                                name: state.userLocal!.accessTokenInfo!.name ??
                                    '')
                          else
                            LoginPageWelcomeInputWidget(
                              userController: userController,
                              errorValue: (state is SignInEventError)
                                  ? state.errorValue
                                  : null,
                            ),
                          MyTextField(
                            startIcon: 'assets/icons/password_icon.svg',
                            controller: passwordController,
                            hidden: true,
                            placeholder: 'Mật khẩu',
                            borderRadius: 8.0,
                            borderColor: Color(state is SignInEventError
                                ? (state.errorValue != LoginErrorValue.username
                                    ? 0xFFFF4A4A
                                    : 0xFFE6E8EB)
                                : 0xFFE6E8EB),
                          ),
                          if (state is SignInEventError)
                            LoginPageErrorMessageWidget(errorText: state.error)
                          else
                            const SizedBox(height: 15),
                          MyButton(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            width: double.infinity,
                            border: 8.0,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 55,
                            text: 'ĐĂNG NHẬP',
                            onTap: () {
                              c.startLoading();
                              HideKeyBoard.hidKeyBoard();
                              providerContext
                                  .read<LoginDevBloc>()
                                  .add(SignInEvent(
                                    userController.text,
                                    passwordController.text,
                                    state.userLocal,
                                  ));
                            },
                          ),
                          if (state.userLocal != null)
                            MyButton(
                              padding: EdgeInsets.zero,
                              margin: const EdgeInsets.only(top: 15),
                              width: double.infinity,
                              color: const Color(0xFF4F5B89),
                              backgroundColor: const Color(0xFFF6F8FF),
                              border: 8.0,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 55,
                              text: 'Tài khoản khác',
                              onTap: () => providerContext
                                  .read<LoginBloc>()
                                  .add(const OtherAccountEvent()),
                            )
                          else
                            Container(),
                          const SizedBox(height: 15),
                        ],
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 105,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
