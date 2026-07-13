import NewsletterDomain
import FeatherDatabase
import Infrastructure

extension NewsletterCampaignSubscriberTable.Row {
    var asDomain: NewsletterCampaignSubscriber {
        get throws {
            guard let status = NewsletterCampaignSubscriber.Status(rawValue: status) else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                newsletterId: newsletterId,
                email: email,
                status: status,
                subscriptionDate: subscriptionDate,
                unsubscriptionDate: unsubscriptionDate,
                firstName: firstName,
                lastName: lastName,
                confirmedAt: confirmedAt,
                unsubscribeToken: unsubscribeToken,
                source: source,
                lastSentAt: lastSentAt,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

public struct DatabaseNewsletterCampaignSubscriberRepository: NewsletterCampaignSubscriberRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func list(
        newsletterId: String
    ) async throws -> [NewsletterCampaignSubscriber] {
        let table = NewsletterCampaignSubscriberTable(connection: connection)
        return try await table.list(newsletterId: newsletterId).map { try $0.asDomain }
    }

    public func insert(
        _ model: NewsletterCampaignSubscriber.New
    ) async throws -> NewsletterCampaignSubscriber {
        let table = NewsletterCampaignSubscriberTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                newsletterId: model.newsletterId,
                email: model.email,
                status: model.status.rawValue,
                subscriptionDate: model.subscriptionDate,
                unsubscriptionDate: model.unsubscriptionDate,
                firstName: model.firstName,
                lastName: model.lastName,
                confirmedAt: model.confirmedAt,
                unsubscribeToken: model.unsubscribeToken,
                source: model.source,
                lastSentAt: model.lastSentAt
            )
        )
        try await NewsletterCampaignCanonicalTable(connection: connection).synchronize(row: saved)
        return try saved.asDomain
    }

    public func findBy(
        newsletterId: String,
        email: String
    ) async throws -> NewsletterCampaignSubscriber? {
        let table = NewsletterCampaignSubscriberTable(connection: connection)
        return try await table.find(
            newsletterId: newsletterId,
            email: email
        )?.asDomain
    }

    public func update(
        _ model: NewsletterCampaignSubscriber
    ) async throws -> NewsletterCampaignSubscriber {
        let table = NewsletterCampaignSubscriberTable(connection: connection)
        let updated = try await table.update(
            newsletterId: model.newsletterId,
            email: model.email,
            row: .init(
                newsletterId: model.newsletterId,
                email: model.email,
                status: model.status.rawValue,
                subscriptionDate: model.subscriptionDate,
                unsubscriptionDate: model.unsubscriptionDate,
                firstName: model.firstName,
                lastName: model.lastName,
                confirmedAt: model.confirmedAt,
                unsubscribeToken: model.unsubscribeToken,
                source: model.source,
                lastSentAt: model.lastSentAt,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        try await NewsletterCampaignCanonicalTable(connection: connection).synchronize(row: updated)
        return try updated.asDomain
    }

    public func delete(
        newsletterId: String,
        email: String
    ) async throws -> Bool {
        let table = NewsletterCampaignSubscriberTable(connection: connection)
        let deleted = try await table.delete(
            newsletterId: newsletterId,
            email: email
        )
        if deleted {
            try await NewsletterCampaignCanonicalTable(connection: connection).delete(
                newsletterId: newsletterId,
                email: email
            )
        }
        return deleted
    }
}
