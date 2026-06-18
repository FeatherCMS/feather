import Application
import MediaDomain

public struct EditMediaProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Processors.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let name: String
        public let matchExtensions: String
        public let commandTemplate: String

        public init(
            id: String,
            name: String,
            matchExtensions: String,
            commandTemplate: String
        ) {
            self.id = id
            self.name = name
            self.matchExtensions = matchExtensions
            self.commandTemplate = commandTemplate
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaProcessorDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { context in
            guard
                var processor = try await context.processors.find(id: input.id)
            else {
                throw Error(message: "Processor not found")
            }

            processor.name = input.name
            processor.matchExtensions = input.matchExtensions
            processor.commandTemplate = input.commandTemplate

            return try await context.processors.update(processor)
                .asProcessorDetail
        }
    }
}
