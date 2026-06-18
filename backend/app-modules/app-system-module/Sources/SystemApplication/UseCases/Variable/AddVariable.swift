import Domain
import Application
import SystemDomain

public struct AddVariable: UseCase {

    struct Action: PermissionAction {
        let key = SystemPermissions.Variables.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteVariable>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteVariable>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let name: String
        public let value: String
        public let notes: String

        public init(
            name: String,
            value: String,
            notes: String
        ) {
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

        let id = idGenerator.generate()
        let name = input.name
        let value = input.value
        let notes = input.notes

        let model = try await transaction.run { context in
            try await context.variable.insert(
                Variable.create(
                    id: id,
                    name: name,
                    value: value,
                    notes: notes
                )
            )
        }
        return model.asDetail
    }
}
