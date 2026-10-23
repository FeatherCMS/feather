import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension Delivery.Table.Detail {
    var asDomain: Delivery.Model {
        get throws {
            guard let status = Delivery.Model.Status(rawValue: status) else {
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

extension Delivery.Table.List {
    var asDomain: Delivery.Model {
        get throws {
            try Delivery.Table
                .Detail(
                    issueId: issueId,
                    newsletterId: newsletterId,
                    subscriberEmail: subscriberEmail,
                    status: status,
                    sentDate: sentDate,
                    failureReason: failureReason,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
                .asDomain
        }
    }
}

extension Delivery.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Delivery.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func list(issueId: String) async throws -> [Delivery.Model] {
            try await accessLayer.select {
                $0.where(\.issueId, equals: issueId)
                    .order(by: \.createdAt)
                    .order(by: \.subscriberEmail)
            }
            .map { try $0.asDomain }
        }

        public func insert(_ model: Delivery.Model.New) async throws
            -> Delivery.Model
        {
            let row = Delivery.Table.Insert(
                issueId: model.issueId,
                newsletterId: model.newsletterId,
                subscriberEmail: model.subscriberEmail,
                status: model.status.rawValue,
                sentDate: model.sentDate,
                failureReason: model.failureReason
            )
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    as: Delivery.Table.Detail.self,
                    {
                        $0.where(\.issueId, equals: row.issueId)
                            .where(
                                \.subscriberEmail,
                                equals: row.subscriberEmail
                            )
                    }
                )
            else {
                throw RepositoryError.notFound
            }
            return try saved.asDomain
        }

        public func findBy(issueId: String, subscriberEmail: String)
            async throws -> Delivery.Model?
        {
            try await accessLayer.selectFirst(as: Delivery.Table.Detail.self) {
                $0.where(\.issueId, equals: issueId)
                    .where(\.subscriberEmail, equals: subscriberEmail)
            }
            .map { try $0.asDomain }
        }

        public func update(_ model: Delivery.Model) async throws
            -> Delivery.Model
        {
            let filter = DatabaseQueryFilter<Delivery.Table>()
                .where(\.issueId, equals: model.issueId)
                .where(\.subscriberEmail, equals: model.subscriberEmail)
            try await accessLayer.update(
                .init(
                    status: model.status.rawValue,
                    sentDate: model.sentDate,
                    failureReason: model.failureReason
                ),
                where: filter
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    as: Delivery.Table.Detail.self,
                    { $0.where(filter) }
                )
            else {
                throw RepositoryError.notFound
            }
            return try updated.asDomain
        }

        public func delete(issueId: String) async throws {
            try await accessLayer.delete(where: \.issueId, equals: issueId)
        }
    }
}
