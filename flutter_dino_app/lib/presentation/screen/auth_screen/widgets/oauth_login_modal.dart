import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dino_app/presentation/widgets/bottom_sheet_decoration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../../data/datasource/api/api_consumer.dart';
import '../../../state/api_consumer/api_consumer.dart';
import '../../../state/auth/auth.dart';

Widget buildOauthLoginModal(OAuth2Provider provider, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      onPressed: () async {
        await showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) => LoginOAuthModal(
            provider: provider,
            context: context,
          ),
        );
      },
      child: Text(provider.name),
    ),
  );
}

class LoginOAuthModal extends ConsumerStatefulWidget {
  final OAuth2Provider provider;
  final BuildContext context;
  const LoginOAuthModal({
    super.key,
    required this.provider,
    required this.context,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginOAuthModalState();
}

// todo create a state or pass params to see which provider is selected

class _LoginOAuthModalState extends ConsumerState<LoginOAuthModal> {
  late final WebViewController _controller;
  late final ApiConsumer client;

  PlatformWebViewControllerCreationParams _optimisedParams() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    }
    return const PlatformWebViewControllerCreationParams();
  }

  FutureOr<NavigationDecision> _onNavigationRequest(
      NavigationRequest request) async {
    if (!request.url.startsWith(redirectUri)) {
      return NavigationDecision.navigate;
    }
    final uri = Uri.parse(request.url);
    final code = uri.queryParameters['code'];
    if (code != null) {
      final codeVerifier = widget.provider.codeVerifier;
      final auth = await client.authWithOAuth2(
        widget.provider.codeVerifier,
        code,
        codeVerifier,
      );
      // TODO change to use go router and adapte for web
      Navigator.of(widget.context).pop();
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  void initState() {
    super.initState();
    client = ref.read(apiProvider);
    final PlatformWebViewControllerCreationParams params = _optimisedParams();
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    final provider = widget.provider;
    final initalUrl = buildUrlFromProvider(provider);
    _controller = controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.5195.124 Mobile Safari/537.36",
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => _onNavigationRequest(request),
        ),
      )
      ..loadRequest(Uri.parse(initalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(
        children: <Widget>[
          Container(
            decoration: bottom_sheet_decoration(),
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