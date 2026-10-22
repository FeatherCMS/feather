import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Form.Add {
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
                let model = try Form.Model.create(
                    key: input.key,
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
                    .map(\.asFormField)
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
    }
}
