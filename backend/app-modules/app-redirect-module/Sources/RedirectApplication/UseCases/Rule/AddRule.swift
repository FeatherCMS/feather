import Domain
import Application
import RedirectDomain

public struct AddRule: UseCase {

    struct Action: PermissionAction {
        let key = RedirectPermissions.Rules.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRule>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRule>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let source: String
        public let destination: String
        public let statusCode: Int
        public let notes: String

        public init(
            source: String,
            destination: String,
            statusCode: Int,
            notes: String
        ) {
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> RuleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            try await context.rule.insert(
                Rule.create(
                    id: idGenerator.generate(),
                    source: input.source,
                    destination: input.destination,
                    statusCode: input.statusCode,
                    notes: input.notes
                )
            )
        }
        return model.asDetail
    }
}
