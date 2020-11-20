//
//  SystemVariableModel.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

import Vapor
import Fluent
import ViperKit

final class SystemVariableModel: ViperModel {
    typealias Module = SystemModule

    static let name = "variables"

    struct FieldKeys {
        static var key: FieldKey { "key" }
        static var value: FieldKey { "value" }
        static var hidden: FieldKey { "hidden" }
        static var notes: FieldKey { "notes" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.key) var key: String
    @Field(key: FieldKeys.value) var value: String?
    @Field(key: FieldKeys.hidden) var hidden: Bool
    @Field(key: FieldKeys.notes) var notes: String?

    init() { }

    init(id: SystemVariableModel.IDValue? = nil,
         key: String,
         value: String? = nil,
         hidden: Bool = false,
         notes: String? = nil)
    {
        self.id = id
        self.key = key
        self.value = value
        self.hidden = hidden
        self.notes = notes
    }
}
