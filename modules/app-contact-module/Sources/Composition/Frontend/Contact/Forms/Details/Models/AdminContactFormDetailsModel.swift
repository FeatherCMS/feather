import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminContactFormDetailsItem: Sendable {
    public let id: String
    public let name: String
    public let successMessage: String
    public let failureMessage: String
    public let redirectUrl: String?
    public let selectedFieldIDs: [String]
    public let availableFields: [AdminContactFormFieldOption]
    public let mails: [AdminContactFormEmail]
}

struct AdminContactFormEmail: Sendable, Equatable, Codable, Hashable {
    public let id: String
    public let mailFrom: String
    public let mailTo: String
    public let subject: String
    public let additionalHeaders: String
    public let messageBody: String
}

struct ContactFormEditForm: Decodable {
    public let name: String
    public let successMessage: String?
    public let failureMessage: String?
    public let redirectUrl: String?
    public let fieldIds: [String]?
    public let mailFrom: [String]?
    public let mailTo: [String]?
    public let subject: [String]?
    public let additionalHeaders: [String]?
    public let messageBody: [String]?

    var mails: [AdminContactFormEmail] {
        let count = max(
            mailFrom?.count ?? 0,
            mailTo?.count ?? 0,
            subject?.count ?? 0,
            additionalHeaders?.count ?? 0,
            messageBody?.count ?? 0
        )
        return (0..<count)
            .compactMap { index in
                let from = mailFrom?[safe: index] ?? ""
                let to = mailTo?[safe: index] ?? ""
                let title = subject?[safe: index] ?? ""
                let headers = additionalHeaders?[safe: index] ?? ""
                let body = messageBody?[safe: index] ?? ""
                let mail = AdminContactFormEmail(
                    id: "",
                    mailFrom: from,
                    mailTo: to,
                    subject: title,
                    additionalHeaders: headers,
                    messageBody: body
                )
                return mail.mailFrom.isEmpty && mail.mailTo.isEmpty
                    && mail.subject.isEmpty && mail.messageBody.isEmpty
                    ? nil : mail
            }
    }
}

public struct SubmissionMailFormInput: Decodable {
    public let mailFrom: String
    public let mailTo: String
    public let subject: String
    public let additionalHeaders: String?
    public let messageBody: String

    var mail: AdminContactFormEmail {
        .init(
            id: "",
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders ?? "",
            messageBody: messageBody
        )
    }
}

extension Array {
    fileprivate subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
