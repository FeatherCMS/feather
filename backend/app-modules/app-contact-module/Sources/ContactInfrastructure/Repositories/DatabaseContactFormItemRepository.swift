import ContactDomain
import FeatherDatabase
import Infrastructure

extension ContactFormFieldTable.Row {
    var asDomain: ContactFormItem {
        get throws {
            guard let type = ContactFormItem.ItemType(rawValue: type) else {
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

public struct DatabaseContactFormItemRepository: ContactFormItemRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: ContactFormItem.New
    ) async throws -> ContactFormItem {
        let table = ContactFormFieldTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                formId: model.formId,
                key: model.key,
                type: model.type.rawValue,
                label: model.label,
                allowedValuesJSON: try ContactFormItem.Option.jsonString(
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
    ) async throws -> ContactFormItem? {
        let table = ContactFormFieldTable(connection: connection)
        return try await table.find(id: id, formId: formId)
            .map { try $0.asDomain }
    }

    public func listBy(
        formId: String?
    ) async throws -> [ContactFormItem] {
        let table = ContactFormFieldTable(connection: connection)
        return try await table.list(formId: formId).map { try $0.asDomain }
    }

    public func assign(
        formId: String,
        itemId: String,
        position: Int
    ) async throws {
        try await ContactFormFormFieldTable(connection: connection)
            .assign(
                formId: formId,
                fieldId: itemId,
                position: position
            )
    }

    public func unassign(
        formId: String,
        itemId: String
    ) async throws {
        try await ContactFormFormFieldTable(connection: connection)
            .unassign(
                formId: formId,
                fieldId: itemId
            )
    }

    public func update(
        _ model: ContactFormItem
    ) async throws -> ContactFormItem {
        let table = ContactFormFieldTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                formId: model.formId,
                key: model.key,
                type: model.type.rawValue,
                label: model.label,
                allowedValuesJSON: try ContactFormItem.Option.jsonString(
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
        id: String,
        formId: String?
    ) async throws -> Bool {
        let table = ContactFormFieldTable(connection: connection)
        return try await table.delete(id: id, formId: formId)
    }
}
