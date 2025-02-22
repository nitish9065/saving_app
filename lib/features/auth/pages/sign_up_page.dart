import 'dart:developer';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/providers/loader.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/widgets/app_constrained_scroll_view.dart';
import 'package:saving/core/widgets/app_scaffold.dart';
import 'package:saving/core/widgets/app_textfield.dart';
import 'package:saving/features/auth/provider/auth_page_provider.dart';
import 'package:saving/features/auth/provider/sign_up_provider.dart';
import 'package:saving/features/auth/provider/sign_up_state.dart';
import 'package:saving/features/auth/widgets/fake_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving/features/auth/widgets/powered_by.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController otpController;
  late final bool canPop;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.slowMiddle,
      ),
    );
    animationController.repeat(
      reverse: false,
    );
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    otpController = TextEditingController();

    ref.listenManual(
      signUpProvider,
      (previous, next) {
        if (next is SignUpErrorState) {
          context.showSnackBar(next.error);
        }
        if (next is SignUpSuccessState) {
          log('Successfully logged In');
        }
      },
    );

    canPop = Navigator.of(context).canPop();
  }

  @override
  void dispose() {
    animationController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: canPop ? null : const FakeAppBar(),
      body: AppConstrainedScrollView(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              color: AppColor.primary,
            ),
            if (canPop) ...[
              Positioned(
                top: 8.0,
                child: IconButton(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColor.whiteColor,
                  ),
                ),
              )
            ],
            Positioned(
              top: kBottomNavigationBarHeight / 2,
              left: 16.0,
              right: 16.0,
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight / 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.0,
                  children: [
                    Text(
                      'Start your journey to financial freedom today',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColor.whiteColor,
                              ),
                    ),
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) => SlideTransition(
                        position: animation,
                        child: FittedBox(
                          child: Text(
                            'Plan, save, and invest—all in one place.',
                            maxLines: 1,
                            softWrap: true,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColor.yellowColor,
                                      fontSize: 18,
                                    ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Builder(builder: (context) {
              double width;
              if (context.width > 900) {
                width = context.width * 0.5;
              } else {
                width = context.width;
              }
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Card(
                    elevation: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Signup',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Already Have an Account?'),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(authPageProvider.notifier)
                                      .showLogin(true);
                                },
                                child: const Text(
                                  'Login',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppTextfield(
                                  controller: nameController,
                                  hintText: 'Name',
                                  capitalization: TextCapitalization.words,
                                  prefixIcon: Icons.person_2_rounded,
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                AppTextfield(
                                  controller: emailController,
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email,
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                PasswordField(
                                  controller: passwordController,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              context.removeFocus();
                              ref.read(loaderProvider.notifier).showLoader();

                              await ref
                                  .read(signUpProvider.notifier)
                                  .createAccount(
                                    emailController.text.trim(),
                                    nameController.text.trim(),
                                    passwordController.text.trim(),
                                  )
                                  .whenComplete(() {
                                ref.read(loaderProvider.notifier).hideLoader();
                              });
                              return;
                            },
                            child: const Text('Create'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            PoweredByWidget(
              opacity: MediaQuery.of(context).viewInsets.bottom == 0 ? 1 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
