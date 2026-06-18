import Application

public struct LogOverview: DTO {

    public struct Query: Sendable {
        public let source: String
        public let from: Double
        public let to: Double

        public init(
            source: String,
            from: Double,
            to: Double
        ) {
            self.source = source
            self.from = from
            self.to = to
        }
    }

    public struct KPI: Sendable {
        public let totalRequests: Int
        public let averageRequestsPerDay: Double
        public let authenticatedRequests: Int
        public let notFoundRequests: Int
        public let clientErrorRequests: Int
        public let serverErrorRequests: Int

        package init(
            totalRequests: Int,
            averageRequestsPerDay: Double,
            authenticatedRequests: Int,
            notFoundRequests: Int,
            clientErrorRequests: Int,
            serverErrorRequests: Int
        ) {
            self.totalRequests = totalRequests
            self.averageRequestsPerDay = averageRequestsPerDay
            self.authenticatedRequests = authenticatedRequests
            self.notFoundRequests = notFoundRequests
            self.clientErrorRequests = clientErrorRequests
            self.serverErrorRequests = serverErrorRequests
        }
    }

    public struct DailyPoint: Sendable {
        public let bucket: Double
        public let requests: Int
        public let notFoundRequests: Int
        public let clientErrorRequests: Int
        public let serverErrorRequests: Int

        package init(
            bucket: Double,
            requests: Int,
            notFoundRequests: Int,
            clientErrorRequests: Int,
            serverErrorRequests: Int
        ) {
            self.bucket = bucket
            self.requests = requests
            self.notFoundRequests = notFoundRequests
            self.clientErrorRequests = clientErrorRequests
            self.serverErrorRequests = serverErrorRequests
        }
    }

    public struct BreakdownItem: Sendable {
        public let label: String
        public let count: Int
        public let share: Double

        package init(
            label: String,
            count: Int,
            share: Double
        ) {
            self.label = label
            self.count = count
            self.share = share
        }
    }

    public let query: Query
    public let kpis: KPI
    public let daily: [DailyPoint]
    public let statusFamilies: [BreakdownItem]
    public let methods: [BreakdownItem]
    public let paths: [BreakdownItem]
    public let notFoundPaths: [BreakdownItem]
    public let serverErrorPaths: [BreakdownItem]
    public let referrers: [BreakdownItem]
    public let browsers: [BreakdownItem]
    public let operatingSystems: [BreakdownItem]
    public let deviceTypes: [BreakdownItem]
    public let languages: [BreakdownItem]
    public let regions: [BreakdownItem]

    public init(
        query: Query,
        kpis: KPI,
        daily: [DailyPoint],
        statusFamilies: [BreakdownItem],
        methods: [BreakdownItem],
        paths: [BreakdownItem],
        notFoundPaths: [BreakdownItem],
        serverErrorPaths: [BreakdownItem],
        referrers: [BreakdownItem],
        browsers: [BreakdownItem],
        operatingSystems: [BreakdownItem],
        deviceTypes: [BreakdownItem],
        languages: [BreakdownItem],
        regions: [BreakdownItem]
    ) {
        self.query = query
        self.kpis = kpis
        self.daily = daily
        self.statusFamilies = statusFamilies
        self.methods = methods
        self.paths = paths
        self.notFoundPaths = notFoundPaths
        self.serverErrorPaths = serverErrorPaths
        self.referrers = referrers
        self.browsers = browsers
        self.operatingSystems = operatingSystems
        self.deviceTypes = deviceTypes
        self.languages = languages
        self.regions = regions
    }
}
