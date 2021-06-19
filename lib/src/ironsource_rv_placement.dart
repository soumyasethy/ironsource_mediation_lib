/// Placement
class IronSourceRVPlacement {
  final String placementName;
  final String rewardName;
  final int rewardAmount;

  IronSourceRVPlacement({
    required this.placementName,
    required this.rewardName,
    required this.rewardAmount,
  });

  @override
  String toString() {
    return "placementName: ${this.placementName}," +
        " rewardName:${this.rewardName}," +
        " rewardAmount:${this.rewardAmount}";
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceRVPlacement) &&
        other.placementName == placementName &&
        other.rewardName == rewardName &&
        other.rewardAmount == rewardAmount;
  }

  @override
  int get hashCode => placementName.hashCode ^ rewardName.hashCode ^ rewardAmount.hashCode;
}
