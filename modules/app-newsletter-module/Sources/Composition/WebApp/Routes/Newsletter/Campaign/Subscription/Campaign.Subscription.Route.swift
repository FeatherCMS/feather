public import FeatherWebShared
public import NewsletterModule

extension Campaign.Subscription {
    public struct Route: Sendable {
        public static let standard = Route(
            prefix: WebRoute.root
                .appending(pathComponent: "api")
                .appending(pathComponent: "v1")
                .appending(pathComponent: "newsletter")
                .appending(pathComponent: "campaigns"),
            parameterName: "campaignKey",
            suffix: "subscribe"
        )

        private let prefix: WebRoute
        public let parameterName: String
        private let suffix: String

        public init(
            prefix: WebRoute,
            parameterName: String,
            suffix: String
        ) {
            self.prefix = prefix
            self.parameterName = parameterName
            self.suffix = suffix
        }

        private var route: WebRoute {
            prefix
                .appending(parameter: parameterName)
                .appending(pathComponent: suffix)
        }

        public var webRoute: WebRoute {
            route
        }

        public func actionPath(
            for value: String
        ) -> String {
            route.path(parameter: parameterName, value: value)
        }
    }
}
