import Application
import Domain
import RedirectDomain

public struct EditRule: UseCase {

    struct Action: PermissionAction {
        let key = RedirectPermissions.Rules.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRule>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRule>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let source: String?
        public let destination: String?
        public let statusCode: Int?
        public let notes: String?

        public init(
            id: String,
            source: String?,
            destination: String?,
            statusCode: Int?,
            notes: String?
        ) {
            self.id = id
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
            guard var model = try await context.rule.find(id: input.id) else {
                throw Error(message: "Rule not found")
            }

            try model.update(
                source: input.source,
                destination: input.destination,
                statusCode: input.statusCode,
                notes: input.notes
            )

            return try await context.rule.update(model)
        }
        return model.asDetail
    }
}
