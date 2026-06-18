import Application
import MediaDomain

public struct CreateMediaProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Processors.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let processor: MediaProcessorCreate
        public init(processor: MediaProcessorCreate) {
            self.processor = processor
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
            try await context.processors
                .insert(
                    MediaProcessor.create(
                        id: idGenerator.generate(),
                        name: input.processor.name,
                        matchExtensions: input.processor.matchExtensions,
                        commandTemplate: input.processor.commandTemplate,
                        isRequired: false,
                        isActive: true
                    )
                )
                .asProcessorDetail
        }
    }
}
