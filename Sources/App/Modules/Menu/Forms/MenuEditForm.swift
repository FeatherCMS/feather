//
//  MenuEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

final class MenuEditForm: ModelForm {

    typealias Model = MenuModel

    struct Input: Decodable {
        var modelId: String
        var handle: String
        var name: String
        var icon: String
    }

    var modelId: String? = nil
    var handle = StringFormField()
    var name = StringFormField()
    var icon = StringFormField()
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "handle": handle,
            "name": name,
            "icon": icon,
            "notification": notification,
        ])
    }
        
    init() {}

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        handle.value = context.handle
        name.value = context.name
        icon.value = context.icon
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        /// TODO: check unique handle.
        if handle.value.isEmpty {
            handle.error = "Handle is required"
            valid = false
        }
        if Validator.count(...250).validate(handle.value).isFailure {
            handle.error = "Handle is too long (max 250 characters)"
            valid = false
        }
        if Validator.count(...250).validate(name.value).isFailure {
            name.error = "Name is too long (max 250 characters)"
            valid = false
        }
        if Validator.count(...250).validate(icon.value).isFailure {
            icon.error = "Icon is too long (max 250 characters)"
            valid = false
        }

        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        modelId = input.id?.uuidString
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
