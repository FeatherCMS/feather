public import ContactModule

extension SubmissionMail.Form {
    public struct Input: Decodable {
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: [String]?
        public let messageBody: String

        var mail: ContactModule.Form.Email {
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
}
