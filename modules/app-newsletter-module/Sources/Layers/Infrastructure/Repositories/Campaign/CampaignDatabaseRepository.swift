import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension CampaignTable.Row {
    var asDomain: Campaign.Model {
        .init(
            id: id,
            key: key,
            name: name,
            fromEmail: fromEmail,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct CampaignDatabaseRepository: Campaign.Repository.Interface {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list() async throws -> [Campaign.Model] {
        try await CampaignTable(connection: context.connection).list()
            .map(\.asDomain)
    }

    public func insert(
        _ model: Campaign.Model.New
    ) async throws -> Campaign.Model {
        let table = CampaignTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                key: model.key,
                name: model.name,
                fromEmail: model.fromEmail
            )
        )
        return saved.asDomain
    }

    public func findBy(
        id: String
    ) async throws -> Campaign.Model? {
        let table = CampaignTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        key: String
    ) async throws -> Campaign.Model? {
        let table = CampaignTable(connection: context.connection)
        return try await table.find(key: key)?.asDomain
    }

    public func update(
        _ model: Campaign.Model
    ) async throws -> Campaign.Model {
        let table = CampaignTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            key: model.key,
            name: model.name,
            fromEmail: model.fromEmail
        )
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        try await DatabaseAccessLayer<CampaignTable>(context: context)
            .delete(where: \.id, in: ids)
        return ids
    }
}
