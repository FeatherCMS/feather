import FeatherDatabase
import FeatherInfrastructure
import NewsletterDomain

extension DeliveryTable.Row {
    var asDomain: Delivery {
        get throws {
            guard
                let status = Delivery.Status(rawValue: status)
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
    DeliveryRepository
{

    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list(
        issueId: String
    ) async throws -> [Delivery] {
        try await DeliveryTable(connection: context.connection)
            .list(issueId: issueId)
            .map { try $0.asDomain }
    }

    public func insert(
        _ model: Delivery.New
    ) async throws -> Delivery {
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
    ) async throws -> Delivery? {
        let table = DeliveryTable(connection: context.connection)
        return
            try await table.find(
                issueId: issueId,
                subscriberEmail: subscriberEmail
            )
            .map { try $0.asDomain }
    }

    public func update(
        _ model: Delivery
    ) async throws -> Delivery {
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
}
