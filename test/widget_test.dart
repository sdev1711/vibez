// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';

import 'package:vibez/main.dart';
import 'package:vibez/screens/login/login_screen.dart';

void main() {
  testWidgets('Login Screen UI and Validation', (WidgetTester tester) async {
    Get.put(AppColors());
    // Load the app properly with GetMaterialApp and the correct screen
    await tester.pumpWidget(
      GetMaterialApp(
        home: LoginScreen(),
      ),
    );


    // Ensure all widgets exist
    await tester.pumpAndSettle();
    expect(find.byKey(Key('username_field')), findsOneWidget);
    expect(find.byKey(Key("password_field")), findsOneWidget);
    expect(find.byKey(Key("login_button")), findsOneWidget);

    // Tap login without entering data
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    // Ensure validation messages appear
    expect(find.text("Please enter a username"), findsOneWidget);
    expect(find.text("Please enter a password"), findsOneWidget);

    // Enter invalid username and password
    await tester.enterText(find.byKey(Key('username_field')), "dev.17");
    await tester.enterText(find.byKey(Key('password_field')), "123");
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump();

    // Ensure validation messages appear
    expect(find.text("Enter valid username"), findsOneWidget);
    expect(find.text("Enter valid password"), findsOneWidget);
  });
}

