public import ContactModule
public import FeatherApplication

extension Form.Edit {
    public struct Input: DTO {
        public let key: String
        public let newKey: String
        public let name: String
        public let successMessage: String
        public let failureMessage: String
        public let redirectUrl: String?
        public let fieldIds: [String]
        public let mails: [Mail]

        public init(
            key: String,
            newKey: String,
            name: String,
            successMessage: String = "",
            failureMessage: String = "",
            redirectUrl: String? = nil,
            fieldIds: [String] = [],
            mails: [Mail] = []
        ) {
            self.key = key
            self.newKey = newKey
            self.name = name
            self.successMessage = successMessage
            self.failureMessage = failureMessage
            self.redirectUrl = redirectUrl
            self.fieldIds = fieldIds
            self.mails = mails
        }
    }
}
