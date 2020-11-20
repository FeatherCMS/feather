//
//  BlogCategoryAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Fluent
import FeatherCore

struct BlogCategoryAdminController: ViperAdminViewController {

    typealias Module = BlogModule
    typealias Model = BlogCategoryModel
    typealias EditForm = BlogCategoryEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.title,
        Model.FieldKeys.priority,
    ]

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$title ~~ searchTerm)
    }
    
    private func path(_ model: Model) -> String {
        Model.path + model.id!.uuidString + ".jpg"
    }
    
    
    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
        var future: EventLoopFuture<Void> = req.eventLoop.future()
        if let id = form.modelId, let uuid = UUID(uuidString: id) {
            future = findMetadata(on: req.db, uuid: uuid).map { form.metadata = $0 }
        }
        return future
    }
    
    func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        model.id = UUID()
        var future: EventLoopFuture<Model> = req.eventLoop.future(model)
        if let data = form.image.data {
            let key = path(model)
            future = req.fs.upload(key: key, data: data).map { url in
                //form.image.value = url
                model.imageKey = key
                return model
            }
        }
        return future
    }
    
    func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        let key = path(model)
        var future: EventLoopFuture<Model> = req.eventLoop.future(model)
        if
            (form.image.delete || form.image.data != nil),
            FileManager.default.fileExists(atPath: req.fs.resolve(key: key))
        {
            future = req.fs.delete(key: key).map {
                form.image.value = ""
                return model
            }
        }
        if let data = form.image.data {
            return future.flatMap { model in
                return req.fs.upload(key: key, data: data).map { url in
                    //form.image.value = url
                    model.imageKey = key
                    return model
                }
            }
        }
        return future
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: path(model)).map { model }
    }    
}
