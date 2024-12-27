library gpt_ai;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageModel {
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.message,
    required this.timestamp,
  });
}

class GptChatUI extends StatefulWidget {
  final List<MessageModel> sentPrompts;
  final List<String> received;
  final List<String> recentHitorySearches;
  final TextEditingController messageController;
  final ThemeController themeController;
  final bool premiumPlanStatus;
  final bool recentHistoryStatus;

  const GptChatUI({
    super.key,
    required this.sentPrompts,
    required this.received,
    required this.messageController,
    required this.themeController,
    required this.premiumPlanStatus,
    required this.recentHistoryStatus,
    required this.recentHitorySearches,
  });

  @override
  State<GptChatUI> createState() => _GptChatUIState();
}

class _GptChatUIState extends State<GptChatUI> {
  @override
  void dispose() {
    widget.messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (widget.messageController.text.trim().isNotEmpty) {
      setState(() {
        widget.sentPrompts.add(MessageModel(
          message: widget.messageController.text,
          timestamp: DateTime.now(),
        ));
        widget.messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final hasMessages = widget.sentPrompts.isNotEmpty;

    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.themeController.isDarkMode.value
            ? const Color(0xff1C202B)
            : Colors.white,
        body: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Visibility(
              visible: !hasMessages,
              child: Column(
                children: [
                  _buildPremiumCard(),
                  SizedBox(height: screenHeight * 0.03),
                  _buildFeatureCards(),
                  SizedBox(height: screenHeight * 0.02),
                  _buildHistoryHeader(),
                  SizedBox(height: screenHeight * 0.03),
                  _buildHistoryItem(
                    icon: Icons.message_outlined,
                    text: widget.recentHitorySearches.first.toString(),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildHistoryItem(
                    icon: Icons.mic_outlined,
                    text: widget.recentHitorySearches.last.toString(),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: hasMessages,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: screenHeight * 0.03,
                        fontWeight: FontWeight.bold,
                        color: widget.themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      'Ask me anything...',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: widget.themeController.isDarkMode.value
                            ? const Color(0xff6F737E)
                            : const Color(0xff666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: hasMessages,
                replacement: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No messages yet',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: widget.themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        'Start a conversation by sending a message',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: widget.themeController.isDarkMode.value
                              ? const Color(0xff6F737E)
                              : const Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                ),
                child: ListView.builder(
                  itemCount: widget.sentPrompts.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color:
                                        widget.themeController.isDarkMode.value
                                            ? Colors.white
                                            : Colors.black,
                                    size: 20,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: screenWidth * 0.4,
                                  decoration: BoxDecoration(
                                    color:
                                        widget.themeController.isDarkMode.value
                                            ? const Color(0xff7067E4)
                                            : Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.sentPrompts[index].message,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.account_circle_outlined,
                                    color:
                                        widget.themeController.isDarkMode.value
                                            ? Colors.white
                                            : Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _buildChatResponse(),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    );
                  },
                ),
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Visibility(
      visible: widget.premiumPlanStatus,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff6A62CC),
                Color(0xffA49DEB),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Premium Plan',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            color: const Color(0xffF2F2F3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Unlock your ai chatbot &\nget all premium features',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffC0BFE7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildUpgradeButton(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/purple_robot.png',
                  fit: BoxFit.contain,
                  width: context.width * 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Upgrade plan',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.bold,
                color: const Color(0xff121212),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFeatureCard(
            title: 'Writing articles',
            description: 'genrationg articles text\nis easier with chatbot.ai',
          ),
          _buildFeatureCard(
            title: 'Image & art',
            description:
                'a text-to-image AI\nwhere your imagination\n is the only limit',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() => Container(
          height: screenHeight * 0.22,
          width: screenWidth * 0.43,
          decoration: BoxDecoration(
            color: widget.themeController.isDarkMode.value
                ? const Color(0xff252B39)
                : const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenWidth * 0.12,
                  width: screenWidth * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: widget.themeController.isDarkMode.value
                        ? const Color(0xff7067E4)
                        : Colors.black,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w500,
                      color: widget.themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w400,
                      color: widget.themeController.isDarkMode.value
                          ? const Color(0xff6F737E)
                          : const Color(0xff666666),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    size: screenWidth * 0.06,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildHistoryHeader() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Visibility(
      visible: widget.recentHistoryStatus,
      child: Obx(() => Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent history',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w500,
                    color: widget.themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Text(
                  'See all',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.normal,
                    color: widget.themeController.isDarkMode.value
                        ? const Color(0xff6E7176)
                        : const Color(0xff666666),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String text,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Visibility(
      visible: widget.recentHistoryStatus,
      child: Obx(() => Container(
            height: screenHeight * 0.08,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: widget.themeController.isDarkMode.value
                  ? const Color(0xff252B39)
                  : const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.04),
                Container(
                  height: screenWidth * 0.12,
                  width: screenWidth * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(46.0),
                    color: widget.themeController.isDarkMode.value
                        ? const Color(0xff464A56)
                        : const Color(0xffE0E0E0),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: widget.themeController.isDarkMode.value
                          ? const Color(0xffC2C2CA)
                          : Colors.black,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.normal,
                      color: widget.themeController.isDarkMode.value
                          ? const Color(0xff9BA0A6)
                          : const Color(0xff666666),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildThreeDots(),
                SizedBox(width: screenWidth * 0.04),
              ],
            ),
          )),
    );
  }

  Widget _buildThreeDots() {
    return Obx(() => Column(
          children: [
            const SizedBox(height: 20),
            ...List.generate(
                3,
                (index) => [
                      Container(
                        height: 3,
                        width: 3,
                        decoration: BoxDecoration(
                          color: widget.themeController.isDarkMode.value
                              ? const Color(0xffD2D6E1)
                              : const Color(0xff666666),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ]).expand((x) => x),
          ],
        ));
  }

  Widget _buildInputBar() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() => Container(
          height: screenHeight * 0.1,
          width: screenWidth,
          decoration: BoxDecoration(
            color: widget.themeController.isDarkMode.value
                ? const Color(0xff252B39)
                : const Color(0xffF5F5F5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.messageController,
                    style: TextStyle(
                      color: widget.themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                      fontSize: screenWidth * 0.04,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter a prompt here...',
                      hintStyle: TextStyle(
                        color: widget.themeController.isDarkMode.value
                            ? const Color(0xff6F737E)
                            : const Color(0xff666666),
                        fontSize: screenWidth * 0.04,
                      ),
                      suffixIcon: Icon(
                        Icons.mic_none_rounded,
                        color: widget.themeController.isDarkMode.value
                            ? const Color(0xff6F737E)
                            : const Color(0xff666666),
                        size: screenWidth * 0.06,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(screenWidth * 0.03)),
                        borderSide: BorderSide(
                          color: widget.themeController.isDarkMode.value
                              ? const Color(0xff6F737E)
                              : const Color(0xff666666),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(screenWidth * 0.03)),
                        borderSide: BorderSide(
                          color: widget.themeController.isDarkMode.value
                              ? const Color(0xff6F737E)
                              : const Color(0xff666666),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(screenWidth * 0.03)),
                        borderSide: BorderSide(
                          color: widget.themeController.isDarkMode.value
                              ? const Color(0xff6F737E)
                              : const Color(0xff666666),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Container(
                  height: screenWidth * 0.13,
                  width: screenWidth * 0.13,
                  decoration: BoxDecoration(
                    color: widget.themeController.isDarkMode.value
                        ? const Color(0xff7067E4)
                        : Colors.black,
                    borderRadius:
                        BorderRadius.all(Radius.circular(screenWidth * 0.03)),
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildChatResponse() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenWidth * 0.03,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff252B39),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.received.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.thumb_up_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.thumb_down_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Controller:
class ThemeController extends GetxController {
  final RxBool isDarkMode = true.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
