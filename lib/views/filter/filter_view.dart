import 'package:fitinbox/service/filter/get_filters.dart';
import 'package:fitinbox/service/filter/get_templates.dart';
import 'package:fitinbox/service/filter/modify_filters.dart';
import 'package:fitinbox/widgets/multi_line_text_field.dart';
import 'package:fitinbox/widgets/one_line_text_field.dart';
import 'package:fitinbox/widgets/secondary_button.dart';
import 'package:fitinbox/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  int templateSelected = 0;
  List<Map<String, dynamic>> templates = [];

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController contentsEditingController = TextEditingController();

  bool isSending = false;

  int currentIndex = 0;

  void getFilterData() {
    getFilters().then((value) {
      if (value["result"]) {
        setState(() {
          nameEditingController.text = value["data"]["name"];
          contentsEditingController.text = value["data"]["contents"];
        });
      }
    });

    getTemplates().then((value) {
      if (value["result"]) {
        setState(() {
          templates = value["data"]["templates"];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getFilterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              border: Border(),
              largeTitle: Text("Filter Setting"),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                children: [
                  Row(
                    children: [
                      indexButton(
                        title: 'My Filter',
                        onPressed: () {
                          setState(() {
                            currentIndex = 0;
                          });
                        },
                        active: currentIndex == 0,
                      ),
                      const SizedBox(width: 4),
                      indexButton(
                        title: 'Templates',
                        onPressed: () {
                          setState(() {
                            currentIndex = 1;
                          });
                        },
                        active: currentIndex == 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  currentIndex == 0
                      ? ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const Text(
                              "Name of filter",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            OneLineTextField(textEditingController: nameEditingController, onChanged: (_) {}, hintText: "소프트웨어 엔지니어"),
                            const SizedBox(height: 16),
                            const Text(
                              "Contents",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            MultiLineTextField(textEditingController: contentsEditingController, onChanged: (_) {}, hintText: "Primary focus on digital marketing, social media strategies, and brand development."),
                            const SizedBox(height: 16),
                            SecondaryButton(
                              color: Colors.black87,
                              title: isSending ? "Loading" : "Update",
                              disabled: isSending,
                              onPressed: () async {
                                setState(() {
                                  isSending = true;
                                });

                                try {
                                  final modifyFiltersResult = await modifyFilters(name: nameEditingController.text, contents: contentsEditingController.text.split("\n"));

                                  if (modifyFiltersResult["result"]) {
                                    if (context.mounted) showBooleanToast(context, granted: true, message: "변경되었습니다!");

                                    getFilterData();
                                  } else {
                                    if (context.mounted) showBooleanToast(context, granted: false, message: modifyFiltersResult["message"]);
                                  }
                                } catch (e) {
                                  if (context.mounted) showBooleanToast(context, granted: false, message: e.toString());
                                }

                                setState(() {
                                  isSending = false;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const Text(
                              "Filter Templates",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: templateSelected == index ? Colors.black : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: CupertinoButton(
                                    onPressed: () {
                                      setState(() {
                                        templateSelected = index;
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          templates[index]["name"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: templates[index]["contents"].length,
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(height: 4);
                                          },
                                          itemBuilder: (context, filterIndex) {
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.black,
                                                    radius: 3,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    templates[index]["contents"][filterIndex],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) {
                                return const SizedBox(height: 16);
                              },
                              itemCount: templates.length,
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                ],
              ),
              currentIndex == 1
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      color: Colors.white,
                      child: SecondaryButton(
                        color: Colors.black87,
                        title: isSending ? "Loading" : "Apply",
                        disabled: isSending,
                        onPressed: () async {
                          setState(() {
                            isSending = true;
                          });

                          try {
                            final modifyFiltersResult = await modifyFilters(name: templates[templateSelected]["name"], contents: templates[templateSelected]["contents"]);

                            if (modifyFiltersResult["result"]) {
                              if (context.mounted) showBooleanToast(context, granted: true, message: "변경되었습니다!");

                              getFilterData();
                            } else {
                              if (context.mounted) showBooleanToast(context, granted: false, message: modifyFiltersResult["message"]);
                            }
                          } catch (e) {
                            if (context.mounted) showBooleanToast(context, granted: false, message: e.toString());
                          }

                          setState(() {
                            isSending = false;
                          });
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget indexButton({required String title, required void Function() onPressed, required bool active}) {
  return Expanded(
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.black87 : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
