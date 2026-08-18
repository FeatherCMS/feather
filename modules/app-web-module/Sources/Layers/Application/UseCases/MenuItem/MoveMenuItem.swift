import FeatherApplication
import FeatherContracts
import WebDomain

public struct MoveMenuItem: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.MenuItems.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMenuItem>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMenuItem>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let menuId: String
        public let beforeItemId: String?

        public init(
            id: String,
            menuId: String,
            beforeItemId: String?
        ) {
            self.id = id
            self.menuId = menuId
            self.beforeItemId = beforeItemId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action)
        else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        try await transaction.run { scope in
            try await scope.menuItem.move(
                id: input.id,
                menuId: input.menuId,
                beforeItemId: input.beforeItemId
            )
        }
    }
}
