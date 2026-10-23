struct AdminContactFormDetailsItem: Sendable {
    public let key: String
    public let name: String
    public let successMessage: String
    public let failureMessage: String
    public let redirectUrl: String?
    public let selectedFieldIDs: [String]
    public let availableFields: [AdminContactFormFieldOption]
    public let mails: [AdminContactFormEmail]
}
