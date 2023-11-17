import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/base_widgets/my_label_widget.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/detail_album_dto.dart';
import 'package:smart_capture_mobile/enum/album_customer_type_enum.dart';
import 'package:smart_capture_mobile/enum/create_album_error.dart';
import 'package:smart_capture_mobile/pages/create_album_page/bloc/create_album_bloc.dart';
import 'package:smart_capture_mobile/pages/create_album_page/bloc/create_album_event.dart';
import 'package:smart_capture_mobile/pages/create_album_page/bloc/create_album_state.dart';
import 'package:smart_capture_mobile/pages/create_album_page/widgets/create_new_album_error_message_widget.dart';
import 'package:smart_capture_mobile/pages/create_album_page/widgets/create_new_album_limit_exceeded_error_widget.dart';
import 'package:smart_capture_mobile/pages/create_album_page/widgets/create_new_album_text_field_error_widget.dart';
import 'package:smart_capture_mobile/pages/create_album_page/widgets/create_new_album_text_field_widget.dart';
import 'package:smart_capture_mobile/pages/master_page.dart';
import 'package:smart_capture_mobile/pages/master_page_with_loading.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';

class CreateNewAlbumPage extends StatefulWidget {
  final int limitAlbumParam;

  const CreateNewAlbumPage({
    required this.limitAlbumParam,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateNewAlbumPageState();
}

class _CreateNewAlbumPageState extends State<CreateNewAlbumPage>
    with TopSnackBarUtil {
  final String name = 'Tạo Album';
  final TextEditingController identityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final LoadStatusController c = Get.put(LoadStatusController());
  late BuildContext providerContext;
  late CreateAlbumState _createAlbumState;

  @override
  void initState() {
    super.initState();
    identityController.addListener(() {
      providerContext.read<CreateAlbumBloc>().add(
            OnTextChangedEvent(
              identityController.text,
              nameController.text,
            ),
          );
    });
    nameController.addListener(() {
      providerContext.read<CreateAlbumBloc>().add(
            OnTextChangedEvent(
              identityController.text,
              nameController.text,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    providerContext = context;
    return BlocProvider<CreateAlbumBloc>(
      create: (context) => CreateAlbumBloc(const CreateAlbumState(
        customerType: CustomerType.khcn,
        currentIdentity: '',
        isEnable: false,
        errorName: null,
        errorNumber: null,
        error: null,
      )),
      child: BlocListener<CreateAlbumBloc, CreateAlbumState>(
        listener: (context, state) async {
          if (state is SingleSelectEventSuccess) {
            identityController.clear();
            nameController.clear();
          }

          if (state is CheckLimitEventSuccess) {
            providerContext.read<CreateAlbumBloc>().add(
                  CheckCustomerIdentityEvent(
                    identityController.text,
                    nameController.text,
                    _createAlbumState.error,
                  ),
                );
          }
          if (state is CheckLimitEventError) {
            c.stopLoadingAndSync();
          }

          if (state is CheckCustomerIdentityEventError) {
            c.stopLoadingAndSync();
          }

          if (state is CheckCustomerIdentityEventSuccess) {
            providerContext.read<CreateAlbumBloc>().add(
                  SaveAlbumEvent(
                    state.customerType.name,
                    identityController.text,
                    state.customerName,
                    state.customerCode,
                    state.error,
                  ),
                );
          }

          if (state is SaveAlbumEventSuccess) {
            c.stopLoadingAndSync();
            await Navigator.of(context)
                .pushNamed('/detail-album',
                    arguments: DetailAlbumDto(
                      albumDto: state.albumDto,
                      albumName: state.albumDto.metadata!.captureName!,
                      createAlbumSuccess: true,
                    ))
                .then((value) => Navigator.of(context).pop(value));
          }

          if (state is SaveAlbumEventError) {
            c.stopLoadingAndSync();
            await showError(
                'Tạo album không thành công. Vui lòng kiểm tra lại kết nối internet và thử lại');
          }

          if (state is OnTextChangedEventComplete) {
            if (state.isClearNameController) {
              nameController.clear();
            }
          }
        },
        child: MasterPageWithLoading(
          childWidget: MasterPage(
            name: name,
            barColor: Colors.black,
            backgroundBarColor: Colors.white,
            floatingBody: BlocBuilder<CreateAlbumBloc, CreateAlbumState>(
              builder: (context, state) {
                return MyButton(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  backgroundColor:
                      state.isEnable ? const Color(0xFF4A6EF6) : const Color(0xFFE6E8EE),
                  text: 'Lưu',
                  onTap: () {
                    HideKeyBoard.hidKeyBoard();
                    c.startLoading();
                    providerContext.read<CreateAlbumBloc>().add(
                          CheckLimitEvent(
                            widget.limitAlbumParam,
                          ),
                        );
                  },
                  height: 50,
                  isDisable: !state.isEnable,
                );
              },
            ),
            child: SingleChildScrollView(
              reverse: true,
              child: BlocBuilder<CreateAlbumBloc, CreateAlbumState>(
                builder: (context, state) {
                  providerContext = context;
                  _createAlbumState = state;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyLabelWidget(
                          text: 'Loại khách hàng',
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Row(
                          children: CustomerType.values
                              .map(
                                (e) => GestureDetector(
                                  // onTap: () => providerContext
                                  //     .read<CreateAlbumBloc>()
                                  //     .add(SingleSelectEvent(e)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: e.isSelected(state.customerType)
                                            ? Image.asset(
                                                'assets/icons/radio_is_checked_icon.svg',
                                                width: 20,
                                                height: 20,
                                              )
                                            : Image.asset(
                                                'assets/icons/radio_icon.svg',
                                                width: 20,
                                                height: 20,
                                                color: const Color(0xFFABACAE),
                                              ),
                                      ),
                                      e.isSelected(state.customerType)
                                          ? Text(e.text)
                                          : Text(
                                              e.text,
                                              style: const TextStyle(
                                                color: Color(0xFF797a7d),
                                              ),
                                            ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        MyLabelWidget(
                          text: state.customerType == CustomerType.khcn
                              ? 'Số giấy tờ tùy thân KH'
                              : 'Mã số thuế/ Đăng ký kinh doanh',
                          padding: const EdgeInsets.only(bottom: 5),
                        ),
                        CreateNewAlbumTextFieldWidget(
                          controller: identityController,
                          textInputType: TextInputType.number,
                          placeholder: state.customerType == CustomerType.khcn
                              ? 'CMND/CCCD/Hộ chiếu'
                              : 'MST/GPĐKKD',
                          isError: state.errorNumber != null,
                        ),
                        if (state is CheckLimitEventError)
                          const CreateNewAlbumLimitExceededErrorWidget(),
                        if (state.errorNumber != null)
                          CreateNewAlbumTextFiledErrorWidget(
                              textError: state.errorNumber),
                        if (state.error == CreateAlbumError.notInfo)
                          const CreateNewAlbumErrorMessageWidget(
                              text:
                                  'Khách hàng chưa có thông tin tại MB\nVui lòng nhập thông tin để tiếp tục'),
                        if (state.error == CreateAlbumError.canNotGetInfo)
                          const CreateNewAlbumErrorMessageWidget(
                              text:
                                  'Hiện tại chưa thể lấy được thông tin KH\nVui lòng nhập thông tin để tiếp tục'),
                        if (state.error == CreateAlbumError.groupsIsNull)
                          const CreateNewAlbumErrorMessageWidget(
                              text:
                                  'Vui lòng cấu hình chi nhánh và đăng nhập lại để tiếp tục'),
                        if (state.error != null &&
                            state.error != CreateAlbumError.groupsIsNull)
                          MyLabelWidget(
                            text: state.customerType == CustomerType.khcn
                                ? 'Họ và tên khách hàng'
                                : 'Tên doanh nghiệp',
                            padding: const EdgeInsets.only(bottom: 5),
                          ),
                        if (state.error != null &&
                            state.error != CreateAlbumError.groupsIsNull)
                          CreateNewAlbumTextFieldWidget(
                            controller: nameController,
                            textInputType: TextInputType.name,
                            placeholder: '',
                            maxLength: 100,
                            isError: state.errorName != null,
                          ),
                        if (state.errorName != null)
                          CreateNewAlbumTextFiledErrorWidget(
                              textError: state.errorName),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 105,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
