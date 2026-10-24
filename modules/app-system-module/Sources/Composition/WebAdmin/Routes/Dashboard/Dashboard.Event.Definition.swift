extension Dashboard.Event {
    public struct Definition: Sendable {
        public let contentStats: [Dashboard.Model.ContentStat]
        public let dailyTraffic: [Dashboard.Model.TrafficPoint]?
        public let topPages: [Dashboard.Model.BreakdownItem]?
        public let insightCards: [Dashboard.Model.InsightCard]

        public init(
            contentStats: [Dashboard.Model
                .ContentStat],
            dailyTraffic: [Dashboard.Model
                .TrafficPoint]?,
            topPages: [Dashboard.Model
                .BreakdownItem]?,
            insightCards: [Dashboard.Model
                .InsightCard]
        ) {
            self.contentStats = contentStats
            self.dailyTraffic = dailyTraffic
            self.topPages = topPages
            self.insightCards = insightCards
        }
    }
}
