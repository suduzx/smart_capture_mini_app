import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/base_widgets/my_drop_down.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/controllers/my_drop_down_controller.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/tree_value_sync_bpm_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/list_view_item_dto.dart';
import 'package:smart_capture_mobile/pages/master_page.dart';
import 'package:smart_capture_mobile/pages/master_page_with_loading.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/bloc/upload_bpm_bloc.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/bloc/upload_bpm_event.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/bloc/upload_bpm_state.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/widgets/upload_bpm_error_widget.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/widgets/upload_bpm_text_widget.dart';

class UploadBPMPage extends StatefulWidget {
  final TreeValueSyncBPMDto treeValueSyncBPMDto;

  const UploadBPMPage({
    Key? key,
    required this.treeValueSyncBPMDto,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UploadBPMPage();
}

class _UploadBPMPage extends State<UploadBPMPage> {
  final LoadStatusController c = Get.put(LoadStatusController());
  final MyDropDownController systemController =
      Get.put(MyDropDownController(), tag: 'HeThong');
  final MyDropDownController planController =
      Get.put(MyDropDownController(), tag: 'MaPhuongAn');
  final MyDropDownController codeFileController =
      Get.put(MyDropDownController(), tag: 'CodeFile');

  late BuildContext providerContext;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((_) => c.startLoading());
  }

  @override
  void dispose() {
    super.dispose();
    systemController.clearDisplayText();
    planController.clearDisplayText();
    codeFileController.clearDisplayText();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UploadBPMBloc>(
      create: (context) => UploadBPMBloc(const UploadBPMState(
        loanInfoDtos: [],
        docCodeDtos: [],
        codeT24: '',
      )),
      child: BlocListener<UploadBPMBloc, UploadBPMState>(
        listener: (context, state) async {
          if (state is GetLoanInfoAndDocCodeEventSuccess) {
            planController.clearDisplayText();
            codeFileController.clearDisplayText();
            c.stopLoadingAndSync();
          }
          if (state is GetLoanInfoAndDocCodeEventError) {
            c.stopLoadingAndSync();
          }

          if (state is SyncBPMEventComplete) {
            c.stopLoadingAndSync();
            Navigator.pop(context, state);
          }
        },
        child: MasterPageWithLoading(
          childWidget: MasterPage(
            name: 'Upload',
            backgroundBarColor: Colors.white,
            barColor: Colors.black,
            floatingBody: Container(
              margin: const EdgeInsets.all(20),
              child: Obx(
                () {
                  return MyButton(
                    width: double.infinity,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    backgroundColor:
                        codeFileController.dropDownDisplayText.value.isEmpty ||
                                planController.dropDownDisplayText.value.isEmpty
                            ? const Color(0xFFE6E8EE)
                            : const Color(0xFF4A6EF6),
                    text: 'UPLOAD',
                    onTap: () async {
                      c.startLoading();
                      String docCode =
                          codeFileController.dropDownDisplayText.value;
                      widget.treeValueSyncBPMDto.root!.properties!
                              .bpmDocumentCode =
                          docCode.substring(0, docCode.indexOf('-') - 1);
                      widget.treeValueSyncBPMDto.root!.properties!.bpmLoanId =
                          planController.dropDownDisplayText.value;
                      providerContext.read<UploadBPMBloc>().add(
                            SyncBPMEvent(
                              treeValueSyncBPMDto: widget.treeValueSyncBPMDto,
                            ),
                          );
                    },
                    height: 50,
                    isDisable:
                        codeFileController.dropDownDisplayText.value.isEmpty ||
                            planController.dropDownDisplayText.value.isEmpty,
                  );
                },
              ),
            ),
            child: BlocBuilder<UploadBPMBloc, UploadBPMState>(
              builder: (context, state) {
                providerContext = context;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      /// Tải lên hệ thống
                      const UploadBPMTextWidget(text: 'Tải lên hệ thống'),
                      MyDropDown(
                        controller: systemController,
                        items: [
                          ListViewItemDto(
                            value: 'BPM KHCN',
                            text: 'BPM KHCN',
                            isSelected: false,
                          )
                        ],
                        bottomSheetText: 'Chọn hệ thống',
                        placeholder: 'Tìm hệ thống',
                        buttonIsDisplayed: true,
                        callBack: (List<String> selectedItems) {
                          c.startLoading();
                          providerContext
                              .read<UploadBPMBloc>()
                              .add( GetLoanInfoAnDocCodeEvent(
                                albumId: widget.treeValueSyncBPMDto.albumId!,
                                statusId: 171,
                              ));
                          debugPrint(selectedItems.first);
                        },
                      ),
                      const SizedBox(height: 10),

                      /// Nếu hệ thống không có mã phương án nào
                      if (state is GetLoanInfoAndDocCodeEventError)
                        UploadBPMErrorWidget(
                            text: state.message ?? 'UploadBPMErrorWidget'),

                      /// Nếu hệ thống đã có mã phương án
                      if (state.docCodeDtos.isNotEmpty &&
                          state.loanInfoDtos.isNotEmpty)
                        Column(
                          children: [
                            /// Mã phương án
                            const UploadBPMTextWidget(text: 'Mã phương án'),
                            MyDropDown(
                              controller: planController,
                              items: state.loanInfoDtos
                                  .map((e) => ListViewItemDto(
                                        value: e.loanId,
                                        text: e.loanId,
                                        isSelected: false,
                                      ))
                                  .toList(),
                              bottomSheetText: 'Chọn mã phương án',
                              placeholder: 'Tìm phương án',
                              buttonIsDisplayed: true,
                              callBack: (List<String> selectedItems) {},
                            ),
                            const SizedBox(height: 10),

                            /// Codefile
                            const UploadBPMTextWidget(text: 'Codefile'),
                            MyDropDown(
                              controller: codeFileController,
                              items: state.docCodeDtos
                                  .map((e) => ListViewItemDto(
                                        value:
                                            '${e.docCode} - ${e.description}',
                                        text: '${e.docCode} - ${e.description}',
                                        isSelected: false,
                                      ))
                                  .toList(),
                              bottomSheetText: 'Chọn Codefile',
                              placeholder: 'Tìm codefile',
                              buttonIsDisplayed: true,
                              callBack: (List<String> selectedItems) {},
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
