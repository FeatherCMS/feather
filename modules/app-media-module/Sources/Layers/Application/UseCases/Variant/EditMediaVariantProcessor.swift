public import FeatherApplication
public import FeatherContracts
import MediaContracts
public import MediaDomain

public struct EditMediaVariantProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.VariantProcessors.update
    }
    public enum Error: UseCaseError { case notFound }
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
        public let variantId: String
        public let id: String
        public let processor: MediaVariantProcessorCreate
        public init(
            variantId: String,
            id: String,
            processor: MediaVariantProcessorCreate
        ) {
            self.variantId = variantId
            self.id = id
            self.processor = processor
        }
    }

    public func execute(subject: Subject, input: Input) async throws
        -> MediaVariantProcessor
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                var processor = try await scope.variantProcessors.find(
                    id: input.id
                ), processor.variantId == input.variantId
            else { throw Error.notFound }
            processor.name = input.processor.name
            processor.matchExtensions = input.processor.matchExtensions
            processor.commandTemplate = input.processor.commandTemplate
            processor.isActive = input.processor.isActive
            return try await scope.variantProcessors.update(processor)
        }
    }
}
