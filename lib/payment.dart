import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String lectureName = "default";
  String amount = "default";
  String buyLectureName = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(40),
        child: Align(
          alignment: Alignment.center,
          child: Column(children: [
            Row(
              children: [
                Text(
                  "$lectureName 강의 등록",
                  style: const TextStyle(fontSize: 25),
                ),
                const Spacer()
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: DataTable(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  columns: const [
                    // Color.fromARGB(255, 196, 196, 196),
                    DataColumn(label: Text("상품명")),
                    DataColumn(label: Text("가격")),
                    DataColumn(label: Text("보유 기간")),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text(lectureName)),
                      DataCell(Text(amount)),
                      DataCell(Text(buyLectureName)),
                    ]),
                  ]),
            ),
            Row(
              children: [const Spacer(), Text("구매자: $buyLectureName")],
            ),
            const SizedBox(
              height: 100,
            ),
            const Row(
              children: [
                Text(
                  "결제 수단",
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 70)),
                      child: const Text("신용카드"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 70)),
                      child: const Text("무통장입금"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 70)),
                      child: const Text("카카오페이"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 70)),
                      child: const Text("etc"),
                    ),
                  ],
                )
              ],
            )
          ]),
        ),
      ),
      bottomNavigationBar: const SizedBox(
        height: 65,
        child: InkWell(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Divider(),
            Text(
              "결제 진행하기",
              style: TextStyle(fontSize: 30),
            )
          ]),
        ),
      ),
    );
  }
}
