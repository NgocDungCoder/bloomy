import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class MusicModel {
  Future<List<File>> getMp3Files() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String musicDirPath = '${appDocDir.path}/music';

    Directory musicDir = Directory(musicDirPath);
    if (!await musicDir.exists()) {
      return [];
    }

    List<FileSystemEntity> files = musicDir.listSync();
    List<File> mp3Files = files
        .where((file) => file.path.endsWith('.mp3'))
        .map((file) => File(file.path))
        .toList();

    return mp3Files;
  }

  Future<String> saveMp3File() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null && result.files.single.path != null) {
      File mp3File = File(result.files.single.path!);
      String fileName = result.files.single.name;

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      Directory musicDir = Directory('$appDocPath/music');
      if (!await musicDir.exists()) {
        await musicDir.create(recursive: true);
      }

      String newPath = '${musicDir.path}/$fileName';
      await mp3File.copy(newPath);
      return newPath;
    }
    return '';
  }
}