import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController = ScrollController();
  late AnimationController _hideFabAnimController = AnimationController(
    vsync: this,
    duration: kThemeAnimationDuration,
    value: 1, // initially visible
  );
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        // Scrolling up - forward the animation (value goes to 1)
        case ScrollDirection.forward:
          _hideFabAnimController.forward();
          break;
        // Scrolling down - reverse the animation (value goes to 0)
        case ScrollDirection.reverse:
          _hideFabAnimController.reverse();
          break;
        // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  var classes = <ClassInfo>[];

  double? get gpa {
    return classes.gpa;
  }

  String get title {
    return "GPA: ${gpa?.toString() ?? "unavailable"}";
  }

  void _addClass() {
    setState(() {
      var u = ClassInfo();
      classes.add(u);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        controller: _scrollController,
        children: [..._buildClasses()],
      ),
      floatingActionButton: FadeTransition(
          opacity: _hideFabAnimController,
          child: ScaleTransition(
              scale: _hideFabAnimController,
              child: FloatingActionButton(
                onPressed: _addClass,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ))),
    );
  }

  List<Widget> _buildClasses() {
    return classes.map((e) => _buildClass(e)).toList();
  }

  Widget _buildClass(ClassInfo classInfo) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 800;
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: ElevatedButton(
              onPressed: () => {
                    setState(() {
                      classInfo.type = classInfo.type.next;
                    })
                  },
              child: Text("${classInfo.type.short}")),
          title: TextFormField(
            initialValue: "",
            decoration: InputDecoration(
              hintText: "Class Name",
            ),
            onChanged: (value) => {
              setState(() {
                classInfo.name = value;
              })
            },
          ),
          subtitle: Flex(
              direction: isScreenWide ? Axis.horizontal : Axis.vertical,
              children: <Widget>[
                Expanded(
                    flex: 9,
                    child: TextFormField(
                      initialValue: "",
                      decoration: InputDecoration(
                        hintText: "Quarter 1",
                      ),
                      onChanged: (value) => {
                        setState(() {
                          classInfo.firstQuarter = double.tryParse(value);
                        })
                      },
                    )),
                Spacer(),
                Expanded(
                    flex: 9,
                    child: TextFormField(
                      initialValue: "",
                      decoration: InputDecoration(
                        hintText: "Quarter 2",
                      ),
                      onChanged: (value) => {
                        setState(() {
                          classInfo.secondQuarter = double.tryParse(value);
                        })
                      },
                    )),
                Spacer(),
                Expanded(
                    flex: 9,
                    child: TextFormField(
                      initialValue: "",
                      decoration: InputDecoration(
                        hintText: "Exam",
                      ),
                      onChanged: (value) => {
                        setState(() {
                          classInfo.finalExam = double.tryParse(value);
                        })
                      },
                    )),
                Spacer(),
                Expanded(
                    flex: 9,
                    child: Text(
                        "GPA: ${classInfo.gpa?.toString() ?? "unavailable"}"))
              ]),
        ));
  }
}
