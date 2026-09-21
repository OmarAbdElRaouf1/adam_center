import 'package:easy_localization/easy_localization.dart';
import 'package:the_one_test/core/helper/helper.dart';

class ImagePickerHelper {
  static Future<void> pickImage(
    BuildContext context,
    Function(File?) onImagePicked, {
    required ImageSource source,
  }) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  static void showImagePicker(
    BuildContext context,
    Function(File?) onImagePicked,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "choose_image".tr(),
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: Text("take_from_camera".tr()),
                onTap: () => pickImage(
                  context,
                  onImagePicked,
                  source: ImageSource.camera,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: Text("choose_from_gallery".tr()),
                onTap: () => pickImage(
                  context,
                  onImagePicked,
                  source: ImageSource.gallery,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
