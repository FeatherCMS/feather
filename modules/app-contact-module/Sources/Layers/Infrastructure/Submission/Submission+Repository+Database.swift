public import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation

extension Submission.Table.Detail {
    var asDomain: Submission.Model {
        get throws {
            guard let status = Submission.Model.Status(rawValue: status) else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                id: id,
                formId: formId,
                valuesJSON: values,
                itemsSnapshotJSON: itemsSnapshot,
                metadataJSON: metadata,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

extension Submission.Table.List {
    var asDomain: Submission.Model {
        get throws {
            guard let status = Submission.Model.Status(rawValue: status) else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                id: id,
                formId: formId,
                valuesJSON: values,
                itemsSnapshotJSON: itemsSnapshot,
                metadataJSON: metadata,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

extension Submission.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<Submission.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func listBy(formId: String) async throws -> [Submission.Model] {
            try await accessLayer.select {
                $0.where(\.formId, equals: formId)
                    .order(by: \.createdAt, .descending)
                    .order(by: \.id, .descending)
            }
            .map { try $0.asDomain }
        }

        public func insert(_ model: Submission.Model.New) async throws
            -> Submission.Model
        {
            let row = Submission.Table.Insert(
                id: context.idGenerator.generate(),
                formId: model.formId,
                values: try Self.decodeJSON(model.valuesJSON),
                itemsSnapshot: try Self.decodeJSON(model.itemsSnapshotJSON),
                metadata: try model.metadataJSON.map(Self.decodeJSON),
                status: model.status.rawValue
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

        public func findBy(id: String) async throws -> Submission.Model? {
            try await accessLayer.selectFirst(by: \.id, equals: id)
                .map { try $0.asDomain }
        }

        public func update(_ model: Submission.Model) async throws
            -> Submission.Model
        {
            try await accessLayer.update(
                .init(status: model.status.rawValue),
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
            guard !ids.isEmpty else { return [] }
            let existingIDs =
                try await accessLayer.select {
                    $0.where(\.id, in: ids)
                }
                .map(\.id)
            try await accessLayer.delete(where: \.id, in: ids)
            return existingIDs
        }

        private static func decodeJSON(_ string: String) throws
            -> Submission.Table.JSONValue
        {
            try JSONDecoder().decode(
                Submission.Table.JSONValue.self,
                from: Data(string.utf8)
            )
        }
    }
}
