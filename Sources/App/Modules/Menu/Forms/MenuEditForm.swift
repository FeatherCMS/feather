//
//  MenuEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Vapor
import ViewKit

final class MenuEditForm: Form {

    typealias Model = MenuModel

    struct Input: Decodable {
        var id: String
        var handle: String
        var name: String?
        var icon: String?
    }

    var id: String? = nil
    var handle = StringFormField()
    var name = StringFormField()
    var icon = StringFormField()
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "handle": handle,
            "name": name,
            "icon": icon,
            "notification": notification,
        ])
    }
        
    init() {}

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        id = context.id.emptyToNil

        handle.value = context.handle
        name.value = context.name ?? ""
        icon.value = context.icon ?? ""
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        /// TODO: check unique handle.
        if handle.value.isEmpty {
            handle.error = "Handle is required"
            valid = false
        }

        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        id = input.id!.uuidString
        handle.value = input.handle
        name.value = input.name ?? ""
        icon.value = input.icon ?? ""
    }

    func write(to output: Model) {
        output.handle = handle.value
        output.name = name.value.emptyToNil
        output.icon = icon.value.emptyToNil
    }
}
