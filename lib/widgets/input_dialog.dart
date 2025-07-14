import 'package:bloomy/configs/colors.dart';
import 'package:bloomy/widgets/custom_textfield.dart';
import 'package:bloomy/widgets/primary_text.dart';
import 'package:flutter/material.dart';

Future<Map<String, String>?> showSongInputDialog(BuildContext context) async {
  final titleController = TextEditingController();
  final artistController = TextEditingController();

  return showDialog<Map<String, String>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.tealGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add new song",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              CustomUnderlineTextField(controller: titleController, hintText: "Song name"),

              const SizedBox(height: 12),
              CustomUnderlineTextField(controller: artistController, hintText: "Artist name"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: PrimaryText(text:"Huỷ"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final title = titleController.text.trim();
                      final artist = artistController.text.trim();
                      if (title.isNotEmpty && artist.isNotEmpty) {
                        Navigator.of(context).pop({
                          'title': title,
                          'artist': artist,
                        });
                      }
                    },
                    child: PrimaryText(
                      text: "Add",
                     color: AppColors.textBlue),
                    ),

                ],
              ),
            ],
          ),
        ),
      );


    },
  );
}

