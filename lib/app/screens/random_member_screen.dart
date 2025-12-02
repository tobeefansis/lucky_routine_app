import 'dart:async';
import 'dart:math';

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
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Fortune wheel'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
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
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                  boxShadow: AppColors.softGlow,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: FortuneWheel(
                                    animateFirst: false,
                                    physics: CircularPanPhysics(
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.decelerate,
                                    ),
                                    indicators: const [
                                      FortuneIndicator(
                                        alignment: Alignment.topCenter,
                                        child: TriangleIndicator(
                                          color: AppColors.accentPrimary,
                                        ),
                                      ),
                                    ],
                                    onAnimationEnd: () {
                                      if (!mounted || _pendingIndex == null) {
                                        return;
                                      }
                                      setState(() {
                                        _selectedIndex = _pendingIndex;
                                        _pendingIndex = null;
                                        _isSpinning = false;
                                      });
                                    },
                                    selected: _selectedController.stream,
                                    items: [
                                      for (final member in widget.members)
                                        FortuneItem(
                                          child: Text(
                                            member.name,
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: FortuneItemStyle(
                                            color: member.color.withOpacity(
                                              0.85,
                                            ),
                                            borderColor:
                                                Colors.white.withOpacity(0.6),
                                            borderWidth: 1.5,
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
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                              widget.members.length < 2 ? null : _spinWheel,
                          icon: const Icon(Icons.casino),
                          label: Text(
                            widget.members.length < 2
                                ? 'Add more participants'
                                : _isSpinning
                                    ? 'Picking...'
                                    : 'Pick randomly',
                          ),
                        ),
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
    );
  }
}

class _SelectedMemberCard extends StatelessWidget {
  const _SelectedMemberCard({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: AppColors.softGlow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Next assignee:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 26,
              backgroundColor: member.color,
              child: Text(
                member.initials,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              member.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              member.relation,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
