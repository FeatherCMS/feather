import Application
import Domain
import WebDomain

public struct EditMenu: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Menus.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMenu>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMenu>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let key: String?
        public let name: String?
        public let notes: String?

        public init(
            id: String,
            key: String?,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
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

        let model = try await transaction.run { context in
            guard var model = try await context.menu.find(id: input.id) else {
                throw Error(message: "Menu not found")
            }
            if let key = input.key,
                let existing = try await context.menu.find(key: key),
                existing.id != input.id
            {
                throw Error(message: "Menu key already exists")
            }

            try model.update(
                key: input.key,
                name: input.name,
                notes: input.notes
            )

            return try await context.menu.update(model)
        }
        return model.asDetail
    }
}
