import WebApplication

public struct BlogWebTemplateProvider: WebTemplateProvider {
    public let templates: [WebTemplateDefinition] = [
        .init(
            id: "blog.post",
            title: "Blog post"
        ),
        .init(
            id: "blog.author",
            title: "Blog author"
        ),
        .init(
            id: "blog.tag",
            title: "Blog tag"
        ),
        .init(
            id: "blog.posts",
            title: "Blog posts"
        ),
        .init(
            id: "blog.tags",
            title: "Blog tags"
        ),
        .init(
            id: "blog.authors",
            title: "Blog authors"
        ),
    ]

    public init() {}
}
