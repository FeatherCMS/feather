extension ContactForm {
    struct Email: Sendable, Equatable, Codable, Hashable {
        public let id: String
        public let mailFrom: String
        public let mailTo: String
        public let subject: String
        public let additionalHeaders: [String]
        public let messageBody: String
    }
}
