import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
public import NewsletterDomain
public import NewsletterModule

extension Issue.Table.Detail {
    var asDomain: Issue.Model {
        get throws {
            guard let status = Issue.Model.Status(rawValue: status) else {
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

extension Issue.Table.List {
    var asDomain: Issue.Model {
        get throws {
            try Issue.Table
                .Detail(
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
                .asDomain
        }
    }
}

extension Issue.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Issue.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func list(newsletterId: String) async throws -> [Issue.Model] {
            try await accessLayer.select {
                $0.where(\.newsletterId, equals: newsletterId)
                    .order(by: \.createdAt, .descending)
                    .order(by: \.id, .descending)
            }
            .map { try $0.asDomain }
        }

        public func insert(_ model: Issue.Model.New) async throws -> Issue.Model
        {
            let row = Issue.Table.Insert(
                id: context.idGenerator.generate(),
                newsletterId: model.newsletterId,
                subject: model.subject,
                previewText: model.previewText,
                content: model.content,
                status: model.status.rawValue,
                scheduledDate: model.scheduledDate
            )
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            return try saved.asDomain
        }

        public func findBy(id: String) async throws -> Issue.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map { try $0.asDomain }
        }

        public func update(_ model: Issue.Model) async throws -> Issue.Model {
            try await accessLayer.update(
                .init(
                    subject: model.subject,
                    previewText: model.previewText,
                    content: model.content,
                    status: model.status.rawValue,
                    scheduledDate: model.scheduledDate,
                    sentDate: model.sentDate
                ),
                where: \.id,
                equals: model.id
            )
            guard
                let updated = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: model.id
                )
            else {
                throw RepositoryError.notFound
            }
            return try updated.asDomain
        }

        public func delete(ids: [String]) async throws -> [String] {
            try await accessLayer.delete(where: \.id, in: ids)
            return ids
        }
    }
}
