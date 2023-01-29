import 'package:flutter/material.dart';
import 'package:flutter_dino_app/data/datasource/api/api_consumer.dart';
import 'package:flutter_dino_app/presentation/state/api_consumer/api_consumer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../state/auth/auth.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<OAuth2Provider>> providers =
        ref.watch(authMethodProvider);
    return providers.when(
      data: ((authMethods) {
        return Column(
          children: authMethods
              .map((e) => ElevatedButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext bc) => LoginModal(
                          providers: authMethods,
                        ),
                      );
                    },
                    child: Text(e.name),
                  ))
              .toList(),
        );
      }),
      error: (error, stackTrace) => Text('error ref $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class LoginModal extends ConsumerStatefulWidget {
  final List<OAuth2Provider> providers;
  const LoginModal({super.key, required this.providers});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginModalState();
}

const porviderSelectionned = 'discord';

class _LoginModalState extends ConsumerState<LoginModal> {
  late final WebViewController _controller;
  late final ApiConsumer client;

  @override
  void initState() {
    super.initState();
    client = ref.read(apiProvider);
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // I believe this need to be a deep link
    const redirectUri = "https://pocketbase.nospy.fr/redirect.html";
    final redirectUriEncoded = Uri.encodeQueryComponent(redirectUri);
    const scope = 'identify%20email';
    final clientIdEncoded = Uri.encodeQueryComponent(
      "1064464779634298911",
    );
    final provider = widget.providers.firstWhere(
      (provider) => provider.name == porviderSelectionned,
    );

    final state = Uri.encodeQueryComponent(provider.state);
    final codeChallenge = Uri.encodeQueryComponent(provider.codeChallenge);
    final codeMethode = Uri.encodeQueryComponent(provider.codeChallengeMethod);
    final initalUrl =
        'https://discord.com/api/oauth2/authorize?redirect_uri=$redirectUriEncoded&client_id=$clientIdEncoded&response_type=code&scope=$scope&state=$state&code_challenge=$codeChallenge&code_challenge_method=$codeMethode';
    _controller = controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.5195.124 Mobile Safari/537.36",
      )
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) async {
          if (request.url.startsWith(redirectUri)) {
            final uri = Uri.parse(request.url);
            final code = uri.queryParameters['code'];
            if (code != null) {
              final codeVerifier = widget.providers
                  .firstWhere(
                    (provider) => provider.name == porviderSelectionned,
                  )
                  .codeVerifier;
              final auth = await client.authWithOAuth2(
                porviderSelectionned,
                code,
                codeVerifier,
              );
              print('TAAAAAAAAAAAA');
              print(uri);
              print(auth);
              print(code);
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(initalUrl));
  }

  Decoration decoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: <Widget>[
          Container(
            decoration: decoration(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: WebViewWidget(controller: _controller),
            ),
          )
        ],
      ),
    );
  }
}
