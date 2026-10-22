import AnalyticsDomain
public import FeatherApplication

extension Log.Overview {
    public struct Input: DTO {
        public struct Query: Sendable {
            public let source: String
            public let from: Double
            public let to: Double
            public let dashboardOnly: Bool
            public let notFoundOnly: Bool

            public init(
                source: String,
                from: Double,
                to: Double,
                dashboardOnly: Bool = false,
                notFoundOnly: Bool = false
            ) {
                self.source = source
                self.from = from
                self.to = to
                self.dashboardOnly = dashboardOnly
                self.notFoundOnly = notFoundOnly
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
