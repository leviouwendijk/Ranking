public struct RankingScoreComponent: Sendable, Codable, Hashable {
    public let name: String
    public let value: Int
    public let detail: String?

    public init(
        name: String,
        value: Int,
        detail: String? = nil
    ) {
        self.name = name
        self.value = value
        self.detail = detail
    }
}
