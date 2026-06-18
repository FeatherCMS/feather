import Application
import Domain
import WebDomain

public struct GetMenuItem: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.MenuItems.read
    }

    struct Error: UseCaseError {
        let message: String
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
        public let id: String
        public let menuId: String

        public init(
            id: String,
            menuId: String
        ) {
            self.id = id
            self.menuId = menuId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MenuItemDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            let detail = try await context.menuItem.find(id: input.id)
            guard detail.menuId == input.menuId else {
                throw Error(message: "Menu item not found")
            }
            return detail
        }
    }
}
