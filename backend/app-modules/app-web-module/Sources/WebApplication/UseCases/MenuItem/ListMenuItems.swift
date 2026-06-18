import Domain
import Application
import WebDomain

public struct ListMenuItems: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.MenuItems.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMenuItem>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMenuItem>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let menuId: String
        public let query: MenuItemList.Query

        public init(
            menuId: String,
            query: MenuItemList.Query
        ) {
            self.menuId = menuId
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MenuItemList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.menuItem.list(
                menuId: input.menuId,
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
            try await context.menuItem.count(
                menuId: input.menuId,
                query: inputQuery
            )
        }
    }
}
