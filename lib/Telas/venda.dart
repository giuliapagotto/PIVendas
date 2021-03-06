import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertreinaweb/Telas/cliente.dart';
import 'package:fluttertreinaweb/Telas/home.dart';
import 'package:fluttertreinaweb/Telas/lista_vendas.dart';
import 'package:fluttertreinaweb/Telas/login.dart';
import 'package:fluttertreinaweb/Telas/produto.dart';
import 'package:fluttertreinaweb/Telas/vendedor.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



const RoxoBonito = const Color(0xFF7953D2);

class VendaScreen extends StatefulWidget {
  @override
  _VendaScreenState createState() => new _VendaScreenState();
}

class _VendaScreenState extends State<VendaScreen> {
  String _cliente;
  String _produto;
  int tamanho = 1;
  int pagamento = 1;
  String _vendedor;
  String _valorTotal;
  int quantidade = 1;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var gestorHome = false;

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  Future<bool> _getBool() async {
    final prefs = await SharedPreferences.getInstance();
    final gestorLog = prefs.getBool("loginGestor");
    if (gestorLog == true) {
      gestorHome = true;
    }
    if (gestorLog == false) {
      gestorHome = false;
    }
  }

  Future<void> _resetBool() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginGestor', false);
    gestorHome = false;
  }

  _cadastrarVenda() async {
    // set up POST request arguments
    String url = 'https://vendasprojeto.herokuapp.com/vendas';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"user": "${maskFormatterCPFVendedor.getUnmaskedText()}", "cliente": "${maskFormatterCPFCliente.getUnmaskedText()}", "valor": "${_valorTotal}", "formaPagamento": "${pagamento}", "tamanho": "${tamanho}", "quantidade": "${quantidade}", "produto": "${_produto}"}';
    // make POST request
    http.Response response = await http.post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String responseBody = response.body;
    //home navigation
    if (statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      Fluttertoast.showToast(
              msg: "Venda cadastrada",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
    }
    //erro
    if (statusCode == 400) {
       Fluttertoast.showToast(
              msg: "Vendedor não encontrado",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
    }
    if (statusCode == 401) {
       Fluttertoast.showToast(
              msg: "Cliente não encontrado",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
    }
  }

  var maskFormatterCPFVendedor = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterCPFCliente = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });

  Widget _buildVendedor() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'CPF do Vendedor'),
      inputFormatters: [maskFormatterCPFVendedor],
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'CPF é obrigatório';
        }

        return null;
      },
      onSaved: (String value) {
        _vendedor = value;
      },
    );
  }

  Widget _buildCliente() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'CPF do Cliente'),
      inputFormatters: [maskFormatterCPFCliente],
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'CPF é obrigatório';
        }

        return null;
      },
      onSaved: (String value) {
        _cliente = value;
      },
    );
  }

  Widget _buildProduto() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Produto'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Produto é obrigatório';
        }

        return null;
      },
      onSaved: (String value) {
        _produto = value;
      },
    );
  }

  Widget _buildTamanhoLabel() {
    return Container(
        padding: EdgeInsets.only(top: 30.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'Tamanho',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ));
  }

  Widget _buildTamanhoRadio() {
    return Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Radio(
                  value: 1,
                  activeColor: RoxoBonito,
                  groupValue: tamanho,
                  onChanged: (T) {
                    print(T);

                    setState(() {
                      tamanho = T;
                    });
                  },
                ),
                Text("Grande",
                    style: TextStyle(
                        color: Color(0xFF527DAA),
                        letterSpacing: 2.0,
                        fontSize: 14.0)),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 2,
                  activeColor: RoxoBonito,
                  groupValue: tamanho,
                  onChanged: (T) {
                    print(T);

                    setState(() {
                      tamanho = T;
                    });
                  },
                ),
                Text("Médio",
                    style: TextStyle(
                        color: Color(0xFF527DAA),
                        letterSpacing: 2.0,
                        fontSize: 14.0))
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 3,
                  activeColor: RoxoBonito,
                  groupValue: tamanho,
                  onChanged: (T) {
                    print(T);

                    setState(() {
                      tamanho = T;
                    });
                  },
                ),
                Text("Pequeno",
                    style: TextStyle(
                        color: Color(0xFF527DAA),
                        letterSpacing: 2.0,
                        fontSize: 14.0))
              ],
            )
          ],
        ));
  }

  Widget _buildPagamentoLabel() {
    return Container(
        padding: EdgeInsets.only(top: 30.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'Forma de Pagamento',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ));
  }

  Widget _buildFormaPagamentoRadio() {
    return Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Radio(
                value: 1,
                activeColor: RoxoBonito,
                groupValue: pagamento,
                onChanged: (T) {
                  print(T);

                  setState(() {
                    pagamento = T;
                  });
                },
              ),
              Text("Crédito",
                  style: TextStyle(
                      color: Color(0xFF527DAA),
                      letterSpacing: 1.5,
                      fontSize: 14.0))
            ]),
            Row(children: <Widget>[
              Radio(
                value: 2,
                activeColor: RoxoBonito,
                groupValue: pagamento,
                onChanged: (T) {
                  print(T);

                  setState(() {
                    pagamento = T;
                  });
                },
              ),
              Text("Débito",
                  style: TextStyle(
                      color: Color(0xFF527DAA),
                      letterSpacing: 1.5,
                      fontSize: 14.0))
            ]),
            Row(
              children: <Widget>[
                Radio(
                  value: 3,
                  activeColor: RoxoBonito,
                  groupValue: pagamento,
                  onChanged: (T) {
                    print(T);

                    setState(() {
                      pagamento = T;
                    });
                  },
                ),
                Text("Dinheiro",
                    style: TextStyle(
                        color: Color(0xFF527DAA),
                        letterSpacing: 1.5,
                        fontSize: 14.0))
              ],
            )
          ],
        ));
  }

  Widget _buildValorTotal() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Valor Total', prefixText: "R\$"),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Valor é obrigatório';
        }

        return null;
      },
      onSaved: (String value) {
        _valorTotal = value;
      },
    );
  }

  Widget _buildAddLabel() {
    return Container(
        padding: EdgeInsets.only(top: 30.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'Quantidade',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ));
  }

  Widget _buildAddProduto() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                 setState(() {
                   if(quantidade > 1){
                    quantidade = quantidade - 1;
                    }
                  });
                },
                child: Icon(Icons.remove, color: RoxoBonito)),
            SizedBox(
              width: 40.0,
            ),
            Text(quantidade.toString(),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 35.0,
                )),
            SizedBox(
              width: 40.0,
            ),
            FlatButton(
                onPressed: () {
                  setState(() {
                    quantidade = quantidade + 1;
                  });
                },
                child: Icon(Icons.add, color: RoxoBonito))
          ],
        ));
  }

  Widget _buildSaveBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }
          _formKey.currentState.save();
         _cadastrarVenda();
        },
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text('CADASTRAR',
            style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 2.0,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans')),
      ),
    );
  }

  _handleDrawer() {
    _key.currentState.openDrawer();

    setState(() {
      _getBool();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _key,
        appBar: AppBar(
          title: Text('Cadastrar venda'),
          leading: new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: _handleDrawer,
        ),
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              Ink(
                  color: RoxoBonito,
                  height: 80.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: new ListTile(
                      title: new Text(
                        "MENU",
                        style: new TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            letterSpacing: 2.0),
                      ),
                    ),
                  )),
              new ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "HOME",
                      style: new TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Home Pressed');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  trailing: new Icon(Icons.home)),
              new Divider(),
              new ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "CADASTRAR VENDA",
                      style: new TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Cadastrar Venda Pressed');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VendaScreen()));
                  },
                  trailing: new Icon(Icons.add)),
              new Divider(),
              new ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "CADASTRAR CLIENTE",
                      style: new TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Cadastrar Cliente Pressed');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClienteScreen()));
                  },
                  trailing: new Icon(Icons.person_add)),
              new Divider(),
              new ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "CADASTRAR PRODUTO",
                      style: new TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Cadastrar Produto Pressed');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProdutoScreen()));
                  },
                  trailing: new Icon(Icons.add_shopping_cart)),
              new Divider(),
              Visibility(
              child: new ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "CADASTRAR VENDEDOR",
                      style: new TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Cadastrar Vendedor Pressed');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendedorScreen()));
                  },
                  trailing: new Icon(Icons.person_outline)),
              visible: gestorHome,
            ),
            Visibility(child: new Divider(), visible: gestorHome),
              new ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "LISTA DE VENDAS",
                      style: new TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    print('Lista de Vendas Pressed');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListaVendaScreen()));
                  },
                  trailing: new Icon(Icons.view_list)),
              new Divider(),
              new ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new Text(
                      "SAIR",
                      style: new TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    _resetBool();
                    print('Logout Pressed');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  trailing: new Icon(Icons.exit_to_app))
            ],
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(children: <Widget>[
              Container(
                  height: double.infinity,
                  margin: EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildProduto(),
                          _buildTamanhoLabel(),
                          _buildTamanhoRadio(),
                          _buildAddLabel(),
                          _buildAddProduto(),
                          _buildVendedor(),
                          _buildCliente(),
                          _buildPagamentoLabel(),
                          _buildFormaPagamentoRadio(),
                          _buildValorTotal(),
                          _buildSaveBtn()
                        ],
                      ),
                    ),
                  ))
            ])));
  }
}
