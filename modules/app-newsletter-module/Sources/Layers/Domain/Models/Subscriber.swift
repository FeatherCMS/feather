import FeatherDomain

import struct Foundation.Date

public struct Subscriber: Model {

    public enum Error: DomainError {
        case emailTooShort
        case emailTooLong
    }

    public enum Status: String, Sendable, CaseIterable {
        case subscribed
        case unsubscribed
    }

    public struct New: Sendable {
        public let newsletterId: String
        public let email: String
        public let status: Status
        public let subscriptionDate: Date
        public let unsubscriptionDate: Date?
        public let firstName: String
        public let lastName: String
        public let confirmedAt: Date?
        public let unsubscribeToken: String?
        public let source: String?
        public let lastSentAt: Date?
    }

    public let newsletterId: String
    public let email: String
    public var status: Status
    public var subscriptionDate: Date
    public var unsubscriptionDate: Date?
    public var firstName: String
    public var lastName: String
    public var confirmedAt: Date?
    public let unsubscribeToken: String?
    public let source: String?
    public var lastSentAt: Date?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        newsletterId: String,
        email: String,
        status: Status,
        subscriptionDate: Date,
        unsubscriptionDate: Date?,
        firstName: String,
        lastName: String,
        confirmedAt: Date?,
        unsubscribeToken: String?,
        source: String?,
        lastSentAt: Date?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.newsletterId = newsletterId
        self.email = email
        self.status = status
        self.subscriptionDate = subscriptionDate
        self.unsubscriptionDate = unsubscriptionDate
        self.firstName = firstName
        self.lastName = lastName
        self.confirmedAt = confirmedAt
        self.unsubscribeToken = unsubscribeToken
        self.source = source
        self.lastSentAt = lastSentAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Subscriber {

    private static func validate(
        email: String
    ) throws(Self.Error) {
        guard !email.isEmpty else {
            throw .emailTooShort
        }
        guard email.count < 255 else {
            throw .emailTooLong
        }
    }

    public static func create(
        newsletterId: String,
        email: String,
        subscriptionDate: Date,
        firstName: String = "",
        lastName: String = "",
        confirmedAt: Date? = nil,
        unsubscribeToken: String? = nil,
        source: String? = nil
    ) throws(Self.Error) -> Self.New {
        try validate(email: email)
        return .init(
            newsletterId: newsletterId,
            email: email,
            status: .subscribed,
            subscriptionDate: subscriptionDate,
            unsubscriptionDate: nil,
            firstName: firstName,
            lastName: lastName,
            confirmedAt: confirmedAt,
            unsubscribeToken: unsubscribeToken,
            source: source,
            lastSentAt: nil
        )
    }

    public mutating func unsubscribe(
        at date: Date
    ) {
        status = .unsubscribed
        unsubscriptionDate = date
    }

    public mutating func subscribe(
        at date: Date
    ) {
        status = .subscribed
        subscriptionDate = date
        unsubscriptionDate = nil
    }
}
