import ContactDomain
import FeatherApplication
import FeatherContracts

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
        public let formId: String
        public init(formId: String) { self.formId = formId }
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
            try await scope.submission.listBy(formId: input.formId)
                .map(\.asDetail)
        }
    }
}
