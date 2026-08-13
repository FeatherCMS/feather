import ContactDomain
import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct FormDetail: DTO {
    public let id: String
    public let name: String
    public let successMessage: String
    public let failureMessage: String
    public let redirectUrl: String?
    public let fields: [FormFieldDetail]
    public let mails: [SubmissionMailDetail]
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fields: [FormFieldDetail],
        mails: [SubmissionMailDetail],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.successMessage = successMessage
        self.failureMessage = failureMessage
        self.redirectUrl = redirectUrl
        self.fields = fields
        self.mails = mails
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
