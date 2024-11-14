import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubits/change%20font%20size%20cubit/change_font_size_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeFontSizeCubit extends Cubit<ChangeFontSizeState> {
  ChangeFontSizeCubit() : super(ChangeFontSizeInitial()) {
    defaultFont();
  }

  double titleFontSize = 10;
  double contentFontSize = 10;
  Future<void> defaultFont() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFont = prefs.getInt('fontIndex') ?? 2;
    await changeFontSize(savedFont, save: false);
  }

  Future<void> changeFontSize(int fontNo, {bool save = true}) async {
    switch (fontNo) {
      case 1:
        titleFontSize = 15;
        contentFontSize = 10;
        break;
      case 2:
        titleFontSize = 25;
        contentFontSize = 20;
        break;
      case 3:
        titleFontSize = 35;
        contentFontSize = 30;
        break;
      case 4:
        titleFontSize = 45;
        contentFontSize = 40;
        break;
    }
    if (save) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('fontIndex', fontNo);
    }
    emit(ChangeFontSizeSuccess());
  }
}
