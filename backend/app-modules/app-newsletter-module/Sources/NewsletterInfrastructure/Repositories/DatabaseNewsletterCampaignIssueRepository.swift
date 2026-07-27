import NewsletterDomain
import FeatherDatabase
import Infrastructure

extension NewsletterCampaignIssueTable.Row {
    var asDomain: NewsletterCampaignIssue {
        get throws {
            guard let status = NewsletterCampaignIssue.Status(rawValue: status)
            else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                id: id,
                newsletterId: newsletterId,
                subject: subject,
                previewText: previewText,
                content: content,
                status: status,
                scheduledDate: scheduledDate,
                sentDate: sentDate,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

public struct DatabaseNewsletterCampaignIssueRepository:
    NewsletterCampaignIssueRepository
{

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func list(
        newsletterId: String
    ) async throws -> [NewsletterCampaignIssue] {
        let table = NewsletterCampaignIssueTable(connection: connection)
        return try await table.list(newsletterId: newsletterId)
            .map { try $0.asDomain }
    }

    public func insert(
        _ model: NewsletterCampaignIssue.New
    ) async throws -> NewsletterCampaignIssue {
        let table = NewsletterCampaignIssueTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                newsletterId: model.newsletterId,
                subject: model.subject,
                previewText: model.previewText,
                content: model.content,
                status: model.status.rawValue,
                scheduledDate: model.scheduledDate
            )
        )
        return try saved.asDomain
    }

    public func findBy(
        id: String
    ) async throws -> NewsletterCampaignIssue? {
        let table = NewsletterCampaignIssueTable(connection: connection)
        return try await table.find(id: id).map { try $0.asDomain }
    }

    public func update(
        _ model: NewsletterCampaignIssue
    ) async throws -> NewsletterCampaignIssue {
        let table = NewsletterCampaignIssueTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                newsletterId: model.newsletterId,
                subject: model.subject,
                previewText: model.previewText,
                content: model.content,
                status: model.status.rawValue,
                scheduledDate: model.scheduledDate,
                sentDate: model.sentDate,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return try updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        try await NewsletterCampaignIssueTable(connection: connection)
            .delete(id: id)
    }
}
