import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension SubscriberTable.Row {
    var asDomain: Subscriber.Model {
        get throws {
            guard
                let status = Subscriber.Model.Status(
                    rawValue: status
                )
            else {
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

public struct SubscriberDatabaseRepository:
    Subscriber.Repository.Interface
{

    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list(
        newsletterId: String
    ) async throws -> [Subscriber.Model] {
        let table = SubscriberTable(connection: context.connection)
        return try await table.list(newsletterId: newsletterId)
            .map { try $0.asDomain }
    }

    public func insert(
        _ model: Subscriber.Model.New
    ) async throws -> Subscriber.Model {
        let table = SubscriberTable(connection: context.connection)
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
        return try saved.asDomain
    }

    public func findBy(
        newsletterId: String,
        email: String
    ) async throws -> Subscriber.Model? {
        let table = SubscriberTable(connection: context.connection)
        return try await table.find(
            newsletterId: newsletterId,
            email: email
        )?
        .asDomain
    }

    public func update(
        _ model: Subscriber.Model
    ) async throws -> Subscriber.Model {
        let table = SubscriberTable(connection: context.connection)
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
        return try updated.asDomain
    }

    public func delete(
        newsletterId: String,
        emails: [String]
    ) async throws -> [String] {
        let table = SubscriberTable(connection: context.connection)
        return try await table.delete(
            newsletterId: newsletterId,
            emails: emails
        )
    }
}
