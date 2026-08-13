import ContactDomain
import FeatherApplication
import FeatherContracts

public struct GetSubmission: UseCase {
    struct Error: UseCaseError { let message: String }
    struct Action: PermissionAction {
        let key = ContactPermissions.Submissions.read
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
        public init(id: String) { self.id = id }
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
            guard let value = try await scope.submission.findBy(id: input.id)
            else { throw Error(message: "Contact form submission not found") }
            return value.asDetail
        }
    }
}
