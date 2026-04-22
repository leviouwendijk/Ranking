public enum RankingThreshold: Sendable, Codable, Hashable {
    case none
    case minimum(Int)
    case maximum(Int)

    public func contains(
        _ score: RankingScore
    ) -> Bool {
        switch self {
        case .none:
            return true

        case .minimum(let minimum):
            return score.value >= minimum

        case .maximum(let maximum):
            return score.value <= maximum
        }
    }
}
