//
//  MenuModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

final class MenuModel: ViperModel {
    typealias Module = MenuModule

    static let name = "menus"
    
    struct FieldKeys {
        static var handle: FieldKey { "handle" }
        static var name: FieldKey { "name" }
        static var icon: FieldKey { "icon" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.handle) var handle: String
    @Field(key: FieldKeys.name) var name: String?
    @Field(key: FieldKeys.icon) var icon: String?
    @Children(for: \.$menu) var items: [MenuItemModel]
    
    init() { }
    
    init(id: IDValue? = nil,
         handle: String,
         name: String? = nil,
         icon: String? = nil)
    {
        self.id = id
        self.handle = handle
        self.name = name
        self.icon = icon
    }
}
