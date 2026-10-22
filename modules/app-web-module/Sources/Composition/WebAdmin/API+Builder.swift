public import FeatherWebAdmin
public import FeatherWebShared
public import Foundation
public import SystemWebAdmin

extension API {
    public struct Builder: Sendable {
        public let environment: AppEnvironment

        public init(environment: AppEnvironment) {
            self.environment = environment
        }

        public var baseURL: URL { environment.apiBaseURL }

        public func makeWebAdmin(
            _ context: AuthenticatedRequestContext
        ) -> Client {
            .init(environment: environment, requestContext: context)
        }

        public func makeSystemAdmin(
            _ context: AuthenticatedRequestContext
        ) -> SystemWebAdmin.API.Client {
            .init(apiBaseURL: environment.apiBaseURL, requestContext: context)
        }
    }
}
