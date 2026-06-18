import Domain
import Application
import WebDomain

public struct AddMenuItem: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.MenuItems.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMenuItem>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMenuItem>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let menuId: String
        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let notes: String

        public init(
            menuId: String,
            label: String,
            url: String,
            priority: Int,
            isBlank: Bool,
            permission: String,
            notes: String
        ) {
            self.menuId = menuId
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.notes = notes
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

        let model = try await transaction.run { context in
            try await context.menuItem.insert(
                MenuItem.create(
                    id: idGenerator.generate(),
                    menuId: input.menuId,
                    label: input.label,
                    url: input.url,
                    priority: input.priority,
                    isBlank: input.isBlank,
                    permission: input.permission,
                    notes: input.notes
                )
            )
        }
        return model.asDetail
    }
}
