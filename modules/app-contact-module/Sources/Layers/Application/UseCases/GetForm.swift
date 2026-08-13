import ContactDomain
import FeatherApplication
import FeatherContracts

public struct GetForm: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Forms.read
    }
    struct MailListAction: PermissionAction {
        let key = ContactPermissions.Mails.list
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
    ) async throws -> FormDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let mailAction = MailListAction()
        guard
            try await authorizer.can(
                subject: subject,
                perform: mailAction
            )
        else {
            throw AuthError(
                kind: .forbidden,
                message: mailAction.key.rawValue
            )
        }
        return try await transaction.run { scope in
            guard let value = try await scope.form.findBy(id: input.id) else {
                throw Error.notFound
            }
            let fields = try await scope.field.listBy(formId: input.id)
                .map(\.asDetail)
            let mails = try await scope.mail.listBy(formId: input.id)
                .map(\.asDetail)
            return value.asDetail(fields: fields, mails: mails)
        }
    }
    public enum Error: UseCaseError { case notFound }
}
