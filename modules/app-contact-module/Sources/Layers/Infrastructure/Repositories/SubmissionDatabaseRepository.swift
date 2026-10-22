public import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension SubmissionTable.Row {
    var asDomain: Submission.Model {
        get throws {
            guard let status = Submission.Model.Status(rawValue: status)
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
    Submission.Repository.Interface
{

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func listBy(
        formId: String
    ) async throws -> [Submission.Model] {
        let table = SubmissionTable(connection: context.connection)
        return try await table.list(formId: formId).map { try $0.asDomain }
    }

    public func insert(
        _ model: Submission.Model.New
    ) async throws -> Submission.Model {
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
    ) async throws -> Submission.Model? {
        let table = SubmissionTable(connection: context.connection)
        return try await table.find(id: id).map { try $0.asDomain }
    }

    public func update(
        _ model: Submission.Model
    ) async throws -> Submission.Model {
        let table = SubmissionTable(connection: context.connection)
        return
            try await table.update(id: model.id, status: model.status.rawValue)
            .asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        try await DatabaseAccessLayer<SubmissionTable>(context: context)
            .delete(where: \.id, in: ids)
        return ids
    }
}
