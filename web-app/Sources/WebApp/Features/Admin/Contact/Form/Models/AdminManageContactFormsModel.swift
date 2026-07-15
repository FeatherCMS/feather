struct AdminManageContactFormItem: Sendable {
    let id: String
    let name: String
    let successMessage: String
    let failureMessage: String
    let redirectUrl: String?
    let selectedFieldIDs: [String]
    let availableFields: [AdminManageContactFormFieldOption]
    let mails: [AdminManageContactFormMail]
}

struct AdminManageContactFormMail: Sendable, Equatable, Codable, Hashable {
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

    var mails: [AdminManageContactFormMail] {
        let count = max(mailFrom?.count ?? 0, mailTo?.count ?? 0, subject?.count ?? 0, additionalHeaders?.count ?? 0, messageBody?.count ?? 0)
        return (0..<count).compactMap { index in
            let from = mailFrom?[safe: index] ?? ""
            let to = mailTo?[safe: index] ?? ""
            let title = subject?[safe: index] ?? ""
            let headers = additionalHeaders?[safe: index] ?? ""
            let body = messageBody?[safe: index] ?? ""
            let mail = AdminManageContactFormMail(
                id: "",
                mailFrom: from,
                mailTo: to,
                subject: title,
                additionalHeaders: headers,
                messageBody: body
            )
            return mail.mailFrom.isEmpty && mail.mailTo.isEmpty && mail.subject.isEmpty && mail.messageBody.isEmpty ? nil : mail
        }
    }
}

struct ContactFormMailFormInput: Decodable {
    let mailFrom: String
    let mailTo: String
    let subject: String
    let additionalHeaders: String?
    let messageBody: String

    var mail: AdminManageContactFormMail {
        .init(id: "", mailFrom: mailFrom, mailTo: mailTo, subject: subject, additionalHeaders: additionalHeaders ?? "", messageBody: messageBody)
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
