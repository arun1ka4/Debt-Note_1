import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../models/debt_model.dart';

class FormPage extends StatefulWidget {
  final Debt? debt;
  final Function(Debt) onSave;

  const FormPage({super.key, this.debt, required this.onSave});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController jumlahController;
  late TextEditingController tanggalHutangController;
  late TextEditingController tanggalJatuhTempoController;

  DateTime? selectedTanggalHutang;
  DateTime? selectedTanggalJatuhTempo;

  @override
  void initState() {
    super.initState();
    namaController =
        TextEditingController(text: widget.debt?.nama ?? "");
    jumlahController =
        TextEditingController(text: widget.debt?.jumlah.toString() ?? "");
    tanggalHutangController =
        TextEditingController(
            text: widget.debt?.tanggalHutang != null
                ? "${widget.debt!.tanggalHutang.day}/${widget.debt!.tanggalHutang.month}/${widget.debt!.tanggalHutang.year}"
                : "");
    tanggalJatuhTempoController =
        TextEditingController(
            text: widget.debt?.tanggalHutang != null
                ? "${widget.debt!.tanggalHutang.day}/${widget.debt!.tanggalHutang.month}/${widget.debt!.tanggalHutang.year}"
                : "");
  }

  @override
  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
    tanggalHutangController.dispose();
    tanggalJatuhTempoController.dispose();
    super.dispose();
  }

  void simpanData() {
    if (_formKey.currentState!.validate()) {
      final data = Debt(
        nama: namaController.text,
        jumlah: int.parse(jumlahController.text),
        tanggalHutang: selectedTanggalHutang!,
        tanggalJatuhTempo: selectedTanggalHutang!,
      );

      widget.onSave(data);
      Navigator.pop(context);
    }
  }

  Future<void> pilihTanggal(
      TextEditingController controller,
      bool isTanggalHutang,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.day}/${picked.month}/${picked.year}";

        if (isTanggalHutang) {
          selectedTanggalHutang = picked;
        } else {
          selectedTanggalJatuhTempo = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.debt != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Hutang" : "Tambah Hutang"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                maxLength: 20,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "Nama Penghutang",
                  border: const OutlineInputBorder(),
                  suffixIcon: namaController.text.isNotEmpty
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: jumlahController,
                onChanged: (value) {
                  setState(() {});
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: "Jumlah Hutang",
                  border: OutlineInputBorder(),
                  suffixIcon: jumlahController.text.isNotEmpty
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  prefixText: "Rp ",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Jumlah tidak boleh kosong" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: tanggalHutangController,
                readOnly: true,
                onTap: () => pilihTanggal(tanggalHutangController, true),
                decoration: const InputDecoration(
                  labelText: "Tanggal Hutang",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: tanggalJatuhTempoController,
                readOnly: true,
                onTap: () => pilihTanggal(tanggalJatuhTempoController, false),
                decoration: const InputDecoration(
                  labelText: "Tanggal Jatuh Tempo",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpanData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(isEdit ? "Update" : "Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}