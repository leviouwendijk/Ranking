public struct RankingScore: Sendable, Codable, Hashable, Comparable, CustomStringConvertible {
    public let value: Int
    public let components: [RankingScoreComponent]

    public init(
        value: Int,
        components: [RankingScoreComponent] = []
    ) {
        self.value = value
        self.components = components
    }

    public static let zero: Self = .init(
        value: 0,
        components: []
    )

    public var isZero: Bool {
        value == 0
    }

    public var description: String {
        "\(value)"
    }

    public func adding(
        component: RankingScoreComponent
    ) -> Self {
        .init(
            value: value + component.value,
            components: components + [component]
        )
    }

    public func adding(
        value: Int,
        name: String,
        detail: String? = nil
    ) -> Self {
        adding(
            component: .init(
                name: name,
                value: value,
                detail: detail
            )
        )
    }

    public static func + (
        lhs: Self,
        rhs: Self
    ) -> Self {
        .init(
            value: lhs.value + rhs.value,
            components: lhs.components + rhs.components
        )
    }

    public static func < (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.value < rhs.value
    }
}
