import ContactDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension SubmissionTable.Row {
    var asDomain: Submission {
        get throws {
            guard let status = Submission.Status(rawValue: status)
            else {
                throw RepositoryError.invalidEnumValue(status)
            }
            return .init(
                id: id,
                formId: formId,
                valuesJSON: valuesJSON,
                itemsSnapshotJSON: itemsSnapshotJSON,
                metadataJSON: metadataJSON,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

public struct SubmissionDatabaseRepository:
    SubmissionRepository
{

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func listBy(
        formId: String
    ) async throws -> [Submission] {
        let table = SubmissionTable(connection: context.connection)
        return try await table.list(formId: formId).map { try $0.asDomain }
    }

    public func insert(
        _ model: Submission.New
    ) async throws -> Submission {
        let table = SubmissionTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                formId: model.formId,
                valuesJSON: model.valuesJSON,
                itemsSnapshotJSON: model.itemsSnapshotJSON,
                metadataJSON: model.metadataJSON,
                status: model.status.rawValue,
            )
        )
        return try saved.asDomain
    }

    public func findBy(
        id: String
    ) async throws -> Submission? {
        let table = SubmissionTable(connection: context.connection)
        return try await table.find(id: id).map { try $0.asDomain }
    }

    public func update(
        _ model: Submission
    ) async throws -> Submission {
        let table = SubmissionTable(connection: context.connection)
        return
            try await table.update(id: model.id, status: model.status.rawValue)
            .asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        try await SubmissionTable(connection: context.connection).delete(ids: ids)
    }
}
