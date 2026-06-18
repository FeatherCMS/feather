import Application
import Domain
import WebDomain

public struct GetMenu: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Menus.read
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
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MenuDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { context in
            try await context.menu.find(id: id)
        }
    }
}
