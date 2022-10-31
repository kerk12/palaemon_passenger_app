import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  static const textStyling = TextStyle(fontSize: 18, color: Colors.black54);
  static const linkStyling = TextStyle(fontSize: 18, color: Color(0xff1F9AD6), decoration: TextDecoration.underline,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Palaemon Passenger App Info'),),
        body: Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8, top: 25, bottom: 18),
          child: Column(
            children: [
              Row(
                  children: [
                    Image.asset("assets/images/flag_europe.jpg", width:85, height:135),
                    const SizedBox(width: 10,),
                    const Flexible(child: Text("The PALAEMON Project has received funding from the European Union’s Horizon 2020 Research and Innovation Programme under Grant Agreement No 814962",
                      style: TextStyle(fontSize: 16, color: Colors.black54), textAlign: TextAlign.justify,)
                    )
                  ]
              ),
              const SizedBox(height: 15),
              Wrap(
                children: [
                  const Text("Developed by the , ", style: textStyling),
                  InkWell(child: const Text("UAegean | i4m Lab",style: linkStyling),onTap: () => launch('http://www.atlantis-group.gr/i4Mlab/'),),
                  const Text(" and the ",style: textStyling),
                  InkWell(child:const Text("PALAEMON Consortium", style: linkStyling),onTap: () => launchUrlString('https://palaemonproject.eu/'),),
                ],
              ),
            ],
          ),
        )
    );
  }
}


