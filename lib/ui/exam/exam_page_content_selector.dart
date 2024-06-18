import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sgela_services/data/exam_link.dart';
import 'package:sgela_services/data/exam_page_content.dart';
import 'package:sgela_services/services/exam_extractor_service.dart';
import 'package:sgela_services/services/firestore_service.dart';
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

  _getContents() async {
    setState(() {
      _busy = true;
    });
    pp('$mm ... get contents of exam paper ...');
    try {
      contents =
          await firestoreService.getExamPageContents(widget.examLink.id!);
      pp('$mm Found ${contents.length} pageContents');
      if (contents.isNotEmpty) {
        if (contents[0].pageImageUrl == null) {
          contents = await examExtractorService
              .extractPageContentForExam(widget.examLink.id!);
        }
      } else {
        contents = await examExtractorService
            .extractPageContentForExam(widget.examLink.id!);
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

  int selected = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.examLink.subject}',
              style: myNumberStyleLargerPrimaryColor(context)),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Tap to select multiple pages', style: myTextStyleSmall(context)),
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
                                    top: 8, right: 8,
                                    child: Text('${index + 1}', style: myTextStyleMediumBoldPrimaryColor(context),)),
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
                        selected > 0? IconButton(onPressed: (){
                          for (var value in myBags) {
                            value.selected = false;
                          }
                          setState(() {
                            selected = 0;
                          });
                        }, icon: const Icon(Icons.clear)): gapW32,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _busy
                ? const Positioned(
                    child: Center(
                    child: BusyIndicator(
                      caption: 'Loading exam paper content ...',
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
