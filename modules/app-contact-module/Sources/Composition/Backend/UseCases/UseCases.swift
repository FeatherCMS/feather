public import ContactApplication
import ContactContracts
import ContactInfrastructure
import FeatherApplication
public import FeatherContracts
public import FeatherInfrastructure
import Foundation

public struct UseCases: Sendable {
    let databaseContext: DatabaseClientContext
    let authorizer: any Authorizer
    let jobs: any ContactJobs

    public init(
        databaseContext: DatabaseClientContext,
        authorizer: any Authorizer,
        jobs: any ContactJobs
    ) {
        self.databaseContext = databaseContext
        self.authorizer = authorizer
        self.jobs = jobs
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
            try await jobs.enqueueSubmissionMail(
                mailFrom: render(mail.mailFrom, values: values),
                mailTo: render(mail.mailTo, values: values),
                subject: render(mail.subject, values: values),
                additionalHeaders: mail.additionalHeaders.map {
                    render($0, values: values)
                },
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
            databaseContext: databaseContext,
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
