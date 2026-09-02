import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NewsletterDomain

extension CampaignTable.Row {
    var asDomain: Campaign {
        .init(
            id: id,
            name: name,
            fromEmail: fromEmail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct CampaignDatabaseRepository: CampaignRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list() async throws -> [Campaign] {
        try await CampaignTable(connection: context.connection).list()
            .map(\.asDomain)
    }

    public func insert(
        _ model: Campaign.New
    ) async throws -> Campaign {
        let table = CampaignTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                name: model.name,
                fromEmail: model.fromEmail
            )
        )
        return saved.asDomain
    }

    public func findBy(
        id: String
    ) async throws -> Campaign? {
        let table = CampaignTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Campaign
    ) async throws -> Campaign {
        let table = CampaignTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            name: model.name,
            fromEmail: model.fromEmail
        )
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = CampaignTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
