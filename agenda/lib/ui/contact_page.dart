import 'dart:io';

import 'package:agenda/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    } else {
      _editedContact = Contact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.name ?? 'Novo Contato'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              bool nameFilled = _editedContact.name != null && _editedContact.name.isNotEmpty;
              bool emailFilled = _editedContact.email != null && _editedContact.email.isNotEmpty;
              bool phoneFilled = _editedContact.phone != null && _editedContact.phone.isNotEmpty;
              if (nameFilled && (emailFilled || phoneFilled)) {
                Navigator.pop(context, _editedContact);
              } else {
                if (!nameFilled) {
                  FocusScope.of(context).requestFocus(_nameFocus);
                } else if (!emailFilled) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                } else if (!phoneFilled) {
                  FocusScope.of(context).requestFocus(_phoneFocus);
                }
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.green,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
                      if (file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.img != null ?
                            FileImage(File(_editedContact.img)) :
                            AssetImage('images/person.png'),
                          fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: 'Nome'),
                  onChanged: (text) => this.setState(() {
                    _userEdited = true;
                    _editedContact.name = text;
                  }),
                ),
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  decoration: InputDecoration(labelText: 'Telefone'),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Descartar alterações?'),
            content: Text('Se sair as alterações serão perdidas!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context)
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
