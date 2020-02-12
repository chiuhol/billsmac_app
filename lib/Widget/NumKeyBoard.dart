import 'package:billsmac_app/Common/CommonInsert.dart';

///数字输入键盘,保留两位小数
///
///[controller] 编辑器控制器

typedef clickCallback = void Function(String value);

class NumberKeyboardActionSheet extends StatefulWidget {
  String amount;
  TextEditingController controller;
  final clickCallback onClick;

  NumberKeyboardActionSheet(
      {Key key, @required this.amount, @required this.controller, this.onClick})
      : super(key: key);

  @override
  State createState() => new _NumberKeyboardActionSheetState();
}

class _NumberKeyboardActionSheetState extends State<NumberKeyboardActionSheet> {
  ///键盘上的键值名称
  static const List<String> _keyNames = [
    '7',
    '8',
    '9',
    '<-',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '确定'
  ];

  ///控件点击事件
  void _onViewClick(String keyName) {
    print("keyName:" + keyName);
    var currentText = widget.amount; //当前的文本
    if (keyName == '确定' && _status == false) {
      widget.onClick(currentText + keyName);
      return;
    }
    if (keyName == '确定' && _status == true) {
      setState(() {
        _status = false;
      });
      List _a = [];
      var _num1, _num2;
      if (currentText.contains('+')) {
        _a = currentText.split("+");
        if (_a[1] == '') {
          currentText = double.parse(_a[0]).toString();
        } else {
          _num1 = double.parse(_a[0]);
          _num2 = double.parse(_a[1]);
          currentText = (_num1 + _num2).toString();
        }
      } else if (currentText.contains('-')) {
        _a = currentText.split("-");
        if (_a[1] == '') {
          currentText = double.parse(_a[0]).toString();
        } else {
          _num1 = double.parse(_a[0]);
          _num2 = double.parse(_a[1]);
          currentText = (_num1 - _num2).toString();
        }
      }
      widget.onClick(currentText);
      return;
    }
    if (keyName == "C") {
      widget.onClick(""); //清空输入栏
      return;
    }
    if (currentText == '0' && (RegExp('^[1-9]\$').hasMatch(keyName))) {
      //{如果第一位是数字0，那么第二次输入的是1-9，那么就替换}
      currentText = keyName;
      keyName = '';
    }
    if (currentText == '' && keyName == '+') {
      currentText = '0.00';
    }
    if ((currentText.contains("+") || currentText.contains("-")) &&
        keyName == '.') {
      List _a = [];
      if (currentText.contains("+")) {
        _a = currentText.split("+");
      } else {
        _a = currentText.split("-");
      }
      if (_a[1].contains(".")) {
        return;
      }
      widget.onClick(currentText + keyName);
      return;
    }
    if ((currentText.contains("+") || currentText.contains("-")) &&
        (RegExp('^[1-9]\$').hasMatch(keyName))) {
      List _a = [];
      if (currentText.contains("+")) {
        _a = currentText.split("+");
      } else {
        _a = currentText.split("-");
      }
      if (RegExp('^\\d+\\.\\d{2}\$').hasMatch(_a[1])) {
        CommonUtil.showMyToast("只能输入两位小数");
        return;
      }
    }
    if (RegExp('^\\d+\\.\\d{2}\$').hasMatch(currentText) &&
        keyName != '<-' &&
        keyName != '+' &&
        keyName != '-') {
      CommonUtil.showMyToast("只能输入两位小数");
      return;
    }
    if ((currentText == '' &&
            (keyName == '.' || keyName == '<-' || keyName == '-')) ||
        (RegExp('\\.').hasMatch(currentText) && keyName == '.'))
      return; //{不能第一个就输入.或者<-},{不能在已经输入了.再输入}
    if ((keyName == '-' || keyName == '+') &&
        (currentText.contains('+') || currentText.contains('-'))) {
      List _a = [];
      var _num1, _num2;
      if (currentText.contains('+')) {
        _a = currentText.split("+");
        if(_a[0] == ''){
          CommonUtil.showMyToast("小二不会做负数运算呢");
          return;
        }
        _num1 = double.parse(_a[0]);
        _num2 = double.parse(_a[1]);
        currentText = (_num1 + _num2).toString();
      } else if (currentText.contains('-')) {
        _a = currentText.split("-");
        if(_a[0] == ''){
          CommonUtil.showMyToast("小二不会做负数运算呢");
          return;
        }
        _num1 = double.parse(_a[0]);
        _num2 = double.parse(_a[1]);
        currentText = (_num1 - _num2).toString();
      } else {
        return;
      }
    }
    if (keyName == '<-') {
      //{回车键}
      if (currentText.length == 0) return;
      currentText = currentText.substring(0, currentText.length - 1);
      keyName = '';
    }
    print(currentText + keyName);
    widget.onClick(currentText + keyName);
  }

  ///数字展示面板
  Widget _showDigitalView() {
    return Container(
        height: 50.0,
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: Row(children: <Widget>[
          Container(
            child: Text(
              widget.amount ?? "",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            padding: const EdgeInsets.only(right: 8.0),
            constraints: BoxConstraints(minWidth: 100.0),
          ),
          Expanded(
              child: TextField(
            enabled: false,
            textAlign: TextAlign.end,
            controller: widget.controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入${widget.amount ?? ""}',
                hintStyle: TextStyle(
                    color: Color(0xeaeaeaea), fontSize: 18, letterSpacing: 2.0),
                contentPadding: const EdgeInsets.all(0.0)),
          ))
        ]));
  }

  bool _status = false; //确定与等号的状态
  ///构建显示数字键盘的视图
  Widget _showKeyboardGridView() {
    List<Widget> keyWidgets = new List();
    for (int i = 0; i < _keyNames.length; i++) {
      keyWidgets.add(Material(
          color:
              i == _keyNames.length - 1 ? MyColors.red_5c : MyColors.black_45,
          child: InkWell(
              onTap: () {
                if (_keyNames[i] == '+' || _keyNames[i] == '-') {
                  setState(() {
                    _status = true;
                  });
                }
                _onViewClick(_keyNames[i]);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width / 4.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.black_5f)),
                  height: 50,
                  child: Center(
                      child: i == 3
                          ? Icon(Icons.backspace, color: MyColors.white_fe)
                          : i == _keyNames.length - 1
                              ? Text(_status == false ? _keyNames[i] : "=",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: MyColors.white_fe,
                                      fontWeight: FontWeight.bold))
                              : Text(_keyNames[i],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: MyColors.white_fe,
                                      fontWeight: FontWeight.bold)))))));
    }
    return Padding(
        padding: EdgeInsets.only(top: 10), child: Wrap(children: keyWidgets));
  }

  ///完整输入的Float值
  void _completeInputFloatValue() {
//    var currentText = widget.controller.text;
    var currentText = widget.amount;
    if (currentText.endsWith('.')) //如果是小数点结尾的
//      widget.controller.text += '00';
      widget.amount += '00';
    else if (RegExp('^\\d+\\.\\d\$').hasMatch(currentText)) //如果是一位小数结尾的
//      widget.controller.text += '0';
      widget.amount += '0';
    else if (RegExp('^\\d+\$').hasMatch(currentText)) //如果是整数，则自动追加小数位
//      widget.controller.text += '.00';
      widget.amount += '.00';
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: Container(
            child: Column(children: <Widget>[
//            _showDigitalView(),
      Divider(height: 1.0),
      _showKeyboardGridView()
    ])));
  }

  @override
  void deactivate() {
    _completeInputFloatValue();
    super.deactivate();
  }
}
