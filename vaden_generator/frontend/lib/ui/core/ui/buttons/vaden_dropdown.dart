import 'package:flutter/material.dart';
import '../../themes/colors.dart';

class VadenDropdown extends StatefulWidget {
  /// Título do dropdown (opcional)
  final String? title;

  /// Texto de placeholder quando nenhuma opção estiver selecionada
  final String placeholder;

  /// Lista de opções disponíveis no dropdown
  final List<String> options;

  /// Opção atualmente selecionada
  final String? selectedOption;

  /// Callback chamado quando uma opção é selecionada
  final Function(String)? onOptionSelected;

  /// Se o dropdown está habilitado ou não
  final bool isEnabled;

  const VadenDropdown({
    super.key,
    this.title,
    this.placeholder = 'Selecione uma opção',
    required this.options,
    this.selectedOption,
    this.onOptionSelected,
    this.isEnabled = true,
  });

  @override
  State<VadenDropdown> createState() => _VadenDropdownState();
}

class _VadenDropdownState extends State<VadenDropdown> {
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _dropdownKey = GlobalKey();

  // Armazenar a opção selecionada internamente
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // Inicializa com a opção selecionada do widget
    _selectedOption = widget.selectedOption;
  }

  @override
  void didUpdateWidget(VadenDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza a seleção interna quando a propriedade muda externamente
    if (widget.selectedOption != oldWidget.selectedOption) {
      _selectedOption = widget.selectedOption;

      // Recria o overlay se estiver aberto para refletir a nova seleção
      if (_isDropdownOpen) {
        _removeOverlay();
        // Use a post-frame callback to show the overlay after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showOverlay();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.isEnabled) return;

    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });

    if (_isDropdownOpen) {
      // Use a post-frame callback to show the overlay after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showOverlay();
        }
      });
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _selectOption(String option) {
    // Atualiza a seleção internamente
    setState(() {
      _selectedOption = option;
    });

    // Notifica o pai sobre a mudança
    if (widget.onOptionSelected != null) {
      widget.onOptionSelected!(option);
    }

    // Update the overlay entry to reflect the new selection without closing/reopening
    if (_isDropdownOpen && _overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  // Widget para criar a bolinha de seleção com anel e degradê
  Widget _buildSelectionIndicator() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anel externo com degradê
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  VadenColors.gradientStart,
                  VadenColors.gradientEnd,
                ],
              ),
            ),
          ),
          // Círculo preto interno para criar o efeito de anel
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          // Círculo interno com degradê
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
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
    );
  }

  OverlayEntry _createOverlayEntry() {
    // Obtém o RenderBox do dropdown para calcular posicionamento
    final RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        // Fecha o dropdown quando clicar fora dele
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Close the dropdown when tapping outside
          setState(() {
            _isDropdownOpen = false;
          });
          _removeOverlay();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: GestureDetector(
                  // Prevent taps on the dropdown menu from closing it
                  onTap: () {}, // Empty callback to prevent propagation
                  child: Material(
                    elevation: 8,
                    color: Colors.transparent,
                    shadowColor: Colors.black26,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: VadenColors.whiteColor,
                          width: 1,
                        ),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: widget.options.length,
                        itemBuilder: (context, index) {
                          final option = widget.options[index];
                          final isSelected = option == _selectedOption;

                          return InkWell(
                            onTap: () => _selectOption(option),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        color: VadenColors.whiteColor,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  isSelected
                                      ? _buildSelectionIndicator()
                                      : Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: VadenColors.whiteColor,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título opcional
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              widget.title!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),

        // Cabeçalho do dropdown
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _dropdownKey,
            onTap: _toggleDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.isEnabled ? VadenColors.whiteColor : VadenColors.txtSupport2,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedOption ?? widget.placeholder,
                      style: TextStyle(
                        color:
                            widget.isEnabled ? VadenColors.whiteColor : VadenColors.disabledColor,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                        _isDropdownOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: widget.isEnabled ? VadenColors.whiteColor : VadenColors.txtSupport2,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
