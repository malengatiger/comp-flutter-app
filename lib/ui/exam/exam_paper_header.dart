import 'package:flutter/material.dart';
import 'package:sgela_services/data/exam_link.dart';
import 'package:sgela_shared_widgets/util/gaps.dart';
import 'package:sgela_shared_widgets/util/styles.dart';


class ExamPaperHeader extends StatelessWidget {
  const ExamPaperHeader({super.key, required this.examLink, required this.onClose});

  final ExamLink examLink;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
    Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w900,
    );
    return SizedBox(
      height: 240,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          child: SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            examLink.subject!,
                            style: titleStyle,
                          ),
                        ),
                        IconButton(onPressed:(){
                          onClose();
                        }, icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Text('Title'),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            '${examLink.title}',
                            style: titleStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Text('Paper ID'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${examLink.id}',
                          style: titleStyle,
                        )
                      ],
                    ),
                  ),
                  gapH8,
                  Text(
                    '${examLink.documentTitle}',
                    style: myTextStyle(context, Theme.of(context).primaryColor,
                    14, FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}