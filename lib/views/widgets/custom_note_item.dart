import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/constants.dart';
import 'package:notes_app/cubits/notes%20cubit/notes_cubit.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/views/edit_note_view.dart';
import 'package:notes_app/views/widgets/custom_snack_bar.dart';
import 'package:notes_app/views/widgets/pin_icon.dart';
import 'package:pie_menu/pie_menu.dart';

class NoteItem extends StatefulWidget {
  const NoteItem({
    super.key,
    required this.noteModel,
    required this.onPressed,
    required this.icon,
    required this.color,
    required this.onSelectPin,
    required this.status,
    required this.showPin,
    this.pattern,
    required this.textTitle,
    required this.textSubTitle,
  });
  final NoteModel noteModel;
  final void Function()? onPressed;
  final dynamic Function() onSelectPin;
  final IconData icon;
  final Color color;
  final String status;
  final bool showPin;
  final String? pattern;
  final Widget textTitle;
  final Widget textSubTitle;

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  @override
  Widget build(BuildContext context) {
    return PieMenu(
      theme: pieTheme(),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditNoteView(
                noteModel: widget.noteModel,
              );
            },
          ),
        );
      },
      actions: [
        PieAction(
          tooltip: Text(widget.status),
          onSelect: widget.onSelectPin,
          child: Icon(
            widget.icon,
          ), // Can be any widget
        ),
        PieAction(
          tooltip: const Text(
            'Delete',
          ),
          onSelect: () {
            widget.noteModel.delete();
            BlocProvider.of<NotesCubit>(context).fetchAllNotes();

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  CustomSnackBar().buildSnackBar(message: 'note deleted'));
          },
          child: const Icon(FontAwesomeIcons.trashCan), // Can be any widget
        ),
      ],
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
                color: Color(widget.noteModel.color),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.textTitle,
                Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: widget.textSubTitle),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.noteModel.date,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.showPin) pinIcon(widget: widget),
        ],
      ),
    );
  }

  PieTheme pieTheme() {
    return PieTheme(
        tooltipTextStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
        pointerColor: Color(widget.noteModel.color),
        overlayColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withAlpha(200)
            : Colors.white.withAlpha(200),
        buttonThemeHovered: const PieButtonTheme(
            backgroundColor: kPrimaryColor, iconColor: Colors.white),
        buttonTheme: const PieButtonTheme(
            backgroundColor: Colors.white, iconColor: kPrimaryColor));
  }
}
