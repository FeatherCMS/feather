import ContactDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct CreateForm: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Forms.create
    }
    struct MailCreateAction: PermissionAction {
        let key = ContactPermissions.Mails.create
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
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let fieldIds: [String]
        public let mails: [SubmissionMailInput]

        public init(
            name: String,
            successMessage: String = "",
            failureMessage: String = "",
            redirectUrl: String? = nil,
            fieldIds: [String] = [],
            mails: [SubmissionMailInput] = []
        ) {
            self.name = name
            self.successMessage = successMessage
            self.failureMessage = failureMessage
            self.redirectUrl = redirectUrl
            self.fieldIds = fieldIds
            self.mails = mails
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> FormDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        if !input.mails.isEmpty {
            let createMailAction = MailCreateAction()
            guard
                try await authorizer.can(
                    subject: subject,
                    perform: createMailAction
                )
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: createMailAction.key.rawValue
                )
            }
            let listMailAction = MailListAction()
            guard
                try await authorizer.can(
                    subject: subject,
                    perform: listMailAction
                )
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: listMailAction.key.rawValue
                )
            }
        }
        return try await transaction.run { scope in
            let model = try Form.create(
                name: input.name,
                successMessage: input.successMessage,
                failureMessage: input.failureMessage,
                redirectUrl: input.redirectUrl
            )
            let saved = try await scope.form.insert(model)
            for (position, fieldId) in input.fieldIds.enumerated() {
                try await scope.field.assign(
                    formId: saved.id,
                    fieldId: fieldId,
                    position: position
                )
            }
            let fields = try await scope.field.listBy(formId: saved.id)
                .map(\.asDetail)
            for mail in input.mails {
                _ = try await scope.mail.insert(
                    .init(
                        formId: saved.id,
                        mailFrom: mail.mailFrom,
                        mailTo: mail.mailTo,
                        subject: mail.subject,
                        additionalHeaders: mail.additionalHeaders,
                        messageBody: mail.messageBody
                    )
                )
            }
            let mails =
                input.mails.isEmpty
                ? []
                : try await scope.mail.listBy(formId: saved.id)
                    .map(\.asDetail)
            return saved.asDetail(fields: fields, mails: mails)
        }
    }
}
