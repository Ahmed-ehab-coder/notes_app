import 'package:Notes/constants.dart';
import 'package:Notes/cubits/add%20note%20cubit/add_note_cubit.dart';
import 'package:Notes/cubits/notes%20cubit/notes_cubit.dart';
import 'package:Notes/helper/validation.dart';
import 'package:Notes/models/note_model.dart';
import 'package:Notes/views/widgets/add_note_body.dart';
import 'package:Notes/views/widgets/colors_list_view.dart';
import 'package:Notes/views/widgets/custom_app_bar.dart';
import 'package:Notes/views/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? title;
  String? content;
  Color tfColor = kColors[0];
  void addNoteData({String? title, String? content}) {
    setState(() {
      this.title = title;
      this.content = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: addNoteAppBar(context),
      body: AddNoteBody(
        formKey: formKey,
        textFieldColor: tfColor,
        onSave: addNoteData,
      ),
    );
  }

  CustomAppBar addNoteAppBar(BuildContext context) {
    return CustomAppBar(
      colorIcon: CustomIcon(
        icon: HugeIcons.strokeRoundedColors,
        // iconColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            barrierColor: Colors.transparent,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ColorsListView(
                  onChangeColor: (color) {
                    setState(() {
                      tfColor = color;
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      checkIcon: CustomIcon(
        icon: HugeIcons.strokeRoundedCheckmarkSquare04,
        onPressed: () {
          Validation.formValidation(context, formKey,
              title: title, tfColor: tfColor, content: content);
        },
      ),
    );
  }

  void validation(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var currnetDate = DateTime.now();
      var formattedCurrntDate =
          DateFormat('MMM dd hh:mm a').format(currnetDate);
      var noteModel = NoteModel(
        title: title == null || title!.isEmpty ? 'Untitled' : title!,
        subtitle: content!,
        date: formattedCurrntDate,
        color: tfColor?.value ?? kColors[0].value,
        pin: false,
      );
      BlocProvider.of<AddNoteCubit>(context).addNote(noteModel);
      BlocProvider.of<NotesCubit>(context).fetchAllNotes();
    } else {
      // عرض SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter some data!'),
          duration: const Duration(seconds: 2),
        ),
      );
      // autovalidateMode = AutovalidateMode.always;
      setState(() {});
    }
  }
}
