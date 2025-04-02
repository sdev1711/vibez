import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibez/Cubit/auth/auth_cubit.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/screens/login/login_screen.dart';
import 'package:mocktail/mocktail.dart';
class MockAuthCubit extends Mock implements AuthCubit {}
@override
Stream<AuthState> get stream => BehaviorSubject<AuthState>();
void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    Get.put(AppColors());
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<AuthCubit>(
      create: (context) => mockAuthCubit,
      child: GetMaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('LoginScreen renders all UI components', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byKey(Key('username_field')), findsOneWidget);
    expect(find.byKey(Key('password_field')), findsOneWidget);
    expect(find.byKey(Key('login_button')), findsOneWidget);
  });

  testWidgets('Login button calls AuthCubit.login when form is valid', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('username_field')), 'testuser');
    await tester.enterText(find.byKey(Key('password_field')), 'password123');

    // Mock login behavior BEFORE tapping the button
    when(() => mockAuthCubit.login(username: any(named: 'username'), password: any(named: 'password')))
        .thenAnswer((_) async => Future.value());

    await tester.tap(find.byKey(Key('login_button')));
    await tester.pump(); // Allow UI update

    verify(() => mockAuthCubit.login(username: 'testuser', password: 'password123')).called(1);
  });

}
