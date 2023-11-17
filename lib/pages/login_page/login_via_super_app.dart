import 'package:smart_capture_mobile/pages/login_page/bloc/login_bloc.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc/login_event.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpcore/mpcore.dart';

class LoginViaSuperApp extends StatefulWidget {
  const LoginViaSuperApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginViaSuperApp();
}

class _LoginViaSuperApp extends State<LoginViaSuperApp> {
  late BuildContext providerContext;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) =>
        providerContext.read<LoginBloc>().add(const OtherAccountEvent()));
    Size size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(const LoginState(title: '', message: ''))),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(listener: (context, state) async {
            if (state is OtherAccountEventSuccess) {
              providerContext.read<LoginBloc>().add(const ReceiveTokenEvent());
            }
            if (state is ReceiveTokenEventSuccess) {
              providerContext
                  .read<LoginBloc>()
                  .add(InitUserInfoEvent(state.authInfo));
            }
            if (state is InitUserInfoEventSuccess) {
              providerContext.read<LoginBloc>().add(const SyncAppParamEvent());
            }
            if (state is SyncAppParamEventSuccess) {
              await Navigator.of(context).pushNamed('/my-home').then((value) {
                Navigator.of(context).pop();
              });
            }
          })
        ],
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            providerContext = context;
            return MPScaffold(
              body: SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/150percent.gif',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      state.title,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF041557),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF9AA1BC)),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
