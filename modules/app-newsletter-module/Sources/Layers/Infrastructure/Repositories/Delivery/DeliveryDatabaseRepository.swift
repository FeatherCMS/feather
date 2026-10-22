import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension DeliveryTable.Row {
    var asDomain: Delivery.Model {
        get throws {
            guard
                let status = Delivery.Model.Status(rawValue: status)
            else {
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

public struct DeliveryDatabaseRepository:
    Delivery.Repository.Interface
{

    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list(
        issueId: String
    ) async throws -> [Delivery.Model] {
        try await DeliveryTable(connection: context.connection)
            .list(issueId: issueId)
            .map { try $0.asDomain }
    }

    public func insert(
        _ model: Delivery.Model.New
    ) async throws -> Delivery.Model {
        let table = DeliveryTable(connection: context.connection)
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
    ) async throws -> Delivery.Model? {
        let table = DeliveryTable(connection: context.connection)
        return
            try await table.find(
                issueId: issueId,
                subscriberEmail: subscriberEmail
            )
            .map { try $0.asDomain }
    }

    public func update(
        _ model: Delivery.Model
    ) async throws -> Delivery.Model {
        let table = DeliveryTable(connection: context.connection)
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

    public func delete(
        issueId: String
    ) async throws {
        try await DeliveryTable(connection: context.connection)
            .delete(issueId: issueId)
    }
}
