import ContactApplication
import ContactInfrastructure
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Foundation

public protocol ContactMailQueue: Sendable {
    func enqueue(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String
    ) async throws
}

public struct ContactBackend: Sendable {
    private let database: any DatabaseClient
    private let idGenerator: any IDGenerator
    private let authorizer: any Authorizer
    private let mailQueue: any ContactMailQueue

    public init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        authorizer: any Authorizer,
        mailQueue: any ContactMailQueue
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.authorizer = authorizer
        self.mailQueue = mailQueue
    }

    public func aggregatedPermissions() {
        for permission in ContactPermissions.allPermissions() {
            print(permission.rawValue)
        }
    }

}

extension ContactBackend {
    public func enqueueMailTasks(
        form: FormDetail,
        valuesJSON: String
    ) async throws {
        guard
            let data = valuesJSON.data(using: .utf8),
            let values = try JSONSerialization.jsonObject(with: data)
                as? [String: Any]
        else {
            return
        }

        for mail in form.mails {
            try await mailQueue.enqueue(
                mailFrom: render(mail.mailFrom, values: values),
                mailTo: render(mail.mailTo, values: values),
                subject: render(mail.subject, values: values),
                additionalHeaders: render(
                    mail.additionalHeaders,
                    values: values
                ),
                messageBody: renderHTML(mail.messageBody, values: values)
            )
        }
    }

    private func render(
        _ template: String,
        values: [String: Any]
    ) -> String {
        values.reduce(template) { result, entry in
            let value = String(describing: entry.value)
            return
                result
                .replacingOccurrences(of: "[\(entry.key)]", with: value)
                .replacingOccurrences(of: "{{\(entry.key)}}", with: value)
        }
    }

    private func renderHTML(
        _ template: String,
        values: [String: Any]
    ) -> String {
        values.reduce(template) { result, entry in
            let value = htmlEscaped(String(describing: entry.value))
            return
                result
                .replacingOccurrences(of: "[\(entry.key)]", with: value)
                .replacingOccurrences(of: "{{\(entry.key)}}", with: value)
        }
    }

    private func htmlEscaped(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }

    private func formTransaction() -> DatabaseTransactionExecutor<
        WriteForm
    > {
        DatabaseTransactionExecutor(
            database: database,
            idGenerator: idGenerator,
            scope: { context in
                WriteForm(
                    form: FormDatabaseRepository(context: context),
                    field: FormFieldDatabaseRepository(context: context),
                    mail: SubmissionMailDatabaseRepository(context: context),
                    submission: SubmissionDatabaseRepository(context: context)
                )
            }
        )
    }

    public func makeCreateFormField() -> CreateFormField {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeListFormFields() -> ListFormFields {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeGetFormField() -> GetFormField {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeUpdateFormField() -> UpdateFormField {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeDeleteFormField() -> DeleteFormField {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }

    public func makeCreateContactForm() -> CreateForm {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeListContactForms() -> ListForms {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeGetContactForm() -> GetForm {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeGetPublicForm() -> GetPublicForm {
        .init(transaction: formTransaction())
    }
    public func makeUpdateContactForm() -> UpdateForm {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeDeleteContactForm() -> DeleteForm {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }

    public func makeSubmitContactForm() -> SubmitForm {
        .init(
            transaction: formTransaction()
        )
    }

    public func makeListContactFormSubmissions() -> ListSubmissions {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeGetContactFormSubmission() -> GetSubmission {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeUpdateContactFormSubmission() -> UpdateSubmission {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }
    public func makeDeleteContactFormSubmission() -> DeleteSubmission {
        .init(
            authorizer: authorizer,
            transaction: formTransaction()
        )
    }

}
