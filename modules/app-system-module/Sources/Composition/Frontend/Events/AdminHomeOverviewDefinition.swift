public struct AdminHomeOverviewDefinition: Sendable {
    public let contentStats: [AdminViewDashboardModel.ContentStat]
    public let dailyTraffic: [AdminViewDashboardModel.TrafficPoint]?
    public let topPages: [AdminViewDashboardModel.BreakdownItem]?
    public let insightCards: [AdminViewDashboardModel.InsightCard]

    public init(
        contentStats: [AdminViewDashboardModel.ContentStat],
        dailyTraffic: [AdminViewDashboardModel.TrafficPoint]?,
        topPages: [AdminViewDashboardModel.BreakdownItem]?,
        insightCards: [AdminViewDashboardModel.InsightCard]
    ) {
        self.contentStats = contentStats
        self.dailyTraffic = dailyTraffic
        self.topPages = topPages
        self.insightCards = insightCards
    }
}
