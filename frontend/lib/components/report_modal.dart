import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportModal extends StatefulWidget {
  const ReportModal({super.key});

  @override
  State<ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      padding: EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.report_product,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Checkbox(
                      value: isChecked1,
                      onChanged: (value) {
                        setState(() {
                          isChecked1 = value!;
                        });
                      }),
                  Text(AppLocalizations.of(context)!.report_illegal_product)
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                    value: isChecked2,
                    onChanged: (value) {
                      setState(() {
                        isChecked2 = value!;
                      });
                    }),
                Text(AppLocalizations.of(context)!
                    .report_item_does_not_match_the_description)
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: isChecked3,
                    onChanged: (value) {
                      setState(() {
                        isChecked3 = value!;
                      });
                    }),
                Text(AppLocalizations.of(context)!
                    .report_seller_did_not_deliver_the_item)
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: isChecked4,
                    onChanged: (value) {
                      setState(() {
                        isChecked4 = value!;
                      });
                    }),
                Text(AppLocalizations.of(context)!.report_Other_please_specify)
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Text(
                  AppLocalizations.of(context)!.report_description,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: TextField(
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!
                          .report_description_placeholder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.report_submit,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
