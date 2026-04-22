public struct RankingSelectionOptions: Sendable, Codable, Hashable {
    public var order: RankingOrder
    public var threshold: RankingThreshold
    public var limit: Int?

    public init(
        order: RankingOrder = .descending,
        threshold: RankingThreshold = .none,
        limit: Int? = nil
    ) {
        self.order = order
        self.threshold = threshold
        self.limit = limit
    }

    public static let defaults: Self = .init()
}
