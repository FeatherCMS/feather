public import Foundation
public import WebModule

public struct NewsWebTemplateProvider: WebModule.Template.Provider {
    public let templates: [WebModule.Template.Definition] = [
        .init(
            id: "news.article",
            title: "News article",
            path: "news/article"
        ),
        .init(
            id: "news.category",
            title: "News category",
            path: "news/category"
        ),
        .init(
            id: "news.articles",
            title: "News articles",
            path: "news/articles"
        ),
        .init(
            id: "news.categories",
            title: "News categories",
            path: "news/categories"
        ),
    ]

    public init() {}

    public var bundledTemplatePaths: [URL] {
        [Bundle.module.url(forResource: "Templates", withExtension: nil)!]
    }
}
