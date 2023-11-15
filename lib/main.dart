import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signify/widget/file_choose_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as path;

const String KEY_FLUTTER = 'flutter_path';
Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter signify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home:  MyHomePage(title: 'Flutter signify'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {

   MyHomePage({super.key, required this.title}){
  }

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String flutterPath = "";
  String signifyPath = "";
  String logPath = "";
  String output = "";

  bool isAutoMode = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
     flutterPath = GetStorage().read(KEY_FLUTTER)??"";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10, left: 10),
        child: Column(
          children: [
            FileChooseWidget("flutter路径", (filePath) {
              flutterPath = filePath;
              GetStorage().write(KEY_FLUTTER, filePath);
            },flutterPath),
            const SizedBox(height: 10,),
            FileChooseWidget("符号表", (filePath) {
              signifyPath = filePath;
            },signifyPath),
            const SizedBox(height: 10,),
            FileChooseWidget("日志", (filePath) {
              setState(() {
                logPath = filePath;
              });
            },logPath),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFD3D3D3)),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(fontSize: 15)),
              ),
              child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 50,
                child: const Text("分析"),
              ),
              onPressed: () async {
                if (signifyPath.isEmpty) {
                  Toast.show("请配置符号表文件目录",
                      duration: Toast.lengthShort, gravity: Toast.bottom);
                } else if (logPath.isEmpty) {
                  Toast.show("请配置日志文件目录",
                      duration: Toast.lengthShort, gravity: Toast.bottom);
                } else {
                  runProcess(flutterPath,signifyPath, logPath);
                }
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                output,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> runProcess(String flutterPath,String signifyPath, String logPath) async {
    setState(() {
      output = "";
    });
    String executable = '/bin/bash';
    List<String> arguments = [];
    arguments.add('-c');
    String outputPath = "${path.dirname(logPath)}/restack.txt";
    arguments.add("$flutterPath symbolize --debug-info=$signifyPath --input=$logPath --output=$outputPath" );
    // arguments.add("symbolize");
    // arguments.add("--debug-info=$signifyPath");
    // arguments.add("--input=$logPath");
    // String outputPath = "${path.dirname(logPath)}/restack.txt";
    // arguments.add("--output=$outputPath");

    EasyLoading.show(status: "加载中....", maskType: EasyLoadingMaskType.black);
    try {
      var result = await Process.run(executable, arguments,
          runInShell: false);

      String errorMsg = result.stderr.toString();
      String outMsg = result.stdout.toString();

      if (errorMsg.isEmpty) {
        Toast.show("分析成功");
        Process.runSync("open", [outputPath]);
      }
      setState(() {
        output = errorMsg + outMsg;
      });

      print("#########error:${errorMsg}");
      print("#########output:${output}");
    } catch (e) {
      print("#######3exception:${e.toString()}");
      setState(() {
        output =e.toString();
      });

    }finally{
      EasyLoading.dismiss();
    }
  }
}
