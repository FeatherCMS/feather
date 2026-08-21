import ContactContracts
import ContactDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct UpdateForm: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Forms.update
    }
    struct MailCreateAction: PermissionAction {
        let key = ContactPermissions.Mails.create
    }
    struct MailListAction: PermissionAction {
        let key = ContactPermissions.Mails.list
    }
    struct MailDeleteAction: PermissionAction {
        let key = ContactPermissions.Mails.delete
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
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let fieldIds: [String]
        public let mails: [SubmissionMailInput]

        public init(
            id: String,
            name: String,
            successMessage: String = "",
            failureMessage: String = "",
            redirectUrl: String? = nil,
            fieldIds: [String] = [],
            mails: [SubmissionMailInput] = []
        ) {
            self.id = id
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
        let deleteMailAction = MailDeleteAction()
        guard
            try await authorizer.can(
                subject: subject,
                perform: deleteMailAction
            )
        else {
            throw AuthError(
                kind: .forbidden,
                message: deleteMailAction.key.rawValue
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
        }
        return try await transaction.run { scope in
            guard var value = try await scope.form.findBy(id: input.id) else {
                throw Error.notFound
            }
            try value.update(
                name: input.name,
                successMessage: input.successMessage,
                failureMessage: input.failureMessage,
                redirectUrl: input.redirectUrl
            )
            let current = try await scope.field.listBy(formId: input.id)
            for item in current where !input.fieldIds.contains(item.id) {
                try await scope.field.unassign(
                    formId: input.id,
                    fieldId: item.id
                )
            }
            for (position, fieldId) in input.fieldIds.enumerated() {
                try await scope.field.assign(
                    formId: input.id,
                    fieldId: fieldId,
                    position: position
                )
            }
            try await scope.mail.deleteBy(formId: input.id)
            for mail in input.mails {
                _ = try await scope.mail.insert(
                    .init(
                        formId: input.id,
                        mailFrom: mail.mailFrom,
                        mailTo: mail.mailTo,
                        subject: mail.subject,
                        additionalHeaders: mail.additionalHeaders,
                        messageBody: mail.messageBody
                    )
                )
            }
            let saved = try await scope.form.update(value)
            let fields = try await scope.field.listBy(formId: input.id)
                .map(\.asDetail)
            let mails = try await scope.mail.listBy(formId: input.id)
                .map(\.asDetail)
            return saved.asDetail(fields: fields, mails: mails)
        }
    }
    public enum Error: UseCaseError { case notFound }
}
