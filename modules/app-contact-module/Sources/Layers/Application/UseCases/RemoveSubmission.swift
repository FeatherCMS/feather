import ContactContracts
import ContactDomain
import FeatherApplication
import FeatherContracts

public struct RemoveSubmission: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Submissions.delete
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
        public let ids: [String]

        public init(
            formKey: String,
            ids: [String]
        ) {
            self.formKey = formKey
            self.ids = ids
        }
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
            guard let form = try await scope.form.findBy(key: input.formKey)
            else { return [] }
            var ids: [String] = []
            for id in input.ids {
                guard
                    let submission = try await scope.submission.findBy(id: id),
                    submission.formId == form.id
                else { continue }
                ids.append(id)
            }
            return try await scope.submission.delete(ids: ids)
        }
    }
}
