# flutter_signify

 
使用flutter symbolize分析混淆过的堆栈日志

## 说明

<img src="https://github.com/VincentTung/flutter_signify/blob/main/art/art1.jpg" width="800" height="628" />

核心原理

```shell
flutter symbolize --debug-info=</out/android/app.arm64.symbols>     --input=</crashes/stack_trace.err>   --output=<A file path for a symbolized stack trace to be written to.>
```

* flutter：设置flutter所在的位置，首次设置一次即可
* 符号表:设置混淆后生成的符号表
* 日志: 设置需要分析的混淆堆栈信息文件

点击分析后，混调用flutter symbolize命令进行符号化，成功后会自动打开结果文件。

编译命令
```shell

flutter build macos
hdiutil create -volname "flutter signify" -srcfolder /Users/vt/Documents/GitHub/flutter_signify/build/macos/Build/Products/Release/flutter_signify.app -ov -format UDZO flutter_signify.dmg
```