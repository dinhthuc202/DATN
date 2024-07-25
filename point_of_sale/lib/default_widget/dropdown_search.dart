import 'dart:async';
import 'package:flutter/material.dart';

class DropdownSearch extends StatefulWidget {
  const DropdownSearch({
    super.key,
    required this.listItem,
    required this.onChange,
    this.menuHeight,
    this.labelText,
    this.fontSize,
    this.itemDefault,
    this.border,
    this.menuWidth,
    this.textEditingController,
    this.enableSearch = true,
    this.hintTextSearch,
    this.enableLazyLoading = true,
    this.readOnly = false,
    this.validator,
  });

  final TextEditingController? textEditingController;
  final bool? enableSearch;
  final bool? enableLazyLoading;
  final bool? readOnly;
  final String? itemDefault;
  final double? menuHeight;
  final double? menuWidth;
  final Future<List<Map<String, dynamic>>> Function(
      int pageNumber, String filter) listItem;
  final Function onChange;
  final String? labelText;
  final String? hintTextSearch;
  final double? fontSize;
  final OutlineInputBorder? border;
  final Function? validator;

  @override
  State<DropdownSearch> createState() => _DropdownSearchState();
}

class _DropdownSearchState extends State<DropdownSearch> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final _link = LayerLink();
  final GlobalKey _textFieldKey = GlobalKey();

  bool checkPosition() {
    final RenderBox? renderBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final dropdownPosition = renderBox.localToGlobal(Offset.zero);
      final dropdownBottom = dropdownPosition.dy + renderBox.size.height;

      final screenSize = MediaQuery.of(context).size;
      final screenCenterY = screenSize.height / 2;

      return dropdownBottom > screenCenterY;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: widget.itemDefault);
    return Material(
      child: CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _tooltipController,
          overlayChildBuilder: (BuildContext context) {
            final RenderBox renderBox =
                _textFieldKey.currentContext?.findRenderObject() as RenderBox;
            final size = renderBox.size;
            return CompositedTransformFollower(
              link: _link,
              offset: checkPosition()
                  ? Offset(0, -(widget.menuHeight ?? 350) - 50)
                  : const Offset(0, 0),
              targetAnchor: Alignment.bottomLeft,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: TapRegion(
                  onTapOutside: (tap) {
                    _tooltipController.toggle();
                  },
                  child: MenuWidget(
                    enableLazyLoading: widget.enableLazyLoading,
                    hintTextSearch: widget.hintTextSearch,
                    fontSize: widget.fontSize,
                    height: widget.menuHeight,
                    width: widget.menuWidth ?? size.width,
                    controller: _tooltipController,
                    onChange: widget.onChange,
                    textController:
                        widget.textEditingController ?? textEditingController,
                    listItem: widget.listItem,
                    enableSearch: widget.enableSearch,
                  ),
                ),
              ),
            );
          },
          child: Stack(
            children: [
              TextFormField(
                key: _textFieldKey,
                style: TextStyle(
                  fontSize: widget.fontSize ?? 14,
                ),
                controller:
                    widget.textEditingController ?? textEditingController,
                readOnly: true,
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value);
                  } else {
                    return null;
                  }
                },
                onTap: () {
                  if (widget.readOnly == true) {
                    return;
                  }
                  _tooltipController.toggle();
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                      left: 10, right: 10, top: 14, bottom: 13),
                  labelText: widget.labelText ?? "Select",
                  labelStyle: TextStyle(
                    fontSize: widget.fontSize ?? 14,
                  ),
                  border: widget.border ??
                      const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                ),
              ),
              widget.readOnly == true
                  ? Container()
                  : Container(
                      height: 40,
                      alignment: Alignment.centerRight,
                      child: const IgnorePointer(
                          child: Icon(Icons.arrow_drop_down)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuWidget extends StatefulWidget {
  const MenuWidget({
    super.key,
    this.width,
    required this.controller,
    required this.onChange,
    required this.textController,
    this.height,
    required this.listItem,
    this.fontSize,
    this.enableSearch = true,
    this.hintTextSearch,
    this.enableLazyLoading = true,
  });

  final Future<List<Map<String, dynamic>>> Function(
      int pageNumber, String filter) listItem;
  final TextEditingController textController;
  final Function onChange;
  final OverlayPortalController controller;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool? enableSearch;
  final bool? enableLazyLoading;
  final String? hintTextSearch;

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  TextEditingController controllerSearch = TextEditingController();
  ValueNotifier<String> filterNotifier = ValueNotifier<String>('');
  late List<Map<String, dynamic>> items;
  Timer? debounce;
  String filter = "";
  final controller = ScrollController();
  int page = 1;
  bool outOfData = false;

  @override
  void initState() {
    super.initState();
    items = [];
    if (widget.enableLazyLoading == true) {
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          fetch();
        }
      });
    }
    fetch();
  }

  Future fetch() async {
    var data = await widget.listItem(page, filter);
    setState(() {
      if (data.length < 50) {
        outOfData = true;
      }
      items.addAll(data);
      page++;
    });
  }

  Future search() async {
    outOfData = false;
    page = 1;
    items = [];
    await fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      width: widget.width ?? 200,
      height: widget.height ?? 350,
      child: Column(
        children: [
          widget.enableSearch == true
              ? TextField(
                  controller: controllerSearch,
                  onChanged: (value) {
                    if (debounce?.isActive ?? false) {
                      debounce!.cancel();
                    }
                    debounce = Timer(const Duration(milliseconds: 400), () {
                      filter = value;
                      search();
                      filterNotifier.value = value;
                    });
                  },
                  decoration: InputDecoration(
                    label: Text(widget.hintTextSearch ?? 'Search'),
                    labelStyle: TextStyle(fontSize: widget.fontSize ?? 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.only(
                        left: 10, top: 12, right: 10, bottom: 12),
                  ),
                )
              : Container(),
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: filterNotifier,
              builder: (context, filter, child) {
                return ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index < items.length) {
                      return ListTile(
                        title: InkWell(
                          onTap: () {
                            widget.textController.text =
                                items[index]['value'].toString();
                            widget.onChange(items[index]);
                            widget.controller.toggle();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  items[index]['value'],
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return outOfData
                          ? Container()
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
