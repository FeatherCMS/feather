import Domain
import SystemDomain
import Application

public struct ListVariables: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Variables.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadVariable>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadVariable>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: VariableList.Query

        public init(
            query: VariableList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> VariableList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.variable.list(
                query: inputQuery
            )
        }
    }

    public func count(
        subject: Subject,
        input: Input
    ) async throws -> Int {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.variable.count(
                query: inputQuery
            )
        }
    }
}
