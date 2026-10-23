public import FeatherWebShared
public import Foundation

public struct NewsletterAppAPIBuilder: Sendable {
    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeNewsletterApp(
        _ context: DefaultRequestContext
    ) -> NewsletterAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
