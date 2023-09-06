import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
class uploadVideo extends StatefulWidget {
  const uploadVideo({super.key});

  @override
  State<uploadVideo> createState() => _uploadVideoState();
}

class _uploadVideoState extends State<uploadVideo> {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<Map<String,dynamic>> pdfData = []; //is list me sari pdf store hogi

  Future<String>uploadpdf(String fileName, File file) async {
    final reference=  FirebaseStorage.instance.ref().child("video/$fileName.mp4");
    final uploadTask =reference.putFile(file);
    await uploadTask.whenComplete(() => {});

    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {

    final pickedFile = await  FilePicker.platform.pickFiles(
      type:FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if(pickedFile !=null)
    {
      String fileName= pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadpdf(fileName, file);

      await  _firebaseFirestore.collection("video").add({
        "name": fileName,
        "url": downloadLink,
      });
      print("image uploaded Succesfully");
    }
  }
  void getAllPdf() async{
    final results = await _firebaseFirestore.collection("video").get();//is collection me jitna bhi data hoga vo sara get ho jayega

    pdfData= results.docs.map((e) => e.data()).toList();//e ke andar element ko return karega
//e.data map me convert karta hai .....toList list me convert karta hai
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPdf();//screen ki start me run karna hai
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: Text("videos"),
      ), // AppBar
      body: GridView.builder(
        itemCount: pdfData.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>PdfViewerScreen(pdfUrl:pdfData[index]['url'], ), ),);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), // BoxDecoration
                child: Column (
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/pdf.png",
                      height: 120,
                      width: 100,
                    ),

                    Text(
                      pdfData[index]['name'],

                      style: TextStyle(
                        fontSize: 18,
                      ), // TextStyle
                    ), // Text
                  ],
                ), // Column
              ), // Container
            ), // InkWell
          ); // Padding
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_file),
        onPressed: pickFile,
      ),

    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  void initialisePdf() async{
    print(widget.pdfUrl);
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialisePdf();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.network(widget.pdfUrl),
    );
  }
}

