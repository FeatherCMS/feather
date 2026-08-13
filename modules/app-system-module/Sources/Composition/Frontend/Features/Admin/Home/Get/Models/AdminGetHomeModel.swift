import FeatherAdmin

public struct AdminGetHomeOverview: Sendable {
    public struct DailyPoint: Sendable {
        public let bucket: Double
        public let requests: Int

        public init(bucket: Double, requests: Int) {
            self.bucket = bucket
            self.requests = requests
        }
    }

    public struct BreakdownItem: Sendable {
        public let label: String
        public let count: Int
        public let share: Double

        public init(label: String, count: Int, share: Double) {
            self.label = label
            self.count = count
            self.share = share
        }
    }

    public let daily: [DailyPoint]
    public let paths: [BreakdownItem]
    public let browsers: [BreakdownItem]
    public let operatingSystems: [BreakdownItem]
    public let deviceTypes: [BreakdownItem]
    public let languages: [BreakdownItem]
    public let regions: [BreakdownItem]

    public init(
        daily: [DailyPoint],
        paths: [BreakdownItem],
        browsers: [BreakdownItem],
        operatingSystems: [BreakdownItem],
        deviceTypes: [BreakdownItem],
        languages: [BreakdownItem],
        regions: [BreakdownItem]
    ) {
        self.daily = daily
        self.paths = paths
        self.browsers = browsers
        self.operatingSystems = operatingSystems
        self.deviceTypes = deviceTypes
        self.languages = languages
        self.regions = regions
    }
}

public struct AdminGetHomeModel: Sendable {
    public struct ContentStat: Sendable {
        public let label: String
        public let value: String

        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }

    public struct TrafficPoint: Sendable {
        public let bucket: Double
        public let requests: Int

        public init(bucket: Double, requests: Int) {
            self.bucket = bucket
            self.requests = requests
        }
    }

    public struct BreakdownItem: Sendable {
        public let label: String
        public let count: Int
        public let share: Double

        public init(label: String, count: Int, share: Double) {
            self.label = label
            self.count = count
            self.share = share
        }
    }

    public struct InsightCard: Sendable {
        public let title: String
        public let items: [BreakdownItem]

        public init(title: String, items: [BreakdownItem]) {
            self.title = title
            self.items = items
        }
    }

    struct QuickLinkGroup: Sendable {
        let label: String
        let actions: [QuickLinkAction]
    }

    struct QuickLinkAction: Sendable {
        enum Style: Sendable {
            case primary
            case secondary

            var cssClass: String {
                switch self {
                case .primary: ""
                case .secondary: "secondary"
                }
            }
        }

        let label: String
        let href: String
        let style: Style
    }

    let title: String
    let description: String
    let summary: String
    let contentStats: [ContentStat]
    let dailyTraffic: [TrafficPoint]?
    let topPages: [BreakdownItem]?
    let webInsightCards: [InsightCard]
    let quickLinkGroups: [QuickLinkGroup]
}
