public struct SubmissionMailFormInput: Decodable {
    public let mailFrom: String
    public let mailTo: String
    public let subject: String
    public let additionalHeaders: [String]?
    public let messageBody: String

    var mail: ContactForm.Email {
        .init(
            id: "",
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders ?? [],
            messageBody: messageBody
        )
    }
}
