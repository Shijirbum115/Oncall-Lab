import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/patient/all_lab_services_screen.dart';
import 'package:bugamed/ui/patient/direct_services_screen.dart';

// ============================================================================
//  CallCare AI Medical Assistant — POC chat screen (self-contained).
//
//  The screen owns the conversation; a swappable [CallCareAiService] produces
//  each bot turn. A deterministic [MockCallCareAiService] drives the flow now;
//  swap in a real implementation (Supabase Edge Function → Claude/OpenAI) later
//  without touching the UI. See `LiveCallCareAiService` at the bottom.
//
//  Conversation lifecycle (see [_BotPhase]):
//    greeting → questioning (Q1..Q4, one at a time) → recommending → done
// ============================================================================

/// Which CallCare modality a suggestion routes to (drives the Book button).
enum ServiceModality { lab, diagnostic, nursing }

/// A single recommended CallCare service shown in the recommendation card.
class ServiceSuggestion {
  const ServiceSuggestion({
    required this.name,
    required this.category,
    this.approxPriceMnt,
  });

  final String name; // Mongolian service name from the real catalog
  final String category; // Mongolian category/panel name
  final int? approxPriceMnt;
}

/// The bot's final, grounded recommendation.
class Recommendation {
  const Recommendation({
    required this.summary,
    required this.suggestions,
    required this.modality,
    required this.locationNote,
    required this.disclaimer,
    this.fastingNote,
  });

  final String summary;
  final List<ServiceSuggestion> suggestions;
  final ServiceModality modality;
  final String locationNote;
  final String disclaimer;
  final String? fastingNote;
}

/// One bot turn: text plus optional quick-reply chips and/or a recommendation.
class BotReply {
  const BotReply({
    required this.text,
    this.quickReplies = const [],
    this.recommendation,
    this.bookModality,
  });

  final String text;
  final List<String> quickReplies;
  final Recommendation? recommendation;

  /// Set when a (live) reply should show a standalone "Book" button without a
  /// full structured recommendation card. Driven by the hidden [[BOOK:..]] tag.
  final ServiceModality? bookModality;
}

/// A chat message rendered in the list.
class ChatMessage {
  ChatMessage.user(this.text)
      : isUser = true,
        quickReplies = const [],
        recommendation = null,
        bookModality = null;

  ChatMessage.bot(
    this.text, {
    this.quickReplies = const [],
    this.recommendation,
    this.bookModality,
  }) : isUser = false;

  final bool isUser;
  final String text;
  final List<String> quickReplies;
  final Recommendation? recommendation;
  final ServiceModality? bookModality;
}

/// Swap point: the only thing to replace when wiring a real LLM.
abstract class CallCareAiService {
  /// First turn shown when the screen opens (greeting + Q1).
  BotReply greeting();

  /// Produce the next bot turn given the latest user input and full history.
  Future<BotReply> respond({
    required String userInput,
    required List<ChatMessage> history,
  });
}

// ============================================================================
//  Screen
// ============================================================================

class CallCareAiBotScreen extends StatefulWidget {
  const CallCareAiBotScreen({super.key, this.service});

  /// Inject a real service in production; defaults to the mock for the POC.
  final CallCareAiService? service;

  @override
  State<CallCareAiBotScreen> createState() => _CallCareAiBotScreenState();
}

class _CallCareAiBotScreenState extends State<CallCareAiBotScreen> {
  late final CallCareAiService _service;
  final _messages = <ChatMessage>[];
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _botTyping = false;

  @override
  void initState() {
    super.initState();
    // Defaults to the live LLM-backed service (Supabase Edge Function).
    // Pass `service: MockCallCareAiService()` to run the offline scripted flow.
    _service = widget.service ?? LiveCallCareAiService();
    // STATE: greeting — the first bot turn appears immediately.
    final intro = _service.greeting();
    _messages.add(ChatMessage.bot(
      intro.text,
      quickReplies: intro.quickReplies,
      recommendation: intro.recommendation,
      bookModality: intro.bookModality,
    ));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleUserInput(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || _botTyping) return;

    setState(() {
      _messages.add(ChatMessage.user(text));
      _inputController.clear();
      _botTyping = true; // shows the typing indicator
    });
    _scrollToBottom();

    // STATE transition: questioning/recommending — the service decides the
    // next turn (and, internally, whether we've reached a recommendation).
    final reply = await _service.respond(
      userInput: text,
      history: List.unmodifiable(_messages),
    );

    if (!mounted) return;
    setState(() {
      _botTyping = false;
      _messages.add(ChatMessage.bot(
        reply.text,
        quickReplies: reply.quickReplies,
        recommendation: reply.recommendation,
        bookModality: reply.bookModality,
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _onBook(ServiceModality modality) {
    final screen = modality == ServiceModality.lab
        ? const AllLabServicesScreen()
        : const DirectServicesScreen();
    Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_outlined,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CallCare AI туслах',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                Text('Тохирох үйлчилгээг олж өгнө',
                    style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: _messages.length + (_botTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_botTyping && index == _messages.length) {
                  return const _TypingBubble();
                }
                final message = _messages[index];
                final isLast = index == _messages.length - 1;
                return _MessageBubble(
                  message: message,
                  // Quick replies are only tappable on the latest bot turn.
                  showQuickReplies: isLast && !message.isUser && !_botTyping,
                  onQuickReply: _handleUserInput,
                  onBook: _onBook,
                );
              },
            ),
          ),
          _InputBar(
            controller: _inputController,
            enabled: !_botTyping,
            onSend: _handleUserInput,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
//  Mock service — deterministic flow + grounded recommendation + guardrail.
//  Replace with a real LLM-backed service (see LiveCallCareAiService).
// ============================================================================

class MockCallCareAiService implements CallCareAiService {
  // How many assessment questions have been answered (0..4).
  int _step = 0;
  final Map<int, String> _answers = {};

  // --- Question definitions (asked one at a time) ---
  static const _q1 =
      'Эхлээд танаас хэдэн зүйл асууя. Та юунд зориулж үйлчилгээ авах гэж байна вэ?';
  static const _q1Options = [
    'Шинж тэмдэгтэй',
    'Урьдчилан сэргийлэх',
    'Эмчийн заавартай',
    'Сувилахуй',
  ];

  static const _q2 = 'Гол зовуурь чинь аль эрхтэн системтэй холбоотой вэ?';
  static const _q2Options = [
    'Зүрх судас',
    'Элэг/ходоод',
    'Бөөр/шээс',
    'Чихрийн шижин',
    'Бамбай/даавар',
    'Ерөнхий байдал',
    'Мэдэхгүй',
  ];

  static const _q3 =
      'Танд лабораторийн шинжилгээ хэрэгтэй юу, эсвэл дүрс оношлогоо (ЭХО, ЭКГ, рентген) уу?';
  static const _q3Options = [
    'Лаб шинжилгээ',
    'Дүрс оношлогоо',
    'Аль аль нь',
    'Мэдэхгүй',
  ];

  static const _q4 = 'Үйлчилгээг хаана авах нь танд тохиромжтой вэ?';
  static const _q4Options = ['Гэрээр', 'Лаборатори дээр'];

  static const _disclaimer =
      'Анхааруулга: Энэ бол хиймэл оюуны санал болгол бөгөөд эмчийн эцсийн '
      'оношлогоо биш юм. Эцсийн шийдвэрийг эмчтэйгээ зөвлөлдөж гаргана уу.';

  @override
  BotReply greeting() {
    _step = 0;
    return const BotReply(
      text:
          'Сайн байна уу! 👋 Би CallCare-ийн хиймэл оюун туслах. Танд хамгийн '
          'тохирох шинжилгээ, эмчийн үйлчилгээг сонгоход тусална.\n\n$_q1',
      quickReplies: _q1Options,
    );
  }

  @override
  Future<BotReply> respond({
    required String userInput,
    required List<ChatMessage> history,
  }) async {
    // Simulate network latency so the UI behaves like the real thing.
    await Future.delayed(const Duration(milliseconds: 650));

    // GUARDRAIL: in production the system prompt enforces this; here we
    // emulate it so off-topic / prompt-injection inputs are handled too.
    if (_isOutOfScope(userInput)) {
      return BotReply(
        text:
            'Уучлаарай, би зөвхөн таны нөхцөл байдалд тохирох CallCare үйлчилгээг '
            'сонгоход туслах зорилготой. Энэ хүсэлтэд туслаж чадахгүй. Хэрэв '
            'шинжилгээ, эмчийн үзлэг сонгох талаар асуух зүйл байвал баяртайгаар '
            'туслая.',
        // Re-offer the current question's options so the flow can continue.
        quickReplies: _optionsForStep(_step),
      );
    }

    // EMERGENCY safeguard.
    if (_looksLikeEmergency(userInput)) {
      return const BotReply(
        text:
            '⚠️ Таны бичсэн шинж тэмдэг яаралтай тусламж шаардаж болзошгүй байна. '
            'Гэрийн үйлчилгээ хүлээлгүй яаралтай 103 утсаар холбогдоно уу.',
      );
    }

    // ASSESSMENT: record the answer for the current question and advance.
    _answers[_step] = userInput;
    _step++;

    switch (_step) {
      case 1:
        return const BotReply(text: _q2, quickReplies: _q2Options);
      case 2:
        return const BotReply(text: _q3, quickReplies: _q3Options);
      case 3:
        return const BotReply(text: _q4, quickReplies: _q4Options);
      default:
        // RECOMMENDATION: enough answers collected → build a grounded result.
        return _buildRecommendation();
    }
  }

  List<String> _optionsForStep(int step) {
    switch (step) {
      case 0:
        return _q1Options;
      case 1:
        return _q2Options;
      case 2:
        return _q3Options;
      case 3:
        return _q4Options;
      default:
        return const [];
    }
  }

  /// Maps the collected answers to real CallCare panels/services.
  BotReply _buildRecommendation() {
    final goal = _answers[0] ?? '';
    final system = _answers[1] ?? '';
    final type = _answers[2] ?? '';
    final location = _answers[3] ?? '';

    final homeText = location.contains('Гэр')
        ? 'Үйлчилгээг гэрээр (гэрийн дээж авалт) захиалах боломжтой.'
        : 'Үйлчилгээг лаборатори дээр очиж авах боломжтой.';

    // --- Nursing branch ---
    if (goal.contains('Сувилахуй')) {
      return BotReply(
        text: 'Таны сонголтод үндэслэн дараах үйлчилгээг санал болгож байна:',
        recommendation: Recommendation(
          summary: 'Танд гэрээр хийгдэх сувилахуйн үйлчилгээ тохирно.',
          modality: ServiceModality.nursing,
          locationNote: 'Сувилахуйн үйлчилгээг ихэвчлэн гэрээр үзүүлдэг.',
          disclaimer: _disclaimer,
          suggestions: const [
            ServiceSuggestion(
                name: 'Тариа хийх / ариутгал', category: 'Сувилахуйн үйлчилгээ'),
          ],
        ),
      );
    }

    // --- Diagnostic (imaging) branch ---
    final wantsImaging = type.contains('Дүрс');
    final cardiac = system.contains('Зүрх');
    if (wantsImaging) {
      final suggestions = cardiac
          ? const [
              ServiceSuggestion(
                  name: 'ЭКГ (Зүрхний бичлэг)',
                  category: 'Дүрс оношлогоо',
                  approxPriceMnt: 15000),
              ServiceSuggestion(
                  name: 'Зүрхний доплерт эхо',
                  category: 'Дүрс оношлогоо',
                  approxPriceMnt: 80000),
            ]
          : const [
              ServiceSuggestion(
                  name: 'ЭХО оношилгоо',
                  category: 'Дүрс оношлогоо',
                  approxPriceMnt: 50000),
            ];
      return BotReply(
        text: 'Таны сонголтод үндэслэн дараах оношлогоог санал болгож байна:',
        recommendation: Recommendation(
          summary: cardiac
              ? 'Зүрх судасны зовуурьт зориулж дүрс оношлогоо тохирно.'
              : 'Танд эмчийн хийх дүрс оношлогоо тохирно.',
          modality: ServiceModality.diagnostic,
          locationNote: homeText,
          disclaimer: _disclaimer,
          suggestions: suggestions,
        ),
      );
    }

    // --- Lab branch: map the body system to a real panel ---
    late final String summary;
    late final List<ServiceSuggestion> suggestions;
    var needsFasting = false;

    if (goal.contains('Урьдчилан') ||
        system.contains('Ерөнхий') ||
        system.contains('Мэдэхгүй')) {
      summary = 'Ерөнхий эрүүл мэндийн урьдчилан сэргийлэх багц тохирно.';
      suggestions = const [
        ServiceSuggestion(
            name: 'Цусны дэлгэрэнгүй шинжилгээ (CBC)',
            category: 'Цусны шинжилгээ',
            approxPriceMnt: 35000),
        ServiceSuggestion(
            name: 'Сахар', category: 'Диабетийн сорилууд', approxPriceMnt: 6000),
        ServiceSuggestion(
            name: 'Холестерол / Липидийн профайл',
            category: 'Зүрх судасны сорилууд',
            approxPriceMnt: 5000),
      ];
      needsFasting = true;
    } else if (system.contains('Зүрх')) {
      summary = 'Зүрх судасны эрсдэлийг үнэлэх лабораторийн багц тохирно.';
      suggestions = const [
        ServiceSuggestion(
            name: 'Холестерол',
            category: 'Зүрх судасны сорилууд',
            approxPriceMnt: 5000),
        ServiceSuggestion(
            name: 'Триглицерид',
            category: 'Зүрх судасны сорилууд',
            approxPriceMnt: 5000),
      ];
      needsFasting = true;
    } else if (system.contains('Элэг')) {
      summary = 'Элэг, цөсний үйл ажиллагааг үнэлэх шинжилгээ тохирно.';
      suggestions = const [
        ServiceSuggestion(
            name: 'ГОТ / ГПТ (элэгний фермент)',
            category: 'Элэг цөсний сорилууд',
            approxPriceMnt: 8000),
        ServiceSuggestion(
            name: 'Билирубин (нийт)',
            category: 'Элэг цөсний сорилууд',
            approxPriceMnt: 5000),
      ];
      needsFasting = true;
    } else if (system.contains('Бөөр')) {
      summary = 'Бөөрний үйл ажиллагааг үнэлэх шинжилгээ тохирно.';
      suggestions = const [
        ServiceSuggestion(
            name: 'Креатинин',
            category: 'Бөөрний сорилууд',
            approxPriceMnt: 8000),
        ServiceSuggestion(
            name: 'Шээсний дэлгэрэнгүй шинжилгээ',
            category: 'Бөөрний сорилууд',
            approxPriceMnt: 20000),
      ];
    } else if (system.contains('Чихрийн')) {
      summary = 'Чихрийн шижинг үнэлэх шинжилгээ тохирно.';
      suggestions = const [
        ServiceSuggestion(
            name: 'Сахар', category: 'Диабетийн сорилууд', approxPriceMnt: 6000),
        ServiceSuggestion(
            name: 'HbA1c (3 сарын дундаж сахар)',
            category: 'Диабетийн сорилууд',
            approxPriceMnt: 18000),
      ];
      needsFasting = true;
    } else {
      // Бамбай/даавар + anything else
      summary = 'Бамбай булчирхайн дааврын шинжилгээ тохирно.';
      suggestions = const [
        ServiceSuggestion(
            name: 'Бамбайн даавар (TSH г.м.)', category: 'Бамбайн дааврууд'),
      ];
    }

    return BotReply(
      text: 'Таны хариултад үндэслэн дараах шинжилгээг санал болгож байна:',
      recommendation: Recommendation(
        summary: summary,
        modality: ServiceModality.lab,
        locationNote: homeText,
        disclaimer: _disclaimer,
        fastingNote: needsFasting
            ? 'Энэ шинжилгээнд өмнө нь 8–12 цаг өлсгөлөнд (хоол идэхгүй) өгөх '
                'шаардлагатай.'
            : null,
        suggestions: suggestions,
      ),
    );
  }

  // Heuristic out-of-scope / prompt-injection detector (POC only).
  bool _isOutOfScope(String input) {
    final t = input.toLowerCase();
    const triggers = [
      'system prompt',
      'systemprompt',
      'ignore previous',
      'ignore all',
      'developer mode',
      'act as',
      'jailbreak',
      'prompt',
      'lgbt',
      'gay',
      'politic',
      'улс төр',
      'шашин',
      'код бич',
      'write code',
      'python',
      'joke',
      'онигоо',
    ];
    return triggers.any(t.contains);
  }

  bool _looksLikeEmergency(String input) {
    final t = input.toLowerCase();
    const redFlags = [
      'цээж',
      'амьсгал',
      'амьсгаа',
      'их цус',
      'цус алдаж',
      'ухаан алдаж',
      'тэнэглэж',
      'саажилт',
    ];
    return redFlags.any(t.contains);
  }
}

// ============================================================================
//  Live service stub — wire this to a Supabase Edge Function later.
//
//  The edge function should call the LLM with `callCareSystemPrompt`
//  (see callcare_ai_prompt.dart) as the system prompt and the conversation
//  history as messages, then return the reply text. Example (Anthropic):
//
//    POST https://api.anthropic.com/v1/messages
//    headers: x-api-key, anthropic-version: 2023-06-01
//    body: {
//      "model": "claude-haiku-4-5",
//      "max_tokens": 600,
//      "system": <callCareSystemPrompt>,
//      "messages": [{ "role": "user"|"assistant", "content": "..." }, ...]
//    }
//
//  Keep the API key server-side (in the edge function), never in the app.
// ============================================================================

class LiveCallCareAiService implements CallCareAiService {
  static const _bookTag = r'\[\[BOOK:(lab|diagnostic|nursing)\]\]';

  // Reuse the scripted greeting + Q1 chips so the first turn is instant (no
  // round-trip); the LLM takes over from the user's first answer onward.
  @override
  BotReply greeting() => MockCallCareAiService().greeting();

  @override
  Future<BotReply> respond({
    required String userInput,
    required List<ChatMessage> history,
  }) async {
    // The Anthropic Messages API expects {role, content}; the edge function
    // drops any leading assistant turns (e.g. the local greeting).
    final messages = history
        .map((m) => {
              'role': m.isUser ? 'user' : 'assistant',
              'content': m.text,
            })
        .toList();

    try {
      final res = await Supabase.instance.client.functions.invoke(
        'callcare-ai-chat',
        body: {'messages': messages},
      );
      final data = res.data;
      final reply = (data is Map && data['reply'] is String)
          ? (data['reply'] as String).trim()
          : '';
      if (reply.isEmpty) {
        return const BotReply(
          text:
              'Уучлаарай, хариу авахад алдаа гарлаа. Та дахин оролдоно уу.',
        );
      }
      return _parse(reply);
    } catch (_) {
      return const BotReply(
        text:
            'Уучлаарай, AI туслахтай холбогдоход алдаа гарлаа. Сүлжээгээ '
            'шалгаад дахин оролдоно уу.',
      );
    }
  }

  /// Strips the hidden booking tag and maps it to a [ServiceModality].
  BotReply _parse(String reply) {
    final re = RegExp(_bookTag);
    final match = re.firstMatch(reply);
    if (match == null) return BotReply(text: reply);

    final text = reply.replaceAll(re, '').trim();
    final modality = switch (match.group(1)) {
      'diagnostic' => ServiceModality.diagnostic,
      'nursing' => ServiceModality.nursing,
      _ => ServiceModality.lab,
    };
    return BotReply(text: text, bookModality: modality);
  }
}

// ============================================================================
//  UI widgets
// ============================================================================

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.showQuickReplies,
    required this.onQuickReply,
    required this.onBook,
  });

  final ChatMessage message;
  final bool showQuickReplies;
  final ValueChanged<String> onQuickReply;
  final ValueChanged<ServiceModality> onBook;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: isUser ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppRadius.md),
              topRight: const Radius.circular(AppRadius.md),
              bottomLeft: Radius.circular(isUser ? AppRadius.md : 4),
              bottomRight: Radius.circular(isUser ? 4 : AppRadius.md),
            ),
            border: isUser
                ? null
                : Border.all(color: AppColors.grey.withValues(alpha: 0.15)),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: isUser ? Colors.white : AppColors.black,
            ),
          ),
        ),
        if (message.recommendation != null)
          _RecommendationCard(
            recommendation: message.recommendation!,
            onBook: onBook,
          ),
        // Live replies carry just a modality (via the [[BOOK:..]] tag) → show a
        // standalone book button under the text bubble.
        if (message.recommendation == null && message.bookModality != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: 220,
              child: AppButton(
                label: 'Үйлчилгээ захиалах',
                icon: Icons.arrow_forward,
                onPressed: () => onBook(message.bookModality!),
              ),
            ),
          ),
        if (showQuickReplies && message.quickReplies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in message.quickReplies)
                  _QuickReplyChip(label: option, onTap: () => onQuickReply(option)),
              ],
            ),
          ),
      ],
    );
  }
}

class _QuickReplyChip extends StatelessWidget {
  const _QuickReplyChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation, required this.onBook});

  final Recommendation recommendation;
  final ValueChanged<ServiceModality> onBook;

  @override
  Widget build(BuildContext context) {
    final r = recommendation;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.recommend_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(r.summary,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final s in r.suggestions) _SuggestionRow(suggestion: s),
          const SizedBox(height: 4),
          Text(r.locationNote,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
          if (r.fastingNote != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: AppColors.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(r.fastingNote!,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.black, height: 1.4)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(r.disclaimer,
              style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                  height: 1.4)),
          const SizedBox(height: 12),
          AppButton(
            label: 'Үйлчилгээ захиалах',
            icon: Icons.arrow_forward,
            onPressed: () => onBook(r.modality),
          ),
        ],
      ),
    );
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({required this.suggestion});

  final ServiceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.science_outlined,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(suggestion.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black)),
                Text(suggestion.category,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (suggestion.approxPriceMnt != null)
            Text('~${suggestion.approxPriceMnt}₮',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.15)),
        ),
        child: const Text('• • •',
            style: TextStyle(color: AppColors.grey, fontSize: 14)),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.enabled,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 8, 12, 8 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0x11000000))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              textInputAction: TextInputAction.send,
              onSubmitted: onSend,
              decoration: InputDecoration(
                hintText: 'Мессеж бичих...',
                filled: true,
                fillColor: AppColors.grey.withValues(alpha: 0.08),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: enabled ? () => onSend(controller.text) : null,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
