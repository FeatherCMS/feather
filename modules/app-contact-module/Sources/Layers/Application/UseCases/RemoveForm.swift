import ContactContracts
import ContactDomain
public import FeatherApplication
public import FeatherContracts

public struct RemoveForm: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Forms.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteForm>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteForm>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let keys: [String]
        public init(keys: [String]) { self.keys = keys }
    }
    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            var ids: [String] = []
            var keys: [String] = []
            for key in input.keys {
                guard let form = try await scope.form.findBy(key: key) else {
                    continue
                }
                ids.append(form.id)
                keys.append(form.key)
            }
            let deletedIds = try await scope.form.delete(ids: ids)
            return zip(ids, keys).compactMap { id, key in
                deletedIds.contains(id) ? key : nil
            }
        }
    }
}
