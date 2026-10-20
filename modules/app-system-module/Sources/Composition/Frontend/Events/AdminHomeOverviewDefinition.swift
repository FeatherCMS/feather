public import FeatherAdmin
import SystemModule

public struct AdminHomeOverviewDefinition: Sendable {
    public let contentStats: [WebAdmin.System.Dashboard.Model.ContentStat]
    public let dailyTraffic: [WebAdmin.System.Dashboard.Model.TrafficPoint]?
    public let topPages: [WebAdmin.System.Dashboard.Model.BreakdownItem]?
    public let insightCards: [WebAdmin.System.Dashboard.Model.InsightCard]

    public init(
        contentStats: [WebAdmin.System.Dashboard.Model.ContentStat],
        dailyTraffic: [WebAdmin.System.Dashboard.Model.TrafficPoint]?,
        topPages: [WebAdmin.System.Dashboard.Model.BreakdownItem]?,
        insightCards: [WebAdmin.System.Dashboard.Model.InsightCard]
    ) {
        self.contentStats = contentStats
        self.dailyTraffic = dailyTraffic
        self.topPages = topPages
        self.insightCards = insightCards
    }
}
