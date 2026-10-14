//
//  VariableTable.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

struct VariableTable: 
    DatabaseTable,
    DatabaseTableWithPrimaryKey,
    DatabaseTableWithFind,
    DatabaseTableWithInsert,
    DatabaseTableWithList,
    DatabaseTableWithUpdate,
    DatabaseTableWithBulkDelete,
{
    static let name = "system_variable"

    static let primaryKey = "id"
    static let primaryKeyField = Fields.id

    enum Fields {
        static let id = DatabaseField<String>("id")
        static let key = DatabaseField<String>("key")
        static let value = DatabaseField<String>("value")
        static let name = DatabaseField<String?>("name")
        static let notes = DatabaseField<String?>("notes")
        static let createdAt = DatabaseField<Date>("created_at")
        static let updatedAt = DatabaseField<Date>("updated_at")
    }

    struct Row {

        fileprivate typealias Fields = VariableTable.Fields

        struct Create: DatabaseEncodable {
            let id: String
            let key: String
            let value: String
            let name: String?
            let notes: String?

            func encode(to encoder: inout DatabaseFieldEncoder) {
                encoder.encode(id, for: Fields.id)
                encoder.encode(key, for: Fields.key)
                encoder.encode(name, for: Fields.name)
                encoder.encode(value, for: Fields.value)
                encoder.encode(notes, for: Fields.notes)
            }
        }

        struct Update: DatabaseEncodable {
            let key: String
            let value: String
            let name: String?
            let notes: String?

            func encode(to encoder: inout DatabaseFieldEncoder) {
                encoder.encode(key, for: Fields.key)
                encoder.encode(name, for: Fields.name)
                encoder.encode(value, for: Fields.value)
                encoder.encode(notes, for: Fields.notes)
                encoder.encode(.currentTimestamp, for: Fields.updatedAt)
            }
        }

        struct List: DatabaseDecodable {
            let id: String
            let key: String
            let value: String
            let name: String?
            let notes: String?
            let createdAt: Date
            let updatedAt: Date

            init(
                from decoder: DatabaseRowDecoder,
                row: any DatabaseRow
            ) throws {
                self.id = try decoder.decode(Fields.id, from: row)
                self.key = try decoder.decode(Fields.key, from: row)
                self.value = try decoder.decode(Fields.value, from: row)
                self.name = try decoder.decode(Fields.name, from: row)
                self.notes = try decoder.decode(Fields.notes, from: row)
                self.createdAt = try decoder.decode(Fields.createdAt, from: row)
                self.updatedAt = try decoder.decode(Fields.updatedAt, from: row)
            }
        }

        struct Detail: DatabaseDecodable {
            let id: String
            let key: String
            let value: String
            let name: String?
            let notes: String?
            let createdAt: Date
            let updatedAt: Date

            init(
                from decoder: DatabaseRowDecoder,
                row: any DatabaseRow
            ) throws {
                self.id = try decoder.decode(Fields.id, from: row)
                self.key = try decoder.decode(Fields.key, from: row)
                self.value = try decoder.decode(Fields.value, from: row)
                self.name = try decoder.decode(Fields.name, from: row)
                self.notes = try decoder.decode(Fields.notes, from: row)
                self.createdAt = try decoder.decode(Fields.createdAt, from: row)
                self.updatedAt = try decoder.decode(Fields.updatedAt, from: row)
            }
        }
    }

    let connection: any DatabaseConnection

}
