import 'package:flutter/material.dart';

class SeatSelector extends StatelessWidget {
  final int totalSeats;
  final List<int> occupiedSeats;
  final List<int> selectedSeats;
  final void Function(int) onSeatSelected;

  const SeatSelector({
    required this.totalSeats,
    required this.occupiedSeats,
    required this.selectedSeats,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: totalSeats,
      itemBuilder: (context, index) {
        final seatNumber = index + 1;
        final isOccupied = occupiedSeats.contains(seatNumber);
        final isSelected = selectedSeats.contains(seatNumber);

        return GestureDetector(
          onTap: isOccupied ? null : () => onSeatSelected(seatNumber),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isOccupied
                  ? Theme.of(context).colorScheme.onBackground.withOpacity(0.7)
                  : isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isOccupied
                    ? Theme.of(context).dividerColor
                    : isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                seatNumber.toString(),
                style: TextStyle(
                  color: isOccupied
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                      : isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
