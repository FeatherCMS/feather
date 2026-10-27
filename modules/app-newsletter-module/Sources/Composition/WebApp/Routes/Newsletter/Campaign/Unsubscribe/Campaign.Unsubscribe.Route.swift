public import FeatherWebShared
public import NewsletterModule

extension Campaign.Unsubscribe {
    public struct Route: Sendable {
        public static let standard = Route(
            confirmation: WebRoute.root
                .appending(pathComponent: "newsletter")
                .appending(pathComponent: "unsubscribe")
                .appending(parameter: "unsubscribeToken")
        )

        public let confirmation: WebRoute

        public init(confirmation: WebRoute) {
            self.confirmation = confirmation
        }

        public var confirmationAction: WebRoute {
            confirmation.appending(pathComponent: "confirm")
        }
    }
}
