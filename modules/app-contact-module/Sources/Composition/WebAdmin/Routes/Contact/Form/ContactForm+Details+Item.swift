extension ContactForm.Details {
    struct Item: Sendable {
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let selectedFieldIDs: [String]
        public let availableFields: [ContactForm.Field.Option]
        public let mails: [ContactForm.Email]
    }
}
