import ContactDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension FormFieldTable.Row {
    var asDomain: FormField {
        get throws {
            guard let type = FormField.ItemType(rawValue: type) else {
                throw RepositoryError.invalidEnumValue(type)
            }
            return .init(
                id: id,
                formId: formId,
                key: key,
                type: type,
                label: label,
                allowedValues: try allowedValues(),
                isRequired: isRequired,
                position: position,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

public struct FormFieldDatabaseRepository: FormFieldRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: FormField.New
    ) async throws -> FormField {
        let table = FormFieldTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                formId: model.formId,
                key: model.key,
                type: model.type.rawValue,
                label: model.label,
                allowedValuesJSON: try FormField.Option.jsonString(
                    model.allowedValues
                ),
                isRequired: model.isRequired,
                position: model.position
            )
        )
        return try saved.asDomain
    }

    public func findBy(
        id: String,
        formId: String?
    ) async throws -> FormField? {
        let table = FormFieldTable(connection: context.connection)
        return try await table.find(id: id, formId: formId)
            .map { try $0.asDomain }
    }

    public func listBy(
        formId: String?
    ) async throws -> [FormField] {
        let table = FormFieldTable(connection: context.connection)
        return try await table.list(formId: formId).map { try $0.asDomain }
    }

    public func assign(
        formId: String,
        fieldId: String,
        position: Int
    ) async throws {
        try await FormFormFieldTable(connection: context.connection)
            .assign(
                formId: formId,
                fieldId: fieldId,
                position: position
            )
    }

    public func unassign(
        formId: String,
        fieldId: String
    ) async throws {
        try await FormFormFieldTable(connection: context.connection)
            .unassign(
                formId: formId,
                fieldId: fieldId
            )
    }

    public func update(
        _ model: FormField
    ) async throws -> FormField {
        let table = FormFieldTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                formId: model.formId,
                key: model.key,
                type: model.type.rawValue,
                label: model.label,
                allowedValuesJSON: try FormField.Option.jsonString(
                    model.allowedValues
                ),
                isRequired: model.isRequired,
                position: model.position,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return try updated.asDomain
    }

    public func delete(
        ids: [String],
        formId: String?
    ) async throws -> [String] {
        let table = FormFieldTable(connection: context.connection)
        return try await table.delete(ids: ids, formId: formId)
    }
}
