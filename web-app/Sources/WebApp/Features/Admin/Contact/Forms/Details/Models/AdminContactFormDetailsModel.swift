struct AdminContactFormDetailsItem: Sendable {
    let id: String
    let name: String
    let successMessage: String
    let failureMessage: String
    let redirectUrl: String?
    let selectedFieldIDs: [String]
    let availableFields: [AdminContactFormFieldOption]
    let mails: [AdminContactFormEmail]
}

struct AdminContactFormEmail: Sendable, Equatable, Codable, Hashable {
    let id: String
    let mailFrom: String
    let mailTo: String
    let subject: String
    let additionalHeaders: String
    let messageBody: String
}

struct ContactFormEditForm: Decodable {
    let name: String
    let successMessage: String?
    let failureMessage: String?
    let redirectUrl: String?
    let fieldIds: [String]?
    let mailFrom: [String]?
    let mailTo: [String]?
    let subject: [String]?
    let additionalHeaders: [String]?
    let messageBody: [String]?

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

struct ContactFormMailFormInput: Decodable {
    let mailFrom: String
    let mailTo: String
    let subject: String
    let additionalHeaders: String?
    let messageBody: String

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
