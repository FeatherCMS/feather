//
//  FrontendContentEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Vapor
import ViewKit

final class FrontendContentEditForm: Form {

    typealias Model = FrontendContentModel
    
    struct Input: Decodable {
        var id: String
        var module: String
        var model: String
        var reference: String
        var slug: String
        var title: String
        var excerpt: String
        var canonicalUrl: String
        var statusId: String
        var filters: [String]
        var date: String
        var feedItem: String

        var image: File?
        var imageDelete: Bool?
    }

    var id: String? = nil
    var module = BasicFormField()
    var model = BasicFormField()
    var reference = BasicFormField()
    var slug = BasicFormField()
    var title = BasicFormField()
    var excerpt = BasicFormField()
    var canonicalUrl = BasicFormField()
    var statusId = SelectionFormField()
    var feedItem = SelectionFormField()
    var filters = OptionListFormField()
    var date = BasicFormField()
    var image = FileFormField()
    
    var notification: String?

    init() {
        self.initialize()
    }

    init(req: Request) throws {
        self.initialize()

        let context = try req.content.decode(Input.self)
        self.id = context.id.emptyToNil

        self.module.value = context.module
        self.model.value = context.model
        self.reference.value = context.reference
        self.slug.value = context.slug
        self.statusId.value = context.statusId
        self.filters.values = context.filters
        self.date.value = context.date
        self.title.value = context.title
        self.excerpt.value = context.excerpt
        self.canonicalUrl.value = context.canonicalUrl
        self.feedItem.value = context.feedItem

        self.image.delete = context.imageDelete ?? false
        if let image = context.image {
            if let data = image.data.getData(at: 0, length: image.data.readableBytes), !data.isEmpty {
                self.image.data = data
            }
        }
    }

    func initialize() {
        self.statusId.options = Model.Status.allCases.map(\.formFieldOption)
        self.statusId.value = Model.Status.draft.rawValue
        self.date.value = DateFormatter.ymd.string(from: Date())
        self.feedItem.options = FormFieldOption.trueFalse()
        
    }
    
    func read(from model: Model)  {
        self.id = model.id!.uuidString
        
        self.module.value = model.module
        self.model.value = model.model
        self.reference.value = model.reference.uuidString
        self.slug.value = model.slug
        self.statusId.value = model.status.rawValue
        self.feedItem.value = String(model.feedItem)
        self.filters.values = model.filters
        self.date.value = DateFormatter.ymd.string(from: model.date)
        
        self.title.value = model.title ?? ""
        self.excerpt.value = model.excerpt ?? ""
        self.canonicalUrl.value = model.canonicalUrl ?? ""
        self.image.value = model.imageKey ?? ""
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if self.module.value.isEmpty {
            self.module.error = "Module is required"
            valid = false
        }
        if self.model.value.isEmpty {
            self.model.error = "Model is required"
            valid = false
        }
        if self.reference.value.isEmpty {
            self.reference.error = "Reference is required"
            valid = false
        }
        if Bool(self.feedItem.value) == nil {
            self.feedItem.error = "Invalid feed item value"
            valid = false
        }
        if Model.Status(rawValue: self.statusId.value) == nil {
            self.statusId.error = "Invalid status"
            valid = false
        }
        if DateFormatter.ymd.date(from: self.date.value) == nil {
            self.date.error = "Invalid date"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
    
    func write(to model: Model) {
        model.module = self.module.value
        model.model = self.model.value
        model.reference = UUID(uuidString: self.reference.value)!
        model.slug = self.slug.value
        model.status = Model.Status(rawValue: self.statusId.value)!
        model.feedItem = Bool(self.feedItem.value)!
        model.filters = self.filters.values
        model.date = DateFormatter.ymd.date(from: self.date.value)!
        model.title = self.title.value.emptyToNil
        model.excerpt = self.excerpt.value.emptyToNil
        model.canonicalUrl = self.canonicalUrl.value.emptyToNil
    }
}
