public import FeatherWebAdmin
public import Foundation

public struct NewsletterAdminAPIBuilder: Sendable {
    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeNewsletterAdmin(
        _ context: AuthenticatedRequestContext
    ) -> NewsletterAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
