import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

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
              const Text("Developed by the UAegean | i4m Lab, and the PALAEMON Consortium", style: TextStyle(fontSize: 18, color: Colors.black54), textAlign: TextAlign.justify,),


            ],

          ),

        )

    );

  }
}


