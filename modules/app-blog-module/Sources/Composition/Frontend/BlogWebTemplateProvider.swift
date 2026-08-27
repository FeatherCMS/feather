import Foundation
import WebContracts

public struct BlogWebTemplateProvider: WebTemplateProvider {
    public let templates: [WebTemplateDefinition] = [
        .init(
            id: "blog.post",
            title: "Blog post", path: "blog/post/default"
        ),
        .init(
            id: "blog.author",
            title: "Blog author", path: "blog/author/default"
        ),
        .init(
            id: "blog.tag",
            title: "Blog tag", path: "blog/tag/default"
        ),
        .init(
            id: "blog.posts",
            title: "Blog posts", path: "blog/posts"
        ),
        .init(
            id: "blog.tags",
            title: "Blog tags", path: "blog/tags"
        ),
        .init(
            id: "blog.authors",
            title: "Blog authors", path: "blog/authors"
        ),
    ]

    public init() {}

    public var bundledTemplatePaths: [URL] {
        [Bundle.module.url(forResource: "Templates", withExtension: nil)!]
    }
}
