import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension Subscriber.Table.Detail {
    var asDomain: Subscriber.Model {
        get throws {
            guard let status = Subscriber.Model.Status(rawValue: status) else {
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

extension Subscriber.Table.List {
    var asDomain: Subscriber.Model {
        get throws {
            try Subscriber.Table
                .Detail(
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
                .asDomain
        }
    }
}

extension Subscriber.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Subscriber.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func list(newsletterId: String) async throws -> [Subscriber
            .Model]
        {
            try await accessLayer.select {
                $0.where(\.newsletterId, equals: newsletterId)
                    .order(by: \.email)
            }
            .map { try $0.asDomain }
        }

        public func insert(_ model: Subscriber.Model.New) async throws
            -> Subscriber.Model
        {
            let row = Subscriber.Table.Insert(
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
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    as: Subscriber.Table.Detail.self,
                    {
                        $0.where(\.newsletterId, equals: row.newsletterId)
                            .where(\.email, equals: row.email)
                    }
                )
            else {
                throw RepositoryError.notFound
            }
            return try saved.asDomain
        }

        public func findBy(newsletterId: String, email: String) async throws
            -> Subscriber.Model?
        {
            try await accessLayer.selectFirst(as: Subscriber.Table.Detail.self)
            {
                $0.where(\.newsletterId, equals: newsletterId)
                    .where(\.email, equals: email)
            }
            .map { try $0.asDomain }
        }

        public func findBy(
            unsubscribeToken: String
        ) async throws -> Subscriber.Model? {
            try await accessLayer.selectFirst(as: Subscriber.Table.Detail.self)
            {
                $0.where(\.unsubscribeToken, equals: unsubscribeToken)
            }
            .map { try $0.asDomain }
        }

        public func update(_ model: Subscriber.Model) async throws
            -> Subscriber.Model
        {
            try await accessLayer.update(
                .init(
                    status: model.status.rawValue,
                    subscriptionDate: model.subscriptionDate,
                    unsubscriptionDate: model.unsubscriptionDate,
                    firstName: model.firstName,
                    lastName: model.lastName,
                    confirmedAt: model.confirmedAt,
                    unsubscribeToken: model.unsubscribeToken,
                    source: model.source,
                    lastSentAt: model.lastSentAt
                ),
                where: DatabaseQueryFilter<Subscriber.Table>()
                    .where(\.newsletterId, equals: model.newsletterId)
                    .where(\.email, equals: model.email)
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    as: Subscriber.Table.Detail.self,
                    {
                        $0.where(\.newsletterId, equals: model.newsletterId)
                            .where(\.email, equals: model.email)
                    }
                )
            else {
                throw RepositoryError.notFound
            }
            return try updated.asDomain
        }

        public func delete(newsletterId: String, emails: [String]) async throws
            -> [String]
        {
            guard !emails.isEmpty else { return [] }
            let filter = DatabaseQueryFilter<Subscriber.Table>()
                .where(\.newsletterId, equals: newsletterId)
                .where(\.email, in: emails)
            let rows = try await accessLayer.select(
                as: Subscriber.Table.List.self,
                where: filter
            )
            try await accessLayer.delete(where: filter)
            return rows.map(\.email)
        }
    }
}
