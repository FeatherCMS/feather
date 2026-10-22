import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

public struct UpdateForm: UseCase {
    struct Action: PermissionAction {
        let key = Form.Permissions.update
    }
    struct MailCreateAction: PermissionAction {
        let key = SubmissionMail.Permissions.create
    }
    struct MailListAction: PermissionAction {
        let key = SubmissionMail.Permissions.list
    }
    struct MailDeleteAction: PermissionAction {
        let key = SubmissionMail.Permissions.delete
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
        public struct Mail: DTO {
            public let mailFrom: String
            public let mailTo: String
            public let subject: String
            public let additionalHeaders: [String]
            public let messageBody: String

            public init(
                mailFrom: String,
                mailTo: String,
                subject: String,
                additionalHeaders: [String] = [],
                messageBody: String
            ) {
                self.mailFrom = mailFrom
                self.mailTo = mailTo
                self.subject = subject
                self.additionalHeaders = additionalHeaders
                self.messageBody = messageBody
            }
        }

        public let key: String
        public let newKey: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let fieldIds: [String]
        public let mails: [Mail]

        public init(
            key: String,
            newKey: String,
            name: String,
            successMessage: String = "",
            failureMessage: String = "",
            redirectUrl: String? = nil,
            fieldIds: [String] = [],
            mails: [Mail] = []
        ) {
            self.key = key
            self.newKey = newKey
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
    ) async throws -> Form.Edit.Output {
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
            guard var value = try await scope.form.findBy(key: input.key) else {
                throw Error.formNotFound
            }
            try value.update(
                key: input.newKey,
                name: input.name,
                successMessage: input.successMessage,
                failureMessage: input.failureMessage,
                redirectUrl: input.redirectUrl
            )
            let current = try await scope.field.listBy(formId: value.id)
            for item in current where !input.fieldIds.contains(item.id) {
                try await scope.field.unassign(
                    formId: value.id,
                    fieldId: item.id
                )
            }
            for (position, fieldId) in input.fieldIds.enumerated() {
                try await scope.field.assign(
                    formId: value.id,
                    fieldId: fieldId,
                    position: position
                )
            }
            try await scope.mail.deleteBy(formId: value.id)
            for mail in input.mails {
                _ = try await scope.mail.insert(
                    .init(
                        formId: value.id,
                        mailFrom: mail.mailFrom,
                        mailTo: mail.mailTo,
                        subject: mail.subject,
                        additionalHeaders: mail.additionalHeaders,
                        messageBody: mail.messageBody
                    )
                )
            }
            let saved = try await scope.form.update(value)
            let fields = try await scope.field.listBy(formId: value.id)
                .map(\.asFormField)
            let mails = try await scope.mail.listBy(formId: value.id)
                .map(\.asFormMail)
            return .init(
                id: saved.id,
                key: saved.key,
                name: saved.name,
                successMessage: saved.successMessage,
                failureMessage: saved.failureMessage,
                redirectUrl: saved.redirectUrl,
                fields: fields,
                mails: mails,
                createdAt: saved.createdAt,
                updatedAt: saved.updatedAt
            )
        }
    }
    public enum Error: UseCaseError { case formNotFound }
}
