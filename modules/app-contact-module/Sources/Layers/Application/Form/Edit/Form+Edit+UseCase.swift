import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Form.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
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
                guard var value = try await scope.form.findBy(key: input.key)
                else {
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
                    .map { Form.Field(model: $0) }
                let mails = try await scope.mail.listBy(formId: value.id)
                    .map { Form.Mail(model: $0) }
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
    }
}
