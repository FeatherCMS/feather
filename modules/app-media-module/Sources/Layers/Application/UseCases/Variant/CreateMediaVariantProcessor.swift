public import FeatherApplication
public import FeatherContracts
import MediaContracts
public import MediaDomain

public struct CreateMediaVariantProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.VariantProcessors.create
    }
    public enum Error: UseCaseError { case variantNotFound }
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
        public let processor: MediaVariantProcessorCreate
        public init(processor: MediaVariantProcessorCreate) {
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
                try await scope.variantDefinitions.find(
                    id: input.processor.variantId
                ) != nil
            else { throw Error.variantNotFound }
            return try await scope.variantProcessors.insert(
                MediaVariantProcessor.create(
                    variantId: input.processor.variantId,
                    name: input.processor.name,
                    matchExtensions: input.processor.matchExtensions,
                    commandTemplate: input.processor.commandTemplate,
                    isActive: input.processor.isActive
                )
            )
        }
    }
}
