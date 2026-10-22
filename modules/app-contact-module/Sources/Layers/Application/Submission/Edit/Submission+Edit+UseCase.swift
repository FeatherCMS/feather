import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Submission.Edit {
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
                    throw Error.formNotFound
                }
                guard
                    var value = try await scope.submission.findBy(id: input.id),
                    value.formId == form.id
                else {
                    throw Error.submissionNotFound
                }
                value.status = input.status
                return .init(model: try await scope.submission.update(value))
            }
        }
    }
}
