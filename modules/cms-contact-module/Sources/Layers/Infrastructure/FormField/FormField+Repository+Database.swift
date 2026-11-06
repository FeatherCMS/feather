public import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation

extension FormField.Table.Detail {
    func asDomain(formId: String, position: Int) throws -> FormField.Model {
        guard let type = FormField.Model.ItemType(rawValue: type) else {
            throw RepositoryError.invalidEnumValue(type)
        }
        let allowedValues = try JSONDecoder()
            .decode(
                [FormField.Model.Option].self,
                from: Data(allowedValues.utf8)
            )
        return .init(
            id: id,
            formId: formId,
            key: key,
            type: type,
            label: label,
            allowedValues: allowedValues,
            isRequired: isRequired,
            position: position,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension FormField.Table.List {
    func asDomain(formId: String, position: Int) throws -> FormField.Model {
        try FormField.Table
            .Detail(
                id: id,
                key: key,
                type: type,
                label: label,
                allowedValues: allowedValues,
                isRequired: isRequired,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
            .asDomain(formId: formId, position: position)
    }
}

extension FormField.AccessLayer.Row {
    var asDomain: FormField.Model {
        get throws {
            guard let type = FormField.Model.ItemType(rawValue: type) else {
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

extension FormField.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<FormField.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func insert(_ model: FormField.Model.New) async throws
            -> FormField.Model
        {
            let row = FormField.Table.Insert(
                id: context.idGenerator.generate(),
                key: model.key,
                type: model.type.rawValue,
                label: model.label,
                allowedValues: model.allowedValues,
                isRequired: model.isRequired
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
            return try saved.asDomain(
                formId: model.formId,
                position: model.position
            )
        }

        public func findBy(id: String, formId: String?) async throws
            -> FormField.Model?
        {
            if let formId {
                return
                    try await FormField.AccessLayer(
                        connection: context.connection
                    )
                    .find(id: id, formId: formId)
                    .map { try $0.asDomain }
            }
            return try await accessLayer.selectFirst(by: \.id, equals: id)
                .map { try $0.asDomain(formId: "", position: 0) }
        }

        public func listBy(formId: String?) async throws -> [FormField.Model] {
            if let formId {
                return
                    try await FormField.AccessLayer(
                        connection: context.connection
                    )
                    .list(formId: formId)
                    .map { try $0.asDomain }
            }
            return try await accessLayer.select { $0.order(by: \.id) }
                .map { try $0.asDomain(formId: "", position: 0) }
        }

        public func listUnassigned() async throws -> [FormField.Model] {
            try await FormField.AccessLayer(connection: context.connection)
                .listUnassigned()
                .map { try $0.asDomain }
        }

        public func assign(formId: String, fieldId: String, position: Int)
            async throws
        {
            try await FormFieldAssignment.Table(
                connection: context.connection,
                context: context
            )
            .assign(
                formId: formId,
                fieldId: fieldId,
                position: position
            )
        }

        public func unassign(formId: String, fieldId: String) async throws {
            try await FormFieldAssignment.Table(
                connection: context.connection,
                context: context
            )
            .unassign(
                formId: formId,
                fieldId: fieldId
            )
        }

        public func update(_ model: FormField.Model) async throws
            -> FormField.Model
        {
            try await accessLayer.update(
                .init(
                    key: model.key,
                    type: model.type.rawValue,
                    label: model.label,
                    allowedValues: model.allowedValues,
                    isRequired: model.isRequired
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
            return try updated.asDomain(
                formId: model.formId,
                position: model.position
            )
        }

        public func delete(ids: [String], formId: String?) async throws
            -> [String]
        {
            guard let formId else {
                guard !ids.isEmpty else { return [] }
                let existingIDs =
                    try await accessLayer.select {
                        $0.where(\.id, in: ids)
                    }
                    .map(\.id)
                try await accessLayer.delete(where: \.id, in: ids)
                return existingIDs
            }
            return
                try await FormField.AccessLayer(connection: context.connection)
                .delete(ids: ids, formId: formId)
        }
    }
}
