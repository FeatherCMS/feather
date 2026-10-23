struct ContactFormEditForm: Decodable {
    public let key: String
    public let name: String
    public let successMessage: String?
    public let failureMessage: String?
    public let redirectUrl: String?
    public let fieldIds: [String]?
    public let mailFrom: [String]?
    public let mailTo: [String]?
    public let subject: [String]?
    public let additionalHeaders: [[String]]?
    public let messageBody: [String]?

    var mails: [ContactForm.Email] {
        let count = max(
            mailFrom?.count ?? 0,
            mailTo?.count ?? 0,
            subject?.count ?? 0,
            additionalHeaders?.count ?? 0,
            messageBody?.count ?? 0
        )
        return (0..<count)
            .compactMap { index in
                let from = mailFrom?.dropFirst(index).first ?? ""
                let to = mailTo?.dropFirst(index).first ?? ""
                let title = subject?.dropFirst(index).first ?? ""
                let headers = additionalHeaders?.dropFirst(index).first ?? []
                let body = messageBody?.dropFirst(index).first ?? ""
                let mail = ContactForm.Email(
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
