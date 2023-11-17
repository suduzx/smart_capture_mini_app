import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_message_dialog.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_bloc.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_event.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_state.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/tree_value_sync_bpm_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/convert_file_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/detail_album_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/detail_image_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/view_pdf_page_dto.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/pages/convert_file_pdf_page/convert_file_pdf.dart';
import 'package:smart_capture_mobile/pages/create_album_page/create_new_album_page.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/detail_album_page.dart';
import 'package:smart_capture_mobile/pages/detail_image_page/detail_image_page.dart';
import 'package:smart_capture_mobile/pages/home_page/home_page.dart';
import 'package:smart_capture_mobile/pages/login_page/login_page.dart';
import 'package:smart_capture_mobile/pages/login_page/login_via_super_app.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/upload_bpm_page.dart';
import 'package:smart_capture_mobile/pages/view_file_pdf_page/view_file_pdf_page.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';

void main() {
  runApp(const MyApp());
  MPCore().connectToHostChannel();
}

class MyApp extends StatelessWidget with TopSnackBarUtil {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    F.appFlavor = Flavor.dev;
    LoadStatusController c = Get.put(LoadStatusController());
    return BlocProvider<SyncBloc>(
      create: (context) => SyncBloc(const SyncState()),
      child: BlocListener<SyncBloc, SyncState>(
        listener: (context, state) {
          if (state is AddSyncDataEventSuccess) {
            context.read<SyncBloc>().add(SyncAlbumEvent(
                  imagePath: state.imagePath,
                  albumPath: state.albumPath,
                  context: context,
                  isSyncCompleted: c.syncCompleted.value,
                  showAlert: state.showAlert,
                ));
            c.updateSyncCompleted(false);
          }
          if (state is AddSyncDataEventError) {
            if (state.showAlert) {
              showError('Có lỗi xảy ra.\nĐồng bộ không thành công!');
            }
          }
          if (state is SyncAlbumEventError) {
            if (state.showAlert) {
              MyMessageDialog(
                isCenter: true,
                title: state.title,
                message: state.message,
                titleButton: state.titleButton,
              ).onShowDialog(context);
            }
          }
        },
        child: MPApp(
          title: 'MPFlutter Demo',
          color: Colors.blue,
          routes: {
            '/': (context) =>
                (F.appFlavor == Flavor.dev || F.appFlavor == Flavor.devMB)
                    ? const LoginPage()
                    : const LoginViaSuperApp(),
            '/my-home': (context) => const MyHomePage(),
            '/create-new-album': (context) => CreateNewAlbumPage(
                limitAlbumParam:
                    ModalRoute.of(context)!.settings.arguments as int),
            '/detail-album': (context) => DetailAlbumPage(
                detailAlbumDto: ModalRoute.of(context)!.settings.arguments
                    as DetailAlbumDto),
            '/detail-image': (context) => DetailImagePage(
                detailImageDto: ModalRoute.of(context)!.settings.arguments
                    as DetailImageDto),
            '/convert-file-pdf': (context) => ConvertFilePDFPage(
                convertFilePDFDto: ModalRoute.of(context)!.settings.arguments
                    as ConvertFilePDFDto),
            '/view-file-pdf': (context) => ViewPdfFilePage(
                viewPdfPageDto: ModalRoute.of(context)!.settings.arguments
                    as ViewPdfPageDto),
            '/upload-bpm': (context) => UploadBPMPage(
                treeValueSyncBPMDto: ModalRoute.of(context)!.settings.arguments
                    as TreeValueSyncBPMDto),
          },
          navigatorObservers: [MPCore.getNavigationObserver()],
        ),
      ),
    );
  }
}
