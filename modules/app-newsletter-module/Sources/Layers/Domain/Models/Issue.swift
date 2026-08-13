import FeatherDomain

import struct Foundation.Date

public struct Issue: Model {

    public enum Error: DomainError {
        case subjectTooShort
        case subjectTooLong
        case contentTooShort
        case invalidSchedule
    }

    public enum Status: String, Sendable, CaseIterable {
        case draft
        case scheduled
        case sending
        case sent
        case failed
    }

    public struct New: Sendable {
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String
        public let status: Status
        public let scheduledDate: Date?
    }

    public let id: String
    public let newsletterId: String
    public var subject: String
    public var previewText: String
    public var content: String
    public var status: Status
    public var scheduledDate: Date?
    public var sentDate: Date?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        newsletterId: String,
        subject: String,
        previewText: String,
        content: String,
        status: Status,
        scheduledDate: Date?,
        sentDate: Date?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.newsletterId = newsletterId
        self.subject = subject
        self.previewText = previewText
        self.content = content
        self.status = status
        self.scheduledDate = scheduledDate
        self.sentDate = sentDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Issue {

    private static func validate(
        subject: String,
        content: String
    ) throws(Self.Error) {
        guard !subject.isEmpty else {
            throw .subjectTooShort
        }
        guard subject.count < 255 else {
            throw .subjectTooLong
        }
        guard !content.isEmpty else {
            throw .contentTooShort
        }
    }

    public static func create(
        newsletterId: String,
        subject: String,
        previewText: String = "",
        content: String
    ) throws(Self.Error) -> Self.New {
        try validate(subject: subject, content: content)
        return .init(
            newsletterId: newsletterId,
            subject: subject,
            previewText: previewText,
            content: content,
            status: .draft,
            scheduledDate: nil
        )
    }

    public mutating func schedule(
        at date: Date,
        now: Date
    ) throws(Self.Error) {
        guard date >= now else {
            throw .invalidSchedule
        }
        status = .scheduled
        scheduledDate = date
    }
}
