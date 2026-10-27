import ContactModule

extension ContactModule.Form.Details {
    struct Item: Sendable {
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let submitLabel: String
        public let redirectUrl: String?
        public let selectedFieldIDs: [String]
        public let availableFields: [ContactModule.FormField.Option]
        public let mails: [ContactModule.Form.Email]
    }
}
