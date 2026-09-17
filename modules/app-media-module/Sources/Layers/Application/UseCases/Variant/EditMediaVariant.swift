import FeatherApplication
import FeatherContracts
import MediaContracts
import MediaDomain

public struct EditMediaVariant: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Variants.update
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
        public let id: String
        public let variant: MediaVariantCreate
        public init(id: String, variant: MediaVariantCreate) {
            self.id = id
            self.variant = variant
        }
    }

    public func execute(subject: Subject, input: Input) async throws
        -> MediaVariantDetail
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                var variant = try await scope.variantDefinitions.find(
                    id: input.id
                )
            else { throw Error.notFound }
            variant.key = input.variant.key
            variant.name = input.variant.name
            variant.isRequired = input.variant.isRequired
            variant.isActive = input.variant.isActive
            let saved = try await scope.variantDefinitions.update(variant)
            let processors = try await scope.variantProcessors.list(
                variantId: saved.id
            )
            return .init(
                id: saved.id,
                key: saved.key,
                name: saved.name,
                isRequired: saved.isRequired,
                isActive: saved.isActive,
                processors: processors.map(\.asVariantProcessorListItem),
                createdAt: saved.createdAt,
                updatedAt: saved.updatedAt
            )
        }
    }
}
