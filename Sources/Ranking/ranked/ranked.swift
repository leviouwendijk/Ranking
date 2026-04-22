public struct Ranked<Value: Sendable>: Sendable {
    public let value: Value
    public let score: RankingScore
    public let sourceOrder: Int?

    public init(
        value: Value,
        score: RankingScore,
        sourceOrder: Int? = nil
    ) {
        self.value = value
        self.score = score
        self.sourceOrder = sourceOrder
    }

    public func withSourceOrder(
        _ sourceOrder: Int?
    ) -> Self {
        .init(
            value: value,
            score: score,
            sourceOrder: sourceOrder
        )
    }
}

extension Ranked: Equatable where Value: Equatable {}
extension Ranked: Hashable where Value: Hashable {}
extension Ranked: Codable where Value: Codable {}
