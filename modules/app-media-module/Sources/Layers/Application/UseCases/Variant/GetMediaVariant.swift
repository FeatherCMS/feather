import FeatherApplication
import FeatherContracts
import MediaContracts
import MediaDomain

public struct GetMediaVariant: UseCase {
    struct Action: PermissionAction { let key = MediaPermissions.Variants.read }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>

    public init(authorizer: any Authorizer, transaction: any TransactionExecutor<WriteMedia>) { self.authorizer = authorizer; self.transaction = transaction }

    public struct Input: DTO { public let id: String; public init(id: String) { self.id = id } }

    public func execute(subject: Subject, input: Input) async throws -> MediaVariantDetail? {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else { throw AuthError(kind: .forbidden, message: action.key.rawValue) }
        return try await transaction.run { scope in
            guard let variant = try await scope.variantDefinitions.find(id: input.id) else { return nil }
            let processors = try await scope.variantProcessors.list(variantId: variant.id)
            return .init(id: variant.id, key: variant.key, name: variant.name, isRequired: variant.isRequired, isActive: variant.isActive, processors: processors.map(\.asVariantProcessorListItem), createdAt: variant.createdAt, updatedAt: variant.updatedAt)
        }
    }
}
