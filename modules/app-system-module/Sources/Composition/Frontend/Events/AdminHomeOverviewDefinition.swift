public struct AdminHomeOverviewDefinition: Sendable {
    public let contentStats: [AdminGetDashboardModel.ContentStat]
    public let dailyTraffic: [AdminGetDashboardModel.TrafficPoint]?
    public let topPages: [AdminGetDashboardModel.BreakdownItem]?
    public let insightCards: [AdminGetDashboardModel.InsightCard]

    public init(
        contentStats: [AdminGetDashboardModel.ContentStat],
        dailyTraffic: [AdminGetDashboardModel.TrafficPoint]?,
        topPages: [AdminGetDashboardModel.BreakdownItem]?,
        insightCards: [AdminGetDashboardModel.InsightCard]
    ) {
        self.contentStats = contentStats
        self.dailyTraffic = dailyTraffic
        self.topPages = topPages
        self.insightCards = insightCards
    }
}
