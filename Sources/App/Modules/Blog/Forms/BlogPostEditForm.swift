//
//  BlogPostEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 02. 15..
//

import FeatherCore

final class BlogPostEditForm: ModelForm {

    typealias Model = BlogPostModel

    struct Input: Decodable {
        var modelId: String
        var title: String
        var excerpt: String
        var content: String
        var categoryId: String
        var authorId: String
        var image: File?
    }

    var modelId: String? = nil
    var title = StringFormField()
    var excerpt = StringFormField()
    var content = StringFormField()
    var categoryId = StringSelectionFormField()
    var authorId = StringSelectionFormField()
    var image = FileFormField()
    var notification: String?
    var metadata: Metadata?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "title": title,
            "excerpt": excerpt,
            "content": content,
            "categoryId": categoryId,
            "authorId": authorId,
            "image": image,
            "notification": notification,
            "metadata": metadata,
        ])
    }
    
    init() {}
    
    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        title.value = context.title
        excerpt.value = context.excerpt
        content.value = context.content
        categoryId.value = context.categoryId
        authorId.value = context.authorId
        if let img = context.image, let data = img.data.getData(at: 0, length: img.data.readableBytes), !data.isEmpty {
            image.data = data
        }
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
        if title.value.isEmpty {
            title.error = "Title is required"
            valid = false
        }
        if Validator.count(...250).validate(title.value).isFailure {
            title.error = "Title is too long (max 250 characters)"
            valid = false
        }
        if UUID(uuidString: categoryId.value) == nil {
            categoryId.error = "Invalid category"
            valid = false
        }
        if UUID(uuidString: authorId.value) == nil {
            authorId.error = "Invalid author"
            valid = false
        }
        if modelId == nil && image.data == nil {
            image.error = "Image is required"
            valid = false
        }
        return req.eventLoop.future(valid)
    }
    
    func read(from input: Model)  {
        modelId = input.id?.uuidString
        title.value = input.title
        image.value = input.imageKey
        excerpt.value = input.excerpt
        content.value = input.content
        categoryId.value = input.$category.id.uuidString
        authorId.value = input.$author.id.uuidString
    }
    
    func write(to output: Model) {
        output.title = title.value
        if !image.value.isEmpty {
            output.imageKey = image.value
        }
        output.excerpt = excerpt.value
        output.content = content.value
        output.$category.id = UUID(uuidString: categoryId.value)!
        output.$author.id = UUID(uuidString: authorId.value)!
    }
}
