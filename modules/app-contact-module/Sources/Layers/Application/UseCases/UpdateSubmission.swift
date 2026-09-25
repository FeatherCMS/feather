import ContactContracts
public import ContactDomain
public import FeatherApplication
public import FeatherContracts

public struct UpdateSubmission: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Submissions.update
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
        public let id: String
        public let status: Submission.Status
        public init(
            formKey: String,
            id: String,
            status: Submission.Status
        ) {
            self.formKey = formKey
            self.id = id
            self.status = status
        }
    }
    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SubmissionDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard let form = try await scope.form.findBy(key: input.formKey)
            else { throw Error.formNotFound }
            guard
                var value = try await scope.submission.findBy(id: input.id),
                value.formId == form.id
            else { throw Error.submissionNotFound }
            value.status = input.status
            return try await scope.submission.update(value).asDetail
        }
    }

    public enum Error: UseCaseError {
        case formNotFound
        case submissionNotFound
    }
}
