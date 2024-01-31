import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:petugas_perpustakaan_kelas_c/app/data/provider/api_provider.dart';
import 'package:petugas_perpustakaan_kelas_c/app/data/provider/storage_provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:petugas_perpustakaan_kelas_c/app/modules/book/controllers/book_controller.dart';

import '../../../data/constant/endpoint.dart';
import '../../../routes/app_pages.dart';

class AddBookController extends GetxController {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController penulisController = TextEditingController();
  final TextEditingController penerbitController = TextEditingController();
  final TextEditingController tahunterbitController = TextEditingController();

  final loading = false.obs;
  final count = 0.obs;
  final BookController _bookController = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    String status = StorageProvider.read(StorageKey);
    log("status : $status");
    if (status == 'logged') {
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  addbook() async {
    loading(true);
    try {
      FocusScope.of(Get.context!).unfocus();
      formkey.currentState?.save();
      if (formkey.currentState!.validate()) {
        final response = await ApiProvider.instance().post(Endpoint.book,
            data: dio.FormData.fromMap({
              "judul": judulController.text.toString(),
              "penulis": penerbitController.text.toString(),
              "penerbit": penerbitController.text.toString(),
              "tahun_terbit": tahunterbitController.text.toString(),

            }));
        if (response.statusCode == 201) {
          _bookController.getData();
          Get.snackbar("Berhasil", "Input berhasil", backgroundColor: Colors.green);
          Get.back();
        } else {
          Get.snackbar("Sorry", "Login gagal", backgroundColor: Colors.orange);
        }
      }
      loading(false);
    } on dio.DioException catch (e) {
      loading(false);
      if (e.response != null) {
        if (e.response != null) {
          Get.snackbar("Sorry", "${e.response?.data['message']}",
              backgroundColor: Colors.orange);
        }
      } else {
        Get.snackbar("Sorry", e.message ?? "", backgroundColor: Colors.orange);
      }
    } catch (e) {
      loading(false);
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }

}
