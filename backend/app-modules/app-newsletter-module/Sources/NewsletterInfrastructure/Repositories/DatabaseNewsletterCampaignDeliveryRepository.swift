import NewsletterDomain
import FeatherDatabase
import Infrastructure

extension NewsletterCampaignDeliveryTable.Row {
    var asDomain: NewsletterCampaignDelivery {
        get throws {
            guard let status = NewsletterCampaignDelivery.Status(rawValue: status) else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                issueId: issueId,
                newsletterId: newsletterId,
                subscriberEmail: subscriberEmail,
                status: status,
                sentDate: sentDate,
                failureReason: failureReason,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

public struct DatabaseNewsletterCampaignDeliveryRepository: NewsletterCampaignDeliveryRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func list(
        issueId: String
    ) async throws -> [NewsletterCampaignDelivery] {
        try await NewsletterCampaignDeliveryTable(connection: connection)
            .list(issueId: issueId)
            .map { try $0.asDomain }
    }

    public func insert(
        _ model: NewsletterCampaignDelivery.New
    ) async throws -> NewsletterCampaignDelivery {
        let table = NewsletterCampaignDeliveryTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                issueId: model.issueId,
                newsletterId: model.newsletterId,
                subscriberEmail: model.subscriberEmail,
                status: model.status.rawValue,
                sentDate: model.sentDate,
                failureReason: model.failureReason
            )
        )
        return try saved.asDomain
    }

    public func findBy(
        issueId: String,
        subscriberEmail: String
    ) async throws -> NewsletterCampaignDelivery? {
        let table = NewsletterCampaignDeliveryTable(connection: connection)
        return try await table.find(
            issueId: issueId,
            subscriberEmail: subscriberEmail
        ).map { try $0.asDomain }
    }

    public func update(
        _ model: NewsletterCampaignDelivery
    ) async throws -> NewsletterCampaignDelivery {
        let table = NewsletterCampaignDeliveryTable(connection: connection)
        let updated = try await table.update(
            issueId: model.issueId,
            subscriberEmail: model.subscriberEmail,
            row: .init(
                issueId: model.issueId,
                newsletterId: model.newsletterId,
                subscriberEmail: model.subscriberEmail,
                status: model.status.rawValue,
                sentDate: model.sentDate,
                failureReason: model.failureReason,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return try updated.asDomain
    }
}
