public import ContactModule
public import FeatherApplication

extension Form.Add {
    public struct Input: DTO {
        public let key: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let submitLabel: String
        public let redirectUrl: String?
        public let fieldIds: [String]
        public let mails: [Mail]

        public init(
            key: String,
            name: String,
            successMessage: String = "",
            failureMessage: String = "",
            submitLabel: String = "Submit",
            redirectUrl: String? = nil,
            fieldIds: [String] = [],
            mails: [Mail] = []
        ) {
            self.key = key
            self.name = name
            self.successMessage = successMessage
            self.failureMessage = failureMessage
            self.submitLabel = submitLabel
            self.redirectUrl = redirectUrl
            self.fieldIds = fieldIds
            self.mails = mails
        }
    }
}
