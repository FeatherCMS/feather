import Foundation
public import Hummingbird
import NewsletterModule

extension Campaign.Subscription {
    public struct Route: Sendable {
        public static let standard = Route(
            prefix: RouterPath("api/v1/newsletter/campaigns"),
            parameterName: "campaignKey",
            suffix: RouterPath("subscribe")
        )

        private let prefix: RouterPath
        public let parameterName: String
        private let suffix: RouterPath

        public init(
            prefix: RouterPath,
            parameterName: String,
            suffix: RouterPath
        ) {
            self.prefix = prefix
            self.parameterName = parameterName
            self.suffix = suffix
        }

        public var routerPath: RouterPath {
            prefix
                .appendingPath(RouterPath("{\(parameterName)}"))
                .appendingPath(suffix)
        }

        public func actionPath(
            for value: String
        ) -> String {
            let allowedCharacters = CharacterSet(
                charactersIn:
                    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
            )
            let encodedValue =
                value.addingPercentEncoding(
                    withAllowedCharacters: allowedCharacters
                ) ?? ""
            return
                prefix
                .appendingPath(RouterPath(encodedValue))
                .appendingPath(suffix)
                .description
        }
    }
}
