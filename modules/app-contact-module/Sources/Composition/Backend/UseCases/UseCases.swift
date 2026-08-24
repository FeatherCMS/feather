import ContactApplication
import ContactContracts
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

public struct UseCases: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let authorizer: any Authorizer
    let mailQueue: any ContactMailQueue

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
}

extension UseCases {
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

    func render(
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

    func renderHTML(
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

    func htmlEscaped(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }

    func formTransaction() -> DatabaseTransactionExecutor<
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

}
