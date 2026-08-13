import WebApplication

public struct NewsWebTemplateProvider: WebTemplateProvider {
    public let templates: [WebTemplateDefinition] = [
        .init(
            id: "news.article",
            title: "News article"
        ),
        .init(
            id: "news.category",
            title: "News category"
        ),
        .init(
            id: "news.articles",
            title: "News articles"
        ),
        .init(
            id: "news.categories",
            title: "News categories"
        ),
    ]

    public init() {}
}
