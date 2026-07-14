import Application
import ContactDomain
import struct Foundation.Date

public struct ContactFormMailDetail: DTO {
    public let id: String
    public let formId: String
    public let mailFrom: String
    public let mailTo: String
    public let subject: String
    public let additionalHeaders: String
    public let messageBody: String
    public let createdAt: Date
    public let updatedAt: Date
}
