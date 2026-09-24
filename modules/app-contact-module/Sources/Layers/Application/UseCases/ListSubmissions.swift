import ContactContracts
import ContactDomain
public import FeatherApplication
public import FeatherContracts

public struct ListSubmissions: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Submissions.list
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
        public let formKey: String
        public init(formKey: String) { self.formKey = formKey }
    }
    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [SubmissionDetail] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard let form = try await scope.form.findBy(key: input.formKey)
            else {
                throw Error.formNotFound
            }
            return try await scope.submission.listBy(formId: form.id)
                .map(\.asDetail)
        }
    }

    public enum Error: UseCaseError {
        case formNotFound
    }
}
