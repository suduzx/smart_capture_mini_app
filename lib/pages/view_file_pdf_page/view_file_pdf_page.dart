import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp_syncfunsion_flutter_pdfviewer/pdfviewer.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_confirm_dialog.dart';
import 'package:smart_capture_mobile/base_widgets/my_message_dialog.dart';
import 'package:smart_capture_mobile/base_widgets/my_split_auto_width_button.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_bloc.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_event.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_state.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/view_pdf_page_dto.dart';
import 'package:smart_capture_mobile/enum/confirm_value_enum.dart';
import 'package:smart_capture_mobile/pages/view_file_pdf_page/bloc/view_pdf_page_bloc.dart';
import 'package:smart_capture_mobile/pages/view_file_pdf_page/bloc/view_pdf_page_event.dart';
import 'package:smart_capture_mobile/pages/view_file_pdf_page/bloc/view_pdf_page_state.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';

class ViewPdfFilePage extends StatefulWidget {
  final ViewPdfPageDto viewPdfPageDto;

  const ViewPdfFilePage({
    required this.viewPdfPageDto,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewPdfFilePage();
}

class _ViewPdfFilePage extends State<ViewPdfFilePage>
    with DatetimeUtil, TopSnackBarUtil {
  late BuildContext providerContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewPdfPageBloc>(
          create: (context) => ViewPdfPageBloc(
            ViewPdfPageState(
              rootAlbumPath: '',
              albumDto: widget.viewPdfPageDto.albumDto,
              pdf: widget.viewPdfPageDto.pdf,
              file: null,
            ),
          )..add(
              LoadPdfFileEvent(
                widget.viewPdfPageDto.albumDto,
                widget.viewPdfPageDto.pdf,
              ),
            ),
        ),
        BlocProvider<DeleteFileBloc>(
            create: (context) =>
                DeleteFileBloc(const DeleteFileState(title: ''))),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ViewPdfPageBloc, ViewPdfPageState>(
            listener: (context, state) {
              if (state is LoadPdfFileEventError) {
                MyMessageDialog(
                  title: state.title,
                  message: state.message,
                  titleButton: state.titleButton,
                ).onShowDialog(context).then((value) => Navigator.pop(context));
              }
            },
          ),
          BlocListener<DeleteFileBloc, DeleteFileState>(
            listener: (context, state) {
              if (state is DeleteConfirmEventSuccess) {
                MyConfirmDialog(
                  title: state.title,
                  message: state.message ?? '',
                ).showConfirmDialog(context).then((res) {
                  if (res != null && res == ConfirmValue.confirm) {
                    providerContext.read<DeleteFileBloc>().add(DeleteEvent(
                          false,
                          widget.viewPdfPageDto.albumDto,
                          widget.viewPdfPageDto.pdf.metadata!.status,
                          const [],
                          [widget.viewPdfPageDto.indexPdf],
                        ));
                  }
                });
              }
              if (state is DeleteEventSuccess) {
                showSuccess(state.title);
                Navigator.pop(context, true);
              }
              if (state is DeleteEventError) {
                showError(state.title);
              }
            },
          ),
        ],
        child: BlocBuilder<ViewPdfPageBloc, ViewPdfPageState>(
          builder: (context, state) {
            providerContext = context;
            DateTime modifiedDate =
                string2Datetime(state.pdf.metadata!.modifiedDate);
            String time = dateTime2HhMi(modifiedDate);
            String date = dateTime2DdMmYyyy(modifiedDate);
            return MPScaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                title: Column(
                  children: [
                    Row(
                      children: [
                        if (state.albumDto.metadata!.priorityDisplay == 1)
                          if (state.pdf.metadata!.isSync)
                            Image.asset(
                              'assets/icons/checkcirle_icon.svg',
                              height: 15,
                              fit: BoxFit.fitHeight,
                            )
                          else
                            Image.asset(
                              'assets/icons/sync_icon.svg',
                              height: 15,
                              fit: BoxFit.fitHeight,
                            ),
                        if (state.albumDto.metadata!.priorityDisplay == 1)
                          const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            state.pdf.metadata!.name,
                            style: const TextStyle(
                              color: Color(0xFF041557),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '$date - $time',
                          style: const TextStyle(
                            color: Color(0xFF9AA1BC),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  if (state.file != null)
                    Expanded(
                      child: SfPdfViewer.file(
                        state.file!,
                        canShowScrollHead: false,
                        canShowScrollStatus: false,
                      ),
                    ),
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black12))),
                    child: Row(
                      children: [
                        MySplitAutoWidthButton(
                          icon: 'assets/icons/trash.svg',
                          text: 'Xóa',
                          textColor: const Color(0xFF4F5B89),
                          onTap: () => providerContext
                              .read<DeleteFileBloc>()
                              .add(DeleteConfirmEvent(
                                false,
                                widget.viewPdfPageDto.pdf.metadata!.status,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
