import Application
import ContactDomain

public struct UpdateContactForm: UseCase {
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
        public let id: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let fieldIds: [String]
        public let mails: [ContactFormMailInput]

        public init(
            id: String,
            name: String,
            successMessage: String = "",
            failureMessage: String = "",
            redirectUrl: String? = nil,
            fieldIds: [String] = [],
            mails: [ContactFormMailInput] = []
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
    public func execute(_ input: Input) async throws -> ContactFormDetail {
        try await transaction.run { context in
            guard var value = try await context.form.findBy(id: input.id) else {
                throw Error.notFound
            }
            try value.update(
                name: input.name,
                successMessage: input.successMessage,
                failureMessage: input.failureMessage,
                redirectUrl: input.redirectUrl
            )
            let current = try await context.item.listBy(formId: input.id)
            for item in current where !input.fieldIds.contains(item.id) {
                try await context.item.unassign(
                    formId: input.id,
                    itemId: item.id
                )
            }
            for (position, fieldId) in input.fieldIds.enumerated() {
                try await context.item.assign(
                    formId: input.id,
                    itemId: fieldId,
                    position: position
                )
            }
            try await context.mail.deleteBy(formId: input.id)
            for mail in input.mails {
                _ = try await context.mail.insert(
                    .init(
                        id: idGenerator.generate(),
                        formId: input.id,
                        mailFrom: mail.mailFrom,
                        mailTo: mail.mailTo,
                        subject: mail.subject,
                        additionalHeaders: mail.additionalHeaders,
                        messageBody: mail.messageBody
                    )
                )
            }
            let saved = try await context.form.update(value)
            let items = try await context.item.listBy(formId: input.id)
                .map(\.asDetail)
            let mails = try await context.mail.listBy(formId: input.id)
                .map(\.asDetail)
            return saved.asDetail(items: items, mails: mails)
        }
    }
    public enum Error: UseCaseError { case notFound }
}
