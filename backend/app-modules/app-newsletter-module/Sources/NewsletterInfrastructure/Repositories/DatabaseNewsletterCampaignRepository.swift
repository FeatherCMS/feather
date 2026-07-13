import NewsletterDomain
import FeatherDatabase

extension NewsletterCampaignTable.Row {
    var asDomain: NewsletterCampaign {
        .init(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseNewsletterCampaignRepository: NewsletterCampaignRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func list() async throws -> [NewsletterCampaign] {
        try await NewsletterCampaignTable(connection: connection).list().map(\.asDomain)
    }

    public func insert(
        _ model: NewsletterCampaign.New
    ) async throws -> NewsletterCampaign {
        let table = NewsletterCampaignTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                name: model.name
            )
        )
        return saved.asDomain
    }

    public func findBy(
        id: String
    ) async throws -> NewsletterCampaign? {
        let table = NewsletterCampaignTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: NewsletterCampaign
    ) async throws -> NewsletterCampaign {
        let table = NewsletterCampaignTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            name: model.name
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = NewsletterCampaignTable(connection: connection)
        return try await table.delete(id: id)
    }
}
