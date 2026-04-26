import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_viewmodel.dart';
import 'bottom_nav_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    tab: BottomNavTab.home,
                    viewModel: viewModel,
                  ),
                  _buildNavItem(
                    context: context,
                    tab: BottomNavTab.templates,
                    viewModel: viewModel,
                  ),
                  _buildNavItem(
                    context: context,
                    tab: BottomNavTab.myCvs,
                    viewModel: viewModel,
                  ),
                  _buildNavItem(
                    context: context,
                    tab: BottomNavTab.profile,
                    viewModel: viewModel,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required BottomNavTab tab,
    required BottomNavViewModel viewModel,
  }) {
    final isSelected = viewModel.currentTab == tab;

    return Expanded(
      child: Center(
        child: BottomNavItem(
          icon: viewModel.getIconForTab(tab, isSelected),
          label: viewModel.getTitleForTab(tab),
          isSelected: isSelected,
          onTap: () {
            if (!isSelected) {
              viewModel.setTab(tab);
            }
          },
        ),
      ),
    );
  }
}
