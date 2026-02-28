import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../models/debt_model.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedIndex;
  final List<Debt> debtList = [];
  final DateFormat formatter = DateFormat('dd MMM yyyy');

  void tambahData(Debt debt) {
    setState(() {
      debtList.add(debt);
    });
  }

  void updateData(int index, Debt debtBaru) {
    setState(() {
      debtList[index] = debtBaru;
    });
  }

  void hapusData(int index) {
    setState(() {
      debtList.removeAt(index);
    });
  }

  void bukaForm({Debt? debt, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(
          debt: debt,
          onSave: (Debt dataBaru) {
            if (debt == null) {
              tambahData(dataBaru);
            } else {
              updateData(index!, dataBaru);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DebtNote - Pencatat Hutang"),
        backgroundColor: Color(0xFF84994F),
        centerTitle: true,
      ),
      body: debtList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wallet_sharp,
                  size: 70,
                  color: Color(0xFF2F5249)
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Tidak ada hutang yang ditagih",
                    style: TextStyle(fontSize: 18 ),
                ),
                ]
              )
            )
          : ListView.builder(
          itemCount: debtList.length,
          itemBuilder: (context, index) {
            final debt = debtList[index];
            final isSelected = selectedIndex == index;

            return Card(
              margin: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedIndex = null;
                    } else {
                      selectedIndex = index;
                    }
                  });
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        debt.nama,
                        style: const TextStyle(fontSize: 25),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rp ${debt.jumlah}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14,
                                  color: Color.fromARGB(255, 148, 201, 113)),
                              const SizedBox(width: 5),
                              Text(
                                "Hutang: ${formatter.format(debt.tanggalHutang)}",
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.event,
                                  size: 14, color: Colors.redAccent),
                              const SizedBox(width: 5),
                              Text(
                                "Tenggat: ${formatter.format(debt.tanggalJatuhTempo)}",
                              ),
                            ],
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),

                    // 👇 ICON HANYA MUNCUL JIKA TERPILIH
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.orange),
                              onPressed: () =>
                                  bukaForm(debt: debt, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () {
                                hapusData(index);
                                setState(() {
                                  selectedIndex = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bukaForm(),
        backgroundColor:Color.fromARGB(255, 225, 167, 41),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      )
    );
  }
}