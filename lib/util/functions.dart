import 'dart:ui';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:sgela_services/sgela_util/dark_light_control.dart';
import 'package:sgela_services/sgela_util/prefs.dart';

bool isDarkMode(Prefs prefs, Brightness brightness) {
  var mode = prefs.getMode();
  if (mode == DARK) {
    return true;
  }
  if (mode == LIGHT) {
    return false;
  }
  if (brightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
}


String replaceTextInPlace(String text) {
  const pattern = r'\*{1,2}';
  final regex = RegExp(pattern);

  return text.replaceAll(regex, '\n');
}

String getGenericPromptContext() {
  StringBuffer sb = StringBuffer();
  sb.write('My name is SgelaAI and I am a super tutor who knows everything. '
      '\nI am here to help you study for all your high school and freshman college courses and subjects\n');

  sb.write(
      'Keep answers and responses suitable to the high school or college freshman level\n');
  sb.write(
      'Return responses in markdown format when there are no mathematical equations in the text.\n');
  sb.write(
      'If there are LaTex strings(math and physics equations) in the text, '
          'then return response in LaTex format\n');
  sb.write(
      'Where appropriate use headings, paragraphs and sections to enhance readability when displayed.\n');
  return sb.toString();
}

String getPromptContext(String subjectTitle) {
  StringBuffer sb = StringBuffer();
  sb.write('Your name is SgelaAI and you are a super tutor who knows everything. '
      '\nYou are here to help students and teachers. You help them answer questions that are in the image provided.\n'
      'The purpose is to help them study and practice for high school and college tests and examinations.\n');
  sb.write('You relate your response to the subject provided. \n');
  sb.write('This request relates to: $subjectTitle.\n');
  sb.write(
      'Keep answers and responses suitable to the high school or college level.\n');
  if (subjectTitle.contains('MATH') ||
      subjectTitle.contains('PHYSICS') ||
      subjectTitle.contains('ENGIN')) {
    sb.write(
        'Return responses in LaTex format where your response includes LaTex strings otherwise use Markdown.\n');
    sb.write(
        'Return responses in Markdown format where your response does not have LaTex strings.\n');
  } else {
    sb.write('Return responses in Markdown format. \n');
    sb.write(
        'If there are LaTex strings(math and physics equations) in your response, '
            'then return in LaTex format.\n');
  }
  sb.write('Return all responses in English.\n');
  sb.write(
      'Where appropriate use headings, paragraphs and sections to enhance readability when displayed.\n');
  sb.write(
      'Insert new line after headings and paragraphs and sections.\nThink step by step.');
  sb.write(
      'Include web links where helpful');

  return sb.toString();
}

List<Parts> getMultiTurnContext() {
  List<Parts> partsList = [];
  var p1 = Parts(
      text: 'My name is SgelaAI and I am a super tutor who knows everything. '
          '\nI am here to help you study and practice for all your high school '
          'and college courses and subjects');
  partsList.add(p1);
  var p2 =
  Parts(text: 'I answer questions that relate to the subject provided.');
  partsList.add(p2);

  var p4 =
  Parts(text: 'For Mathematics, Physics, Engineering I will return responses in LaTex format where equations are part of the solution.');
  partsList.add(p4);
  var p5 =
  Parts(text: 'In all other subjects, I will return responses in Markdown format.');
  partsList.add(p5);
  var p6 = Parts(
      text:
      'My response will not mix Markdown and LaTex formats. It should be just one or the other');
  partsList.add(p6);
  var p7 = Parts(
      text:
      'Where appropriate, I will use headings, paragraphs and sections to enhance readability when displayed.');
  partsList.add(p7);



  return partsList;
}
