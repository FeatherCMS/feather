import ContactDomain
import FeatherApplication
import FeatherContracts

public struct UpdateSubmission: UseCase {
    struct Error: UseCaseError { let message: String }
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
        public let id: String
        public let status: Submission.Status
        public init(id: String, status: Submission.Status) {
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
            guard var value = try await scope.submission.findBy(id: input.id)
            else { throw Error(message: "Contact form submission not found") }
            value.status = input.status
            return try await scope.submission.update(value).asDetail
        }
    }
}
