import Application
import ContactDomain

public struct CreateContactForm: UseCase {
    let transaction: any TransactionExecutor<WriteContactForm>
    let idGenerator: any IDGenerator

    public init(
        transaction: any TransactionExecutor<WriteContactForm>,
        idGenerator: any IDGenerator
    ) {
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let fieldIds: [String]
        public let mails: [ContactFormMailInput]

        public init(
            name: String,
            successMessage: String = "",
            failureMessage: String = "",
            redirectUrl: String? = nil,
            fieldIds: [String] = [],
            mails: [ContactFormMailInput] = []
        ) {
            self.name = name
            self.successMessage = successMessage
            self.failureMessage = failureMessage
            self.redirectUrl = redirectUrl
            self.fieldIds = fieldIds
            self.mails = mails
        }
    }

    public func execute(_ input: Input) async throws -> ContactFormDetail {
        try await transaction.run { context in
            let model = try ContactForm.create(
                id: idGenerator.generate(),
                name: input.name,
                successMessage: input.successMessage,
                failureMessage: input.failureMessage,
                redirectUrl: input.redirectUrl
            )
            let saved = try await context.form.insert(model)
            for (position, fieldId) in input.fieldIds.enumerated() {
                try await context.item.assign(
                    formId: saved.id,
                    itemId: fieldId,
                    position: position
                )
            }
            let items = try await context.item.listBy(formId: saved.id)
                .map(\.asDetail)
            for mail in input.mails {
                _ = try await context.mail.insert(
                    .init(
                        id: idGenerator.generate(),
                        formId: saved.id,
                        mailFrom: mail.mailFrom,
                        mailTo: mail.mailTo,
                        subject: mail.subject,
                        additionalHeaders: mail.additionalHeaders,
                        messageBody: mail.messageBody
                    )
                )
            }
            let mails = try await context.mail.listBy(formId: saved.id)
                .map(\.asDetail)
            return saved.asDetail(items: items, mails: mails)
        }
    }
}
