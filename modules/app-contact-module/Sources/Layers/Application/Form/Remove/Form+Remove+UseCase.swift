import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Form.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
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
                return .init(
                    keys: zip(ids, keys).compactMap { id, key in
                        deletedIds.contains(id) ? key : nil
                    }
                )
            }
        }
    }
}
