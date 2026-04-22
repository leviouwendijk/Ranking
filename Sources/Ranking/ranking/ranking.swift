public enum Ranking {
    public static func rank<S: Sequence>(
        _ values: S,
        score: (S.Element) -> RankingScore?,
        options: RankingSelectionOptions = .defaults,
        tieBreak: ((Ranked<S.Element>, Ranked<S.Element>) -> Bool)? = nil
    ) -> [Ranked<S.Element>]
    where S.Element: Sendable {
        let ranked: [Ranked<S.Element>] = values.enumerated().compactMap { element in
            let (index, value) = element

            guard let candidateScore = score(value) else {
                return nil
            }

            return Ranked(
                value: value,
                score: candidateScore,
                sourceOrder: index
            )
        }

        return select(
            ranked,
            options: options,
            tieBreak: tieBreak
        )
    }

    public static func select<Value: Sendable>(
        _ ranked: [Ranked<Value>],
        options: RankingSelectionOptions = .defaults,
        tieBreak: ((Ranked<Value>, Ranked<Value>) -> Bool)? = nil
    ) -> [Ranked<Value>] {
        let filtered = ranked.filter { candidate in
            options.threshold.contains(candidate.score)
        }

        let sorted = sort(
            filtered,
            order: options.order,
            tieBreak: tieBreak
        )

        guard let limit = options.limit else {
            return sorted
        }

        return Array(sorted.prefix(max(0, limit)))
    }

    public static func sort<Value: Sendable>(
        _ ranked: [Ranked<Value>],
        order: RankingOrder = .descending,
        tieBreak: ((Ranked<Value>, Ranked<Value>) -> Bool)? = nil
    ) -> [Ranked<Value>] {
        ranked.enumerated()
            .sorted { lhs, rhs in
                compare(
                    lhs.element,
                    rhs.element,
                    lhsInputIndex: lhs.offset,
                    rhsInputIndex: rhs.offset,
                    order: order,
                    tieBreak: tieBreak
                )
            }
            .map(\.element)
    }
}

private extension Ranking {
    static func compare<Value: Sendable>(
        _ lhs: Ranked<Value>,
        _ rhs: Ranked<Value>,
        lhsInputIndex: Int,
        rhsInputIndex: Int,
        order: RankingOrder,
        tieBreak: ((Ranked<Value>, Ranked<Value>) -> Bool)?
    ) -> Bool {
        if lhs.score.value != rhs.score.value {
            switch order {
            case .descending:
                return lhs.score.value > rhs.score.value

            case .ascending:
                return lhs.score.value < rhs.score.value
            }
        }

        if let tieBreak {
            if tieBreak(lhs, rhs) {
                return true
            }

            if tieBreak(rhs, lhs) {
                return false
            }
        }

        if let lhsSourceOrder = lhs.sourceOrder,
           let rhsSourceOrder = rhs.sourceOrder,
           lhsSourceOrder != rhsSourceOrder {
            return lhsSourceOrder < rhsSourceOrder
        }

        return lhsInputIndex < rhsInputIndex
    }
}
