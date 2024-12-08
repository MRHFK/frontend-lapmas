import 'package:flutter/material.dart';
import 'package:frontend_lapmas/screens/login_screen.dart';
import 'package:frontend_lapmas/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 132),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/masuk.png'),
              ),
              const SizedBox(
                height: 18.0,
              ),
              const Text(
                "Selamat Datang",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Aplikasi laporan masyarakat adalah perangkat lunak yang memungkinkan warga untuk melaporkan masalah atau kejadian penting kepada instansi melalui platform digital.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 26.0,
              ),
              Container(
                height: 72,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  },
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Container(
                height: 72,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(9.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const RegisterScreen();
                    }));
                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
