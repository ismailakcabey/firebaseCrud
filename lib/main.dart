import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: FirebaseCrud(),
  ));
}

class FirebaseCrud extends StatefulWidget {
  @override
  _FirebaseCrudState createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  String? ad,alanKisi,sayfaSayisi,id,kategori;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("crud islemeri"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                onChanged: (String idi){
                  setState(() {
                    id = idi;
                  });
                },
                decoration: InputDecoration(
                    labelText: "kitap id",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2))
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                onChanged: (String adi){
                  setState(() {
                    ad = adi;
                  });
                },
                decoration: InputDecoration(
                    labelText: "kitap adi",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2))
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                onChanged: (String kategor){
                  setState(() {
                    kategori = kategor;
                  });
                },
                decoration: InputDecoration(
                    labelText: "kitap kategorisi",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2))
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                onChanged: (String kisi){
                  setState(() {
                    alanKisi = kisi;
                  });
                },
                decoration: InputDecoration(
                    labelText: "kitabi alan kisi",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2))
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                onChanged: (String sayfaSayi){
                 setState(() {
                   sayfaSayisi = sayfaSayi;
                 });
                },
                decoration: InputDecoration(
                    labelText: "kitap sayfa sayisi",
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2))
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8),
            child: Row(
              children: [
                ElevatedButton(onPressed: (){
                  veriEkle();
                }, child: Text("ekle")),
                ElevatedButton(onPressed: (){
                  veriSil();
                }, child: Text("sil")),
                ElevatedButton(onPressed: (){
                  veriGuncelle();
                },
                    child: Text("guncelle")),

              ],
            ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('kitaplik').snapshots(),

              builder: (BuildContext context, AsyncSnapshot alinanVeri){
                if(alinanVeri.hasError)return Text("aktarim basarasiz");
                if(alinanVeri == null) return CircularProgressIndicator();
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: alinanVeri.data.docs.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot satirVerisi = alinanVeri.data.docs[index];

                      return Padding(padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(child: Text(satirVerisi['kitapId'])),
                            Expanded(child: Text(satirVerisi['kitapAdi'])),
                            Expanded(child: Text(satirVerisi['kitapKategorisi'])),
                            Expanded(child: Text(satirVerisi['kitabiAlanKisi'])),
                            Expanded(child: Text(satirVerisi['kitapSayfaSayisi'])),

                          ],
                        ),
                      );
                    });
              },


            )

          ],
        ),
      ),
    );
  }

  void veriEkle() {
    DocumentReference veriYolu = FirebaseFirestore.instance.collection('kitaplik').doc(id);
    Map<String, dynamic> kitaplar = {
      'kitapId' : id,
      'kitapAdi' : ad,
      'kitapKategorisi' : kategori,
      'kitabiAlanKisi' : alanKisi,
      'kitapSayfaSayisi' : sayfaSayisi
    };
    veriYolu.set(kitaplar).whenComplete(() => {
      Fluttertoast.showToast(msg: "islem tamamlandi")
    });
  }

  void veriSil() {
    DocumentReference veriSil = FirebaseFirestore.instance.collection('kitaplik').doc(id);
    veriSil.delete().whenComplete(() => {
      Fluttertoast.showToast(msg: "kitap silindi")
    });
  }

  void veriGuncelle() {
    DocumentReference veriGuncellemeYolu = FirebaseFirestore.instance.collection('kitaplik').doc(id);
    Map<String,dynamic> guncellenecekVeri = {
      'kitapId' : id,
      'kitapAdi' : ad,
      'kitapKategorisi' : kategori,
      'kitabiAlanKisi' : alanKisi,
      'kitapSayfaSayisi' : sayfaSayisi
    };
    veriGuncellemeYolu.update(guncellenecekVeri).whenComplete(() => {
      Fluttertoast.showToast(msg: "kitap guncellendi")
    });
  }

}
