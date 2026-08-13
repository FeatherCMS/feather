public struct AdminHomeOverviewDefinition: Sendable {
    public let contentStats: [AdminGetHomeModel.ContentStat]
    public let dailyTraffic: [AdminGetHomeModel.TrafficPoint]?
    public let topPages: [AdminGetHomeModel.BreakdownItem]?
    public let insightCards: [AdminGetHomeModel.InsightCard]

    public init(
        contentStats: [AdminGetHomeModel.ContentStat],
        dailyTraffic: [AdminGetHomeModel.TrafficPoint]?,
        topPages: [AdminGetHomeModel.BreakdownItem]?,
        insightCards: [AdminGetHomeModel.InsightCard]
    ) {
        self.contentStats = contentStats
        self.dailyTraffic = dailyTraffic
        self.topPages = topPages
        self.insightCards = insightCards
    }
}
