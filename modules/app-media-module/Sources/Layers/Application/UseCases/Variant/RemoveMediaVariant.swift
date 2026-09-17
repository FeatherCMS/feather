import FeatherApplication
import FeatherContracts
import MediaContracts
import MediaDomain

public struct RemoveMediaVariant: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Variants.delete
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
        public let ids: [String]
        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(subject: Subject, input: Input) async throws -> [String]
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.variantDefinitions.delete(ids: input.ids)
        }
    }
}
