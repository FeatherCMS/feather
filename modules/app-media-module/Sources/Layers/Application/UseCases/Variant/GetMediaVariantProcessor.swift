public import FeatherApplication
public import FeatherContracts
import MediaContracts
public import MediaDomain

public struct GetMediaVariantProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.VariantProcessors.read
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
        public let variantId: String
        public let id: String

        public init(variantId: String, id: String) {
            self.variantId = variantId
            self.id = id
        }
    }

    public func execute(subject: Subject, input: Input) async throws
        -> MediaVariantProcessor?
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            guard
                let processor = try await scope.variantProcessors.find(
                    id: input.id
                ),
                processor.variantId == input.variantId
            else { return nil }
            return processor
        }
    }
}
