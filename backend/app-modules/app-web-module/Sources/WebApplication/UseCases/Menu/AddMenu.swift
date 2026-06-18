import Domain
import Application
import WebDomain

public struct AddMenu: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Menus.create
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMenu>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMenu>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let key: String
        public let name: String
        public let notes: String

        public init(
            key: String,
            name: String,
            notes: String
        ) {
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
            if try await context.menu.find(key: input.key) != nil {
                throw Error(message: "Menu key already exists")
            }
            return try await context.menu.insert(
                Menu.create(
                    id: idGenerator.generate(),
                    key: input.key,
                    name: input.name,
                    notes: input.notes
                )
            )
        }
        return model.asDetail
    }
}
