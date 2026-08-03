import ContactDomain
import FeatherDatabase
import Infrastructure

extension ContactFormSubmissionTable.Row {
    var asDomain: ContactFormSubmission {
        get throws {
            guard let status = ContactFormSubmission.Status(rawValue: status)
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

public struct DatabaseContactFormSubmissionRepository:
    ContactFormSubmissionRepository
{

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func listBy(
        formId: String
    ) async throws -> [ContactFormSubmission] {
        let table = ContactFormSubmissionTable(connection: connection)
        return try await table.list(formId: formId).map { try $0.asDomain }
    }

    public func insert(
        _ model: ContactFormSubmission.New
    ) async throws -> ContactFormSubmission {
        let table = ContactFormSubmissionTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
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
    ) async throws -> ContactFormSubmission? {
        let table = ContactFormSubmissionTable(connection: connection)
        return try await table.find(id: id).map { try $0.asDomain }
    }

    public func update(
        _ model: ContactFormSubmission
    ) async throws -> ContactFormSubmission {
        let table = ContactFormSubmissionTable(connection: connection)
        return
            try await table.update(id: model.id, status: model.status.rawValue)
            .asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        try await ContactFormSubmissionTable(connection: connection)
            .delete(id: id)
    }
}
