import 'package:flutter/material.dart';

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
              "คำร้องโพสต์สินค้า",
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
                  Text("ของผิดกฎหมาย")
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
                Text("โฆษณาสินค้าเกินจริง")
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
                Text("ผู้ขายไม่ส่งมอบสินค้า")
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
                Text("อื่นๆ")
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
                  "รายละเอียดคำร้อง",
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
                      hintText: "Enter Description...",
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
                    "Report Sale Post",
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
