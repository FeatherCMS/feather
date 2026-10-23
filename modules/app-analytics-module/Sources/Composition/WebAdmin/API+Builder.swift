public import FeatherWebAdmin
public import Foundation

public struct AnalyticsAdminAPIBuilder: Sendable {
    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeAnalyticsAdmin(
        _ context: AuthenticatedRequestContext
    ) -> AnalyticsAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
