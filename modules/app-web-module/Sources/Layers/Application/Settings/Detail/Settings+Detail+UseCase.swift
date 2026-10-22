public import FeatherApplication
public import FeatherModuleKit
public import WebDomain
import WebModule

extension Settings.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = WebModule.Permissions.Settings.read
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Settings.Repository.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Settings.Repository.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public struct Input: DTO {
            public init() {}
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Settings.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.settings.get()
            }
        }
    }
}
