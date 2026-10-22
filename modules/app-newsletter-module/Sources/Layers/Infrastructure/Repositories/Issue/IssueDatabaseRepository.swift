import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension IssueTable.Row {
    var asDomain: Issue.Model {
        get throws {
            guard let status = Issue.Model.Status(rawValue: status)
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

public struct IssueDatabaseRepository:
    Issue.Repository.Interface
{

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list(
        newsletterId: String
    ) async throws -> [Issue.Model] {
        let table = IssueTable(connection: context.connection)
        return try await table.list(newsletterId: newsletterId)
            .map { try $0.asDomain }
    }

    public func insert(
        _ model: Issue.Model.New
    ) async throws -> Issue.Model {
        let table = IssueTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
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
    ) async throws -> Issue.Model? {
        let table = IssueTable(connection: context.connection)
        return try await table.find(id: id).map { try $0.asDomain }
    }

    public func update(
        _ model: Issue.Model
    ) async throws -> Issue.Model {
        let table = IssueTable(connection: context.connection)
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
        ids: [String]
    ) async throws -> [String] {
        try await DatabaseAccessLayer<IssueTable>(context: context)
            .delete(where: \.id, in: ids)
        return ids
    }
}
