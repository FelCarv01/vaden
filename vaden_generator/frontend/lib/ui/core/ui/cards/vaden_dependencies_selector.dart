import 'package:flutter/material.dart';
import '../../themes/colors.dart';

enum Language {
  devTools,
}

class VadenDependenciesSelector extends StatefulWidget {
  final Language initialLanguage;
  final Function(Language)? onLanguageChanged;

  const VadenDependenciesSelector({
    super.key,
    this.initialLanguage = Language.devTools,
    this.onLanguageChanged,
  });

  @override
  State<VadenDependenciesSelector> createState() => _VadenDependenciesSelectorState();
}

class _VadenDependenciesSelectorState extends State<VadenDependenciesSelector> {
  late Language _selectedLanguage;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  void _changeLanguage(Language language) {
    setState(() {
      _selectedLanguage = language;
    });

    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!(language);
    }
  }

  String _getLanguageText(Language language) {
    switch (language) {
      case Language.devTools:
        return 'Dev Tools';
    }
  }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) {
        if (_isOpen) {
          setState(() {
            _isOpen = false;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: VadenColors.backgroundColor2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: VadenColors.stkSupport2,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _getLanguageText(_selectedLanguage),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: VadenColors.whiteColor,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: VadenColors.backgroundColor2,
                      border: Border.all(
                        color: VadenColors.stkSupport2,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _isOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: VadenColors.stkSupport2,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: VadenColors.backgroundColor2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: VadenColors.stkSupport2,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Language.values.map((language) {
                  final isSelected = _selectedLanguage == language;
                  return InkWell(
                    onTap: () => _changeLanguage(language),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getLanguageText(language),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isSelected
                                        ? VadenColors.txtSecondary
                                        : VadenColors.txtSupport3,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    VadenColors.gradientStart,
                                    VadenColors.gradientEnd,
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
