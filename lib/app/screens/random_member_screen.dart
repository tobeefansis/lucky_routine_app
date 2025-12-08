import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../models/family_member.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_family_state.dart';

class RandomMemberScreen extends StatefulWidget {
  const RandomMemberScreen({required this.members, super.key});

  final List<FamilyMember> members;

  @override
  State<RandomMemberScreen> createState() => _RandomMemberScreenState();
}

class _RandomMemberScreenState extends State<RandomMemberScreen> {
  late final StreamController<int> _selectedController;
  final Random _random = Random();

  int? _selectedIndex;
  int? _pendingIndex;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _selectedController = StreamController<int>.broadcast();
  }

  @override
  void didUpdateWidget(covariant RandomMemberScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasNoMembers = widget.members.isEmpty;
    if (_selectedIndex != null &&
        (_selectedIndex! >= widget.members.length || hasNoMembers)) {
      setState(() => _selectedIndex = null);
    }
    if (_pendingIndex != null &&
        (_pendingIndex! >= widget.members.length || hasNoMembers)) {
      setState(() => _pendingIndex = null);
    }
  }

  @override
  void dispose() {
    _selectedController.close();
    super.dispose();
  }

  void _spinWheel() {
    if (widget.members.isEmpty || _isSpinning) return;
    final index = _random.nextInt(widget.members.length);

    setState(() {
      _isSpinning = true;
      _selectedIndex = null;
      _pendingIndex = index;
    });

    _selectedController.add(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        children: [
          // Декоративные светящиеся круги
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.glowPurple.withOpacity(0.35),
                    AppColors.glowPurple.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.glowCyan.withOpacity(0.3),
                    AppColors.glowCyan.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.glowPink.withOpacity(0.25),
                    AppColors.glowPink.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'Fortune wheel',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: widget.members.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: EmptyFamilyState(),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: Column(
                        children: [
                          Text(
                            'Who takes the next task?',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 360,
                                  maxHeight: 360,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(36),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 12,
                                        sigmaY: 12,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.6),
                                              Colors.white.withOpacity(0.3),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            36,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.6,
                                            ),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.glowPurple
                                                  .withOpacity(0.3),
                                              blurRadius: 30,
                                              spreadRadius: 0,
                                              offset: const Offset(0, 15),
                                            ),
                                            BoxShadow(
                                              color: AppColors.glowCyan
                                                  .withOpacity(0.2),
                                              blurRadius: 40,
                                              spreadRadius: -10,
                                              offset: const Offset(0, 20),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: FortuneWheel(
                                            animateFirst: false,
                                            physics: CircularPanPhysics(
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                              curve: Curves.decelerate,
                                            ),
                                            indicators: const [
                                              FortuneIndicator(
                                                alignment: Alignment.topCenter,
                                                child: TriangleIndicator(
                                                  color:
                                                      AppColors.accentPrimary,
                                                ),
                                              ),
                                            ],
                                            onAnimationEnd: () {
                                              if (!mounted ||
                                                  _pendingIndex == null) {
                                                return;
                                              }
                                              setState(() {
                                                _selectedIndex = _pendingIndex;
                                                _pendingIndex = null;
                                                _isSpinning = false;
                                              });
                                            },
                                            selected:
                                                _selectedController.stream,
                                            items: [
                                              for (final member
                                                  in widget.members)
                                                FortuneItem(
                                                  child: Text(
                                                    member.name,
                                                    style: const TextStyle(
                                                      color:
                                                          AppColors.textPrimary,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  style: FortuneItemStyle(
                                                    color: member.color
                                                        .withOpacity(0.9),
                                                    borderColor: Colors.white
                                                        .withOpacity(0.7),
                                                    borderWidth: 2,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _SpinButton(
                            onPressed: widget.members.length < 2
                                ? null
                                : _spinWheel,
                            isSpinning: _isSpinning,
                            membersCount: widget.members.length,
                          ),
                          const SizedBox(height: 16),
                          if (_selectedIndex != null)
                            _SelectedMemberCard(
                              member: widget.members[_selectedIndex!],
                            ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpinButton extends StatelessWidget {
  const _SpinButton({
    required this.onPressed,
    required this.isSpinning,
    required this.membersCount,
  });

  final VoidCallback? onPressed;
  final bool isSpinning;
  final int membersCount;

  @override
  Widget build(BuildContext context) {
    final isDisabled = membersCount < 2;

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDisabled
              ? LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.3),
                    Colors.grey.withOpacity(0.2),
                  ],
                )
              : AppColors.holographicGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.glowPurple.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.glowCyan.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: -5,
                    offset: const Offset(0, 12),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.casino_rounded,
                      color: isDisabled ? Colors.grey : Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    membersCount < 2
                        ? 'Add more participants'
                        : isSpinning
                        ? 'Picking...'
                        : 'Pick randomly',
                    style: TextStyle(
                      color: isDisabled ? Colors.grey : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedMemberCard extends StatelessWidget {
  const _SelectedMemberCard({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                member.color.withOpacity(0.4),
                member.color.withOpacity(0.15),
                Colors.white.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.4, 1.0],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: member.color.withOpacity(0.35),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '🎉 Next assignee',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: member.color,
                    boxShadow: [
                      BoxShadow(
                        color: member.color.withOpacity(0.5),
                        blurRadius: 18,
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      member.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  member.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: member.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: member.color.withOpacity(0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      member.relation,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
