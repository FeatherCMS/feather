public import FeatherAdmin
public import Foundation

extension API {
    public struct Builder: Sendable {
        private let apiBaseURL: URL

        var baseURL: URL { apiBaseURL }

        public init(apiBaseURL: URL) {
            self.apiBaseURL = apiBaseURL
        }

        public func makeSystemAdmin(
            _ context: AuthenticatedRequestContext
        ) -> Client {
            .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
        }
    }
}
