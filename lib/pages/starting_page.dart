import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_chronicle/pages/home_page.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 230, 230),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo

              SvgPicture.asset(
                "assets/earth.svg",
                height: 150,
                color: const Color.fromARGB(255, 104, 69, 164),
              ),

              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'GeoChronicle',
                  style: TextStyle(
                      color: Color.fromARGB(255, 97, 94, 182),
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  textAlign: TextAlign.center,
                  '"Chart your journey, chronicle your time"',
                  style: TextStyle(
                      color: Color.fromARGB(255, 131, 130, 130), fontSize: 20),
                ),
              ),

              const SizedBox(
                height: 80,
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage())),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 49, 18, 77),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Text(
                      "Start",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
