//
//  FrontendContentEditForm.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import FeatherCore

final class FrontendMetadataEditForm: Form {

    typealias Model = Metadata
    
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
    var module = StringFormField()
    var model = StringFormField()
    var reference = StringFormField()
    var slug = StringFormField()
    var title = StringFormField()
    var excerpt = StringFormField()
    var canonicalUrl = StringFormField()
    var statusId = StringSelectionFormField()
    var feedItem = StringSelectionFormField()
    var filters = StringArraySelectionFormField()
    var date = StringFormField()
    var image = FileFormField()
    var notification: String?
    
    var leafData: LeafData {
        .dictionary([
            "id": id,
            "module": module,
            "model": model,
            "reference": reference,
            "slug": slug,
            "title": title,
            "excerpt": excerpt,
            "canonicalUrl": canonicalUrl,
            "statusId": statusId,
            "feedItem": feedItem,
            "filters": filters,
            "date": date,
            "image": image,
            "notification": notification,
        ])
    }

    init() {
        initialize()
    }

    init(req: Request) throws {
        initialize()

        let context = try req.content.decode(Input.self)
        id = context.id.emptyToNil

        module.value = context.module
        model.value = context.model
        reference.value = context.reference
        slug.value = context.slug
        statusId.value = context.statusId
        filters.values = context.filters
        date.value = context.date
        title.value = context.title
        excerpt.value = context.excerpt
        canonicalUrl.value = context.canonicalUrl
        feedItem.value = context.feedItem

        image.delete = context.imageDelete ?? false
        if let img = context.image, let data = img.data.getData(at: 0, length: img.data.readableBytes), !data.isEmpty {
            image.data = data
        }
    }

    func initialize() {
        statusId.options = Model.Status.allCases.map(\.formFieldStringOption)
        statusId.value = Model.Status.draft.rawValue
        date.value = DateFormatter.ymd.string(from: Date())
        feedItem.options = FormFieldStringOption.trueFalse()
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if module.value.isEmpty {
            module.error = "Module is required"
            valid = false
        }
        if model.value.isEmpty {
            model.error = "Model is required"
            valid = false
        }
        if reference.value.isEmpty {
            reference.error = "Reference is required"
            valid = false
        }
        if Bool(feedItem.value) == nil {
            feedItem.error = "Invalid feed item value"
            valid = false
        }
        if Model.Status(rawValue: statusId.value) == nil {
            statusId.error = "Invalid status"
            valid = false
        }
        if DateFormatter.ymd.date(from: date.value) == nil {
            date.error = "Invalid date"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
    
    func read(from input: Model)  {
        id = input.id!.uuidString
        
        module.value = input.module
        model.value = input.model
        reference.value = input.reference.uuidString
        slug.value = input.slug
        statusId.value = input.status.rawValue
        feedItem.value = String(input.feedItem)
        filters.values = input.filters
        date.value = DateFormatter.ymd.string(from: input.date)
        
        title.value = input.title ?? ""
        excerpt.value = input.excerpt ?? ""
        canonicalUrl.value = input.canonicalUrl ?? ""
        image.value = input.imageKey ?? ""
    }

    func write(to output: Model) {
        output.module = module.value
        output.model = model.value
        output.reference = UUID(uuidString: reference.value)!
        output.slug = slug.value
        output.status = Model.Status(rawValue: statusId.value)!
        output.feedItem = Bool(feedItem.value)!
        output.filters = filters.values
        output.date = DateFormatter.ymd.date(from: date.value)!
        output.title = title.value.emptyToNil
        output.excerpt = excerpt.value.emptyToNil
        output.canonicalUrl = canonicalUrl.value.emptyToNil
    }
}
