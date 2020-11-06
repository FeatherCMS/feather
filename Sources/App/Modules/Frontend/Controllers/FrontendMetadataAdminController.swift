//
//  FrontendContentAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import FeatherCore

extension Metadata: ViperModel {
    public static var name: String { "metadatas" }

    public typealias Module = FrontendModule
}

struct FrontendMetadataAdminController: ViperAdminViewController {
    
    typealias Module = FrontendModule
    typealias Model = Metadata
    typealias EditForm = FrontendMetadataEditForm
    
    private func path(_ model: Model) -> String {
        let date = DateFormatter.asset.string(from: Date())
        return Model.path + model.id!.uuidString + "_" + date + ".jpg"
    }

    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
        let filters = req.application.viper.invokeAllSyncHooks(name: "content-filter",
                                                               req: req,
                                                               type: [ContentFilter].self)

        form.filters.options = filters.flatMap { $0 }.map(\.formFieldStringOption)
        return req.eventLoop.future()
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
            future = req.fs.delete(key: key).map { model }
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
