public import FeatherApplication
public import FeatherContracts
import MediaContracts
import MediaDomain

public struct CreateMediaVariant: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Variants.create
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
        public let variant: MediaVariantCreate
        public init(variant: MediaVariantCreate) { self.variant = variant }
    }

    public func execute(subject: Subject, input: Input) async throws
        -> MediaVariantDetail
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let variant = try await transaction.run { scope in
            try await scope.variantDefinitions.insert(
                MediaVariant.create(
                    key: input.variant.key,
                    name: input.variant.name,
                    isRequired: input.variant.isRequired,
                    isActive: input.variant.isActive
                )
            )
        }
        return .init(
            id: variant.id,
            key: variant.key,
            name: variant.name,
            isRequired: variant.isRequired,
            isActive: variant.isActive,
            processors: [],
            createdAt: variant.createdAt,
            updatedAt: variant.updatedAt
        )
    }
}
