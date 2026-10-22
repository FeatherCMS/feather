public import FeatherApplication
public import FeatherModuleKit
import SystemModule
public import WebModule

extension Metadata.Resolve {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = Admin.Permissions.access
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Metadata.Query.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Metadata.Query.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public struct Input: DTO {
            public let referenceType: String
            public let referenceIDs: [String]

            public init(
                referenceType: String,
                referenceIDs: [String]
            ) {
                self.referenceType = referenceType
                self.referenceIDs = referenceIDs
            }
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> [Metadata.List.Output.Item] {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.metadata.resolve(
                    referenceType: input.referenceType,
                    referenceIDs: input.referenceIDs
                )
            }
        }
    }
}
