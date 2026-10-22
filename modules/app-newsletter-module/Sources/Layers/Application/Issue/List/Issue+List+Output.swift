public import FeatherApplication
public import NewsletterDomain
public import NewsletterModule

public import struct Foundation.Date

extension Issue.List {
    public struct Output: DTO {
        public let id: String
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String
        public let status: Issue.Model.Status
        public let scheduledDate: Date?
        public let sentDate: Date?
        public let createdAt: Date
        public let updatedAt: Date

        public init(model: Issue.Model) {
            id = model.id
            newsletterId = model.newsletterId
            subject = model.subject
            previewText = model.previewText
            content = model.content
            status = model.status
            scheduledDate = model.scheduledDate
            sentDate = model.sentDate
            createdAt = model.createdAt
            updatedAt = model.updatedAt
        }
    }
}
