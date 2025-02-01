import 'dart:developer';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:top_headlines/news_article.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class NewsWebView extends StatefulWidget {
  final Article article;

  const NewsWebView({super.key, required this.article});

  @override
  State<NewsWebView> createState() => _NewsWebviewState();
}

class _NewsWebviewState extends State<NewsWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.article.url!));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // 60% of screen height
          minChildSize: 0.3, // At least 30% height
          maxChildSize: 0.95, // Max 95% height
          expand: false, // Prevents forced fullscreen
          builder: (context, scrollController) {
            return FutureBuilder<String?>(
              future: summarizeArticleContent(widget.article),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "AI Summary",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 24, width: double.infinity),
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Extracting content... Please wait.'),
                      ],
                    ),
                  );
                } else if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Failed to extract article content.'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "AI Summary",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(snapshot.data!, textAlign: TextAlign.justify),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<String?> summarizeArticleContent(Article article) async {
    try {
      var extractedArticle = await extractArticleContent(article);
      final String? apiKey = dotenv.env['GEMINI_API_KEY'];
      final aiModel = "gemini-1.5-flash";
      final model = GenerativeModel(model: aiModel, apiKey: apiKey!);

      final prompt = """
          You are an AI tool designed to summarize articles or news. The provided article has the following:
            •	Title: ${article.title}
            •	Content: $extractedArticle (scraped from a news website, which may contain unrelated or extraneous information).

          Your task:
            1.	Focus only on content relevant to the given title. Ignore any unrelated or irrelevant text.
            2.	Generate a concise and coherent summary that captures the main points of the article.
            3.	Maintain the original intent and key details while keeping the summary clear and easy to understand.

          If the content is too noisy and lacks useful information, respond with: “The provided content does not contain a relevant summary.”
      """;
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text;
    } catch (e) {
      log('Error summarizing article content: $e');
    }
    return null;
  }

  Future<String?> extractArticleContent(Article article) async {
    try {
      final response = await http.get(Uri.parse(article.url!));
      if (response.statusCode == 200) {
        String html = response.body;

        // Parse HTML using BeautifulSoup
        BeautifulSoup soup = BeautifulSoup(html);
        final paragraphs = soup.findAll('p');
        return paragraphs.map((p) => p.text).join("\n");
      }
    } catch (e) {
      log('Error extracting article content: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('News Detail'),
        actions: [
          IconButton(
            onPressed: () => _showBottomSheet(context),
            icon: Image.asset(
              'lib/icons/ic_sparkle.png',
              width: 24.0,
              height: 24.0,
            ),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
