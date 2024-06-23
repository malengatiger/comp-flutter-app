import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sgela_services/data/exam_link.dart';
import 'package:sgela_services/data/exam_page_content.dart';
import 'package:sgela_services/data/summarized_exam.dart';
import 'package:sgela_services/services/exam_extractor_service.dart';
import 'package:sgela_services/services/firestore_service.dart';
import 'package:sgela_services/services/summarizer_service.dart';
import 'package:sgela_services/sgela_util/functions.dart';
import 'package:sgela_shared_widgets/util/dialogs.dart';
import 'package:sgela_shared_widgets/util/gaps.dart';
import 'package:sgela_shared_widgets/util/styles.dart';
import 'package:sgela_shared_widgets/widgets/busy_indicator.dart';

class ExamPageContentSelector extends StatefulWidget {
  const ExamPageContentSelector({super.key, required this.examLink});

  final ExamLink examLink;

  @override
  State<ExamPageContentSelector> createState() =>
      _ExamPageContentSelectorState();
}

class _ExamPageContentSelectorState extends State<ExamPageContentSelector> {
  List<ExamPageContent> contents = [];
  List<MyContentBag> myBags = [];

  FirestoreService firestoreService = GetIt.instance<FirestoreService>();
  ExamExtractorService examExtractorService =
      GetIt.instance<ExamExtractorService>();

  bool _busy = false;
  static const mm = '🔵🔵🔵 ExamPageContentSelector 🔵';

  @override
  void initState() {
    super.initState();
    _getContents();
  }

  late String msg1;
  late String msg2;
  int _whichMsg = 0;

  _getContents() async {
    setState(() {
      _busy = true;
    });
    pp('$mm ... get contents of exam paper ...');
    try {
      _whichMsg = 1;
      msg1 = 'Loading  ${widget.examLink.subject} exam paper and digitizing it. This may take a minute!';
      contents =
          await firestoreService.getExamPageContents(widget.examLink.id!);
      pp('$mm Found ${contents.length} pageContents');
      if (contents.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 200));
        _popDialog();
        return;
      }

      for (var value in contents) {
        myBags.add(MyContentBag(false, value));
      }
      pp('$mm exam pages: ${myBags.length}');
    } catch (e) {
      pp(e);

      if (mounted) {
        showErrorDialog(context, '$e');
      }
    }
    setState(() {
      _busy = false;
    });
  }

  _popDialog() async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content:  Text(
                'Do you want to download and digitize the ${widget.examLink.subject} - ${widget.examLink.documentTitle} Exam paper?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _getWorkbook();
                    _getContents();
                  },
                  child: const Text('Download')),
            ],
          );
        });
  }

  int selected = 0;
  int weeks = 4;

  void _countSelected() {
    selected = 0;
    for (var value in myBags) {
      if (value.selected!) {
        selected++;
      }
    }
    pp('$mm selected pages: $selected');
    setState(() {});
  }

  void _navigateToChat() async {
    pp('$mm ... _navigateToChat with $selected pages');
    List<ExamPageContent> chosen = [];
    for (var value in myBags) {
      if (value.selected!) {
        chosen.add(value.examPageContent!);
      }
    }
    pp('$mm ... selected pages: ${chosen.length} pages');
    for (var value1 in chosen) {
      pp('$mm chosen page: 🍎${value1.pageIndex! + 1}');
    }
  }

  final SummarizerService summarizerService =
      GetIt.instance<SummarizerService>();
  SummarizedExam? summarizedExam;

  Future _getWorkbook() async {
    setState(() {
      _busy = true;
    });
    pp('$mm _getting summarized Workbook for exam: ${widget.examLink.subject}  ${widget.examLink.documentTitle}');
    _whichMsg = 2;
    msg2 =
    'A Gemini AI Agent is preparing an Exam Workbook for you. Subject: ( ${widget.examLink.subject} -  ${widget.examLink.documentTitle}). '
        '\nThis may take a couple of minutes!';
    summarizedExam =
        await summarizerService.summarizePdf(widget.examLink.id!, weeks);
    pp('$mm summarizedExam created: tokens: ${summarizedExam?.totalTokens}');

    setState(() {
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.examLink.subject}',
              style: myTextStyleMediumBoldPrimaryColor(context)),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Tap to select multiple pages',
                      style: myTextStyleSmall(context)),
                  gapH16,
                  _busy
                      ? gapW32
                      : ElevatedButton(
                          style: ButtonStyle(
                              elevation: const WidgetStatePropertyAll(8.0),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue[800]!),
                              foregroundColor:
                                  const WidgetStatePropertyAll(Colors.white)),
                          onPressed: () {
                            _getWorkbook();
                          },
                          child: const Text('Create Exam Workbook')),
                  gapH16,
                  Expanded(
                    child: ListView.builder(
                        itemCount: myBags.length,
                        itemBuilder: (_, index) {
                          var c = myBags[index];
                          return Card(
                            elevation: 8,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    pp('$mm page tapped: ${index + 1}, current selected? ${c.selected}');
                                    c.selected = !c.selected!;
                                    _countSelected();
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: c.examPageContent!.pageImageUrl!,
                                  ),
                                ),
                                Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Text(
                                      '${index + 1}',
                                      style: myTextStyleMediumBoldPrimaryColor(
                                          context),
                                    )),
                                c.selected!
                                    ? Positioned(
                                        child: Center(
                                        child: IconButton(
                                            onPressed: () {
                                              c.selected = !c.selected!;
                                              _countSelected();
                                            },
                                            icon: Icon(Icons.check_circle,
                                                size: 48,
                                                color: Colors.green[800]!)),
                                      ))
                                    : gapW32,
                              ],
                            ),
                          );
                        }),
                  ),
                  gapH16,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Pages: '),
                        // gapW8,
                        Text(
                          '$selected',
                          style: myTextStyleMediumBoldPrimaryColor(context),
                        ),
                        gapW8,
                        selected > 0
                            ? ElevatedButton(
                                style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.all(8.0)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Colors.green[800]!),
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    elevation:
                                        const WidgetStatePropertyAll(8.0)),
                                onPressed: () {
                                  _navigateToChat();
                                },
                                child: const Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Text('Send to AI'),
                                ))
                            : gapW8,
                        gapW8,
                        selected > 0
                            ? IconButton(
                                onPressed: () {
                                  for (var value in myBags) {
                                    value.selected = false;
                                  }
                                  setState(() {
                                    selected = 0;
                                  });
                                },
                                icon: const Icon(Icons.clear))
                            : gapW32,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _busy
                ? Positioned(
                    child: Center(
                    child: BusyIndicator(
                      caption: _whichMsg == 1 ? msg1 : msg2,
                    ),
                  ))
                : gapH32,
          ],
        )));
  }
}

class MyContentBag {
  bool? selected;
  ExamPageContent? examPageContent;

  MyContentBag(this.selected, this.examPageContent);
}
