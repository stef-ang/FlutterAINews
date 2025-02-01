# FlutterAINews
A Multiplatform News App built with Flutter, integrated with Gemini AI for Summarization.

## ✨ Demo

Main Screen | WebView and AI Summarization |
--- | --- |
<img width="903" alt="Screenshot 2025-02-02 at 00 14 18" src="https://github.com/user-attachments/assets/876cd79c-cdb7-4cd3-8d8b-3da1925ada1c" /> | <img width="899" alt="Screenshot 2025-02-02 at 00 14 34" src="https://github.com/user-attachments/assets/301e4154-268e-4fa6-9d83-1ce74e2c88dc" />

- The main screen displays the top news headlines in the US, featuring an image, title, and description.
- Users can tap on any news article to open the full content in a WebView.
- By clicking the AI icon (top-right), users can get a summary of the news article powered by Gemini AI.

## ⚙️ Setup / How to use

Follow these steps to set up the app locally:
1. Generate API Keys:
  - Get your [NewsAPI](https://newsapi.org/account) key to fetch news data.
  - Obtain your [Gemini AI API key](https://aistudio.google.com/apikey) for accessing AI summarization services.
2. Configure Environment Variables:
- Create a `.env` file in the root directory of the project and add your API keys.
```.env file
// inside your .env file
NEWS_API_KEY=<your_news_api_key>
GEMINI_API_KEY=<your_gemini_api_key>
```
3. Run the App: `flutter run`

## 📚 Stacks / Packages

This project uses the following Flutter packages:
- [http](https://pub.dev/packages/http) - A composable, Future-based library for making HTTP requests to fetch news articles and interact with APIs.
- [webview_flutter](https://pub.dev/packages/webview_flutter) - A Flutter plugin to display news articles in a native WebView.
- [beautiful_soup_dart](https://pub.dev/packages/beautiful_soup_dart) - A library to parse HTML and extract content, which is then used to summarize articles via Gemini AI.
- [google_generative_ai](https://pub.dev/packages/google_generative_ai) - A package to connect to Gemini AI, simplifying the process of sending requests and decoding AI responses.

## ✍️ Author

👤 **Stefanus Anggara**

* Email: anggara.stefanus@gmail.com
* Linkedin: https://www.linkedin.com/in/stefanus-anggara-132b6488/

Feel free to reach out with any questions or feedback! 😊
