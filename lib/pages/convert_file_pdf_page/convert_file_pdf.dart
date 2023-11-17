import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/base_widgets/my_sync_widget.dart';
import 'package:smart_capture_mobile/base_widgets/my_text_field.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/convert_file_pdf_dto.dart';
import 'package:smart_capture_mobile/pages/convert_file_pdf_page/bloc/pdf_bloc.dart';
import 'package:smart_capture_mobile/pages/convert_file_pdf_page/bloc/pdf_event.dart';
import 'package:smart_capture_mobile/pages/convert_file_pdf_page/bloc/pdf_state.dart';
import 'package:smart_capture_mobile/pages/master_page.dart';
import 'package:smart_capture_mobile/pages/master_page_with_loading.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';

class ConvertFilePDFPage extends StatefulWidget {
  final ConvertFilePDFDto convertFilePDFDto;

  const ConvertFilePDFPage({
    required this.convertFilePDFDto,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConvertFilePDFPage();
}

class _ConvertFilePDFPage extends State<ConvertFilePDFPage>
    with TopSnackBarUtil {
  final LoadStatusController c = Get.put(LoadStatusController());

  final TextEditingController pdfNameController = TextEditingController();
  late BuildContext providerContext;

  @override
  void initState() {
    super.initState();
    pdfNameController.addListener(() {
      providerContext
          .read<PdfBloc>()
          .add(CheckDisableConvertEvent(pdfNameController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<PdfBloc>(
      create: (context) => PdfBloc(const PdfState(isDisableConvert: true)),
      child: BlocListener<PdfBloc, PdfState>(
        listener: (context, state) async {
          if (state is ConvertPdfEventSuccess) {
            await Future.delayed(const Duration(seconds: 1), () {
              c.stopLoadingAndSync();
              Navigator.pop(context, true);
            });
          }
          if (state is ConvertPdfEventError) {
            c.stopLoadingAndSync();
            await showError(state.textError);
          }
        },
        child: MasterPageWithLoading(
          childWidget: MasterPage(
            name: 'Xuất tệp PDF',
            backgroundBarColor: Colors.white,
            barColor: Colors.black,
            floatingBody: Container(),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: 'Tên tệp PDF',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4F5B89),
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 56,
                        width: size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE6E8EE),
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              height: 56,
                              width: (size.width - 42) * 0.44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${widget.convertFilePDFDto.albumDto.metadata!.captureName}',
                                  style: const TextStyle(color: Color(0xFF4F5B89)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (size.width - 42) * 0.56,
                              child: MyTextField(
                                controller: pdfNameController,
                                placeholder: 'Nhập tên',
                                maxLength: 25,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: BlocBuilder<PdfBloc, PdfState>(
                    builder: (context, state) {
                      providerContext = context;
                      return MyButton(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        backgroundColor: state.isDisableConvert
                            ? const Color(0xFFE6E8EE)
                            : const Color(0xFF4A6EF6),
                        text: 'CONVERT',
                        onTap: () {
                          HideKeyBoard.hidKeyBoard();
                          c.startSync();
                          context.read<PdfBloc>().add(ConvertPdfEvent(
                              pdfNameController.text,
                              widget.convertFilePDFDto.albumDto,
                              widget.convertFilePDFDto.selectedImages));
                        },
                        height: 50,
                        isDisable: state.isDisableConvert,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          syncWidget: const MySyncWidget(
            title: 'Đang xuất tệp PDF',
            message: 'Vui lòng chờ trong giây lát',
          ),
        ),
      ),
    );
  }
}
