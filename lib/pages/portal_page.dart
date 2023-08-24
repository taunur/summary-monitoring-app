import 'package:flutter/material.dart';
import 'package:summary_monitoring/theme.dart';
import 'package:summary_monitoring/widgets/suplier_card.dart';

class PortalPage extends StatelessWidget {
  const PortalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgrounColor1,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                'Select Supplier',
                style: textOpenSans.copyWith(
                  color: blackColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SuplierCard(
                    namaSupllier: 'Toyota',
                    descriptionSupllier:
                        'One of the best auto parts manufacturers in the world.',
                    logoSupllier: 'assets/images/toyota.png',
                    press: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  SuplierCard(
                    namaSupllier: 'Asana',
                    descriptionSupllier:
                        'Asana powers businesses by organizing work in one connected space.',
                    logoSupllier: 'assets/images/asana.png',
                    press: () {},
                  ),
                  SuplierCard(
                    namaSupllier: 'Mitsubishi Motors',
                    descriptionSupllier:
                        'Mitsubishi Motors is the sixth largest automotive manufacturer by volume in Japan.',
                    logoSupllier: 'assets/images/mitsubishi.png',
                    press: () {},
                  ),
                  SuplierCard(
                    namaSupllier: 'Ferrari',
                    descriptionSupllier:
                        'Ferrari is a manufacturer of high-performance Italian super cars and racing cars based in  Maranello, Italy.',
                    logoSupllier: 'assets/images/ferrai.png',
                    press: () {},
                  ),
                  SuplierCard(
                    namaSupllier: 'Lamborghini',
                    descriptionSupllier:
                        'Automobili Lamborghini S.p.A. is an Italian brand and manufacturer of luxury sports cars.',
                    logoSupllier: 'assets/images/lamborghini.png',
                    press: () {},
                  ),
                  SuplierCard(
                    namaSupllier: 'Mitsubishi Motors',
                    descriptionSupllier:
                        'Mitsubishi Motors is the sixth largest automotive manufacturer by volume in Japan.',
                    logoSupllier: 'assets/images/mitsubishi.png',
                    press: () {},
                  ),
                  SuplierCard(
                    namaSupllier: 'Asana',
                    descriptionSupllier:
                        'Asana powers businesses by organizing work in one connected space.',
                    logoSupllier: 'assets/images/asana.png',
                    press: () {},
                  ),
                  SuplierCard(
                    namaSupllier: 'Mitsubishi Motors',
                    descriptionSupllier:
                        'Mitsubishi Motors is the sixth largest automotive manufacturer by volume in Japan.',
                    logoSupllier: 'assets/images/mitsubishi.png',
                    press: () {},
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
