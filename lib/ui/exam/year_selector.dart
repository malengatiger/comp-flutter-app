import 'package:comp_flutter/ui/exam/exam_link_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sgela_services/data/exam_document.dart';
import 'package:sgela_services/data/subject.dart';
import 'package:sgela_services/services/firestore_service.dart';
import 'package:sgela_services/sgela_util/functions.dart';
import 'package:sgela_services/sgela_util/navigation_util.dart';
import 'package:sgela_shared_widgets/util/dialogs.dart';
import 'package:sgela_shared_widgets/util/gaps.dart';
import 'package:sgela_shared_widgets/util/styles.dart';

class YearSelector extends StatefulWidget {
  const YearSelector(
      {super.key,
      required this.subject});

  final Subject subject;

  @override
  State<YearSelector> createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  static const mm = '🔵🔵🔵🔵YearSelector';

  @override
  void initState() {
    super.initState();
    _fetchExamDocuments();
  }

  bool busy = false;
  List<ExamDocument> examDocs = [];
  List<MyBag> myBags = [];
  FirestoreService firestoreService = GetIt.instance<FirestoreService>();

  _fetchExamDocuments() async {
    try {
      setState(() {
        busy = true;
      });
      examDocs = await firestoreService.getExamDocuments();
      // examDocs.sort((b, a) => b.year!.compareTo(a.year!));
      for (var value in examDocs) {
        myBags.add(MyBag(false, value));
      }
      // myBags.sort((b, a) => b.examDocument!.year!.compareTo(a.examDocument!.year!));

    } catch (e) {
      pp(e);
      if (mounted) {
        showErrorDialog(context, '$e');
      }
    }
    setState(() {
      busy = false;
    });
  }

  void _countSelected() {
    selected = 0;
    for (var value in myBags) {
      if (value.selected!) {
        selected++;
      }
    }
  }

  int selected = 0;

  void _navigateToExamLinks() {
    pp('_navigateToExamLinks ...');
    List<ExamDocument> list = [];
    for (var bag in myBags) {
      if (bag.selected!) {
        list.add(bag.examDocument!);
      }
    }
    list.sort((a, b) => b.year!.compareTo(a.year!));
    NavigationUtils.navigateToPage(context: context, widget: ExamLinkListWidget(
        subject: widget.subject, examDocuments: list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Year Selection')),
        body: SafeArea(
            child: Stack(
          children: [
            Column(
              children: [
                Text(
                  '${widget.subject.title}',
                  style: myTextStyleLargePrimaryColor(context),
                ),
                Text('Select multiple Exam years',
                    style: myTextStyleSmall(context)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                        itemCount: myBags.length,
                        itemBuilder: (_, index) {
                          var doc = myBags[index];
                          return GestureDetector(
                            onTap: () {
                              pp('$mm selected: ${doc.selected} : ${doc.examDocument?.title}');
                              doc.selected = !doc.selected!;
                              setState(() {});
                              _countSelected();
                            },
                            child: Check(myBag: doc),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Card(
                    elevation: 16,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          gapW32,
                          const Text('Selected: '),
                          gapW12,
                          Text(
                            '$selected',
                            style: myTextStyleMediumBoldPrimaryColor(context),
                          ),
                          gapW32,
                          ElevatedButton(
                              onPressed: () {

                                _navigateToExamLinks();
                              },
                              child: Text(
                                'Done',
                                style: myTextStyleLarge(context),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}

class Check extends StatelessWidget {
  const Check({super.key, required this.myBag});

  final MyBag myBag;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(
                value: myBag.selected!,
                onChanged: (c) {
                  pp(' .. checkBox tapped');
                }),
            gapW12,
            Flexible(
                child: Text(
              myBag.examDocument!.title!,
              style: myTextStyleSmall(context),
            )),
          ],
        ),
      ),
    );
  }
}

class MyBag {
  bool? selected;
  ExamDocument? examDocument;

  MyBag(this.selected, this.examDocument);
}
