import Domain
import Application
import WebDomain

public struct ListMenus: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Menus.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMenu>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMenu>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: MenuList.Query

        public init(
            query: MenuList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MenuList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.menu.list(
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
            try await context.menu.count(
                query: inputQuery
            )
        }
    }
}
