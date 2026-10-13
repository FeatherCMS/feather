public import FeatherAdmin
public import Foundation

public struct NewsAPIBuilder: Sendable {
    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeNewsAdmin(
        _ context: AuthenticatedRequestContext
    ) -> NewsAdminAPIClient {
        .init(
            apiBaseURL: apiBaseURL,
            sessionToken: context.sessionToken
        )
    }
}
