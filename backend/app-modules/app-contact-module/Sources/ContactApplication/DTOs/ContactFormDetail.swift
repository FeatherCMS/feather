import Application
import ContactDomain
import struct Foundation.Date

public struct ContactFormDetail: DTO {
    public let id: String
    public let name: String
    public let successMessage: String
    public let failureMessage: String
    public let redirectUrl: String?
    public let items: [ContactFormItemDetail]
    public let mails: [ContactFormMailDetail]
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        items: [ContactFormItemDetail],
        mails: [ContactFormMailDetail],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.successMessage = successMessage
        self.failureMessage = failureMessage
        self.redirectUrl = redirectUrl
        self.items = items
        self.mails = mails
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
