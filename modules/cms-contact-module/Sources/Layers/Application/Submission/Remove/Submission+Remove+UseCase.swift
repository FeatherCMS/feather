import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Submission.Remove {
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
                guard let form = try await scope.form.findBy(key: input.formKey)
                else {
                    return .init(ids: [])
                }
                var ids: [String] = []
                for id in input.ids {
                    guard
                        let submission = try await scope.submission.findBy(
                            id: id
                        ),
                        submission.formId == form.id
                    else {
                        continue
                    }
                    ids.append(id)
                }
                return .init(
                    ids: try await scope.submission.delete(ids: ids)
                )
            }
        }
    }
}
