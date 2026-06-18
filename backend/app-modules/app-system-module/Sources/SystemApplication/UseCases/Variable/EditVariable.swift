import Application
import Domain
import SystemDomain

public struct EditVariable: UseCase {

    struct Action: PermissionAction {
        let key = SystemPermissions.Variables.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteVariable>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteVariable>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let name: String?
        public let value: String?
        public let notes: String?

        public init(
            id: String,
            name: String?,
            value: String?,
            notes: String?
        ) {
            self.id = id
            self.name = name
            self.value = value
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> VariableDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id
        let name = input.name
        let value = input.value
        let notes = input.notes

        let model = try await transaction.run { context in
            guard
                var model = try await context.variable.find(id: id)
            else {
                throw Error(message: "Variable not found")
            }

            try model.update(
                name: name,
                value: value,
                notes: notes
            )

            return try await context.variable.update(model)
        }
        return model.asDetail
    }
}
