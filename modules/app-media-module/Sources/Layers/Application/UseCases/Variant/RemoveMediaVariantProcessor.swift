public import FeatherApplication
public import FeatherContracts
import MediaContracts
import MediaDomain

public struct RemoveMediaVariantProcessor: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.VariantProcessors.delete
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
        public let ids: [String]
        public init(variantId: String, ids: [String]) {
            self.variantId = variantId
            self.ids = ids
        }
    }
    public func execute(subject: Subject, input: Input) async throws -> [String]
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let processors = try await scope.variantProcessors.list(
                variantId: input.variantId
            )
            let ids = Set(
                processors.map(\.id).filter { input.ids.contains($0) }
            )
            return try await scope.variantProcessors.delete(ids: Array(ids))
        }
    }
}
