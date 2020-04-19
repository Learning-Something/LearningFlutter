import 'dart:io';

import 'package:agenda/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_page.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();


  @override
  void initState() {
    super.initState();
//    Contact c = Contact();
//    c.name = 'Ana Paula';
//    c.email = 'anapaula_gdm@hotmail.com';
//    c.phone = '61983049602';
//    helper.saveContact(c);
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                  value: OrderOptions.orderaz,
                  child: Text('Ordernar de A-Z'),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderza,
                child: Text('Ordernar de Z-A'),
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContactPage();
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) => _contactCard(context, index)
        ),
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                        FileImage(File(contacts[index].img)) :
                        AssetImage('images/person.png'),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contacts[index].name ?? '',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? '',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(contacts[index].phone ?? '',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
       _showOptions(context, index);
      },
    );
  }

  void _showContactPage({Contact contact}) async {
   final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
   );
   if (recContact != null) {
     if (contact != null) {
       await helper.updateContact(recContact);
     } else {
       await helper.saveContact(recContact);
     }
     _getAllContacts();
   }
  }

  void _getAllContacts() => helper.getAllContacts().then((list) => setState(() => contacts = list));

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                            child: Text('Ligar',
                              style: TextStyle(
                                  color: contacts[index].phone != null ? Colors.black : Colors.grey,
                                  fontSize: 20
                              ),
                            ),
                            onPressed: () {
                              if (contacts[index].phone != null) {
                                launch('tel:${contacts[index].phone}');
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                            child: Text('Enviar Email',
                              style: TextStyle(
                                  color: contacts[index].email != null ? Colors.black : Colors.grey,
                                  fontSize: 20
                              ),
                            ),
                            onPressed: () {
                              if (contacts[index].email != null) {
                                launch('mailto:${contacts[index].email}?subject=${contacts[index].name}:%20&body=Novo%20Email');
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                            child: Text('Editar',
                              style: TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactPage(contact: contacts[index]);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                            child: Text('Excluir',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Tem certeza que deseja excluir?'),
                                      content: Text('Essa ação não pode ser revertida!'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('Cancelar'),
                                            onPressed: () => Navigator.pop(context)
                                        ),
                                        FlatButton(
                                          child: Text('Sim'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            helper.deleteContact(contacts[index].id);
                                            this.setState(() => contacts.removeAt(index));
                                          },
                                        )
                                      ],
                                    );
                                  }
                              );
                            },
                          ),
                        ),
                      ],
                  ),
                );
              }
          );
        }
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

}
