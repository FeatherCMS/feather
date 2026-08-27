import Foundation
import WebContracts

public struct NewsWebTemplateProvider: WebTemplateProvider {
    public let templates: [WebTemplateDefinition] = [
        .init(
            id: "news.article",
            title: "News article", path: "news/article/default"
        ),
        .init(
            id: "news.category",
            title: "News category", path: "news/category/default"
        ),
        .init(
            id: "news.articles",
            title: "News articles", path: "news/news"
        ),
        .init(
            id: "news.categories",
            title: "News categories", path: "news/categories"
        ),
    ]

    public init() {}

    public var bundledTemplatePaths: [URL] {
        [Bundle.module.url(forResource: "Templates", withExtension: nil)!]
    }
}
