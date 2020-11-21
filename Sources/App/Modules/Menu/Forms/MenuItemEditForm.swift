//
//  MenuEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

final class MenuItemEditForm: ModelForm {

    typealias Model = MenuItemModel

    struct Input: Decodable {
        var modelId: String
        var icon: String
        var label: String
        var url: String
        var priority: String
        var targetBlank: String
        var menuId: String
    }

    var modelId: String? = nil
    var icon = StringFormField()
    var label = StringFormField()
    var url = StringFormField()
    var priority = StringFormField()
    var targetBlank = StringSelectionFormField()
    var menuId: String! = nil
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "icon": icon,
            "label": label,
            "url": url,
            "priority": priority,
            "targetBlank": targetBlank,
            "menuId": menuId,
            "notification": notification,
        ])
    }
    
    init() {
        initialize()
    }

    init(req: Request) throws {
        initialize()

        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        icon.value = context.icon
        label.value = context.label
        url.value = context.url
        priority.value = context.priority
        targetBlank.value = context.targetBlank
        menuId = context.menuId
    }

    func initialize() {
        targetBlank.options = FormFieldStringOption.trueFalse()
        targetBlank.value = String(false)
        priority.value = String(100)
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if label.value.isEmpty {
            label.error = "Label is required"
            valid = false
        }
        if Validator.count(...250).validate(label.value).isFailure {
            label.error = "Label is too long (max 250 characters)"
            valid = false
        }
        if url.value.isEmpty {
            url.error = "Url is required"
            valid = false
        }
        if Validator.count(...250).validate(url.value).isFailure {
            url.error = "URL is too long (max 250 characters)"
            valid = false
        }
        if Int(priority.value) == nil {
            priority.error = "Invalid priority"
            valid = false
        }
        if Bool(targetBlank.value) == nil {
            targetBlank.error = "Invalid target"
            valid = false
        }

        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        modelId = input.id?.uuidString
        icon.value = input.icon ?? ""
        label.value = input.label
        url.value = input.url
        priority.value = String(input.priority)
        targetBlank.value = String(input.targetBlank)
        menuId = input.$menu.id.uuidString
    }

    func write(to output: Model) {
        output.icon = icon.value.emptyToNil
        output.label = label.value
        output.url = url.value
        output.priority = Int(priority.value)!
        output.targetBlank = Bool(targetBlank.value)!
        output.$menu.id = UUID(uuidString: menuId)!
    }
}
