import WebApplication
import BlogFrontend
import NewsFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
import WebApplication

struct WebTemplateRegistry: Sendable {

    static let shared = WebTemplateRegistry(
        providers: [
            BlogWebTemplateProvider(),
            NewsWebTemplateProvider(),
        ]
    )

    let definitions: [WebTemplateDefinition]
    private let templatePaths: [String: String]

    init(providers: [any WebTemplateProvider]) {
        let builtInDefinitions: [WebTemplateDefinition] = [
            .init(id: "default", title: "Default"),
            .init(id: "home", title: "Home"),
            .init(id: "not-found", title: "Not found"),
            .init(id: "debug", title: "Debug"),
        ]
        definitions = builtInDefinitions + providers.flatMap(\.templates)
        let templatePaths: [String: String] = [
            "default": "pages/default",
            "home": "pages/home",
            "not-found": "pages/not-found",
            "debug": "pages/debug",
            "blog.post": "blog/post/default",
            "blog.author": "blog/author/default",
            "blog.tag": "blog/tag/default",
            "blog.posts": "blog/posts",
            "blog.tags": "blog/tags",
            "blog.authors": "blog/authors",
            "news.article": "news/article/default",
            "news.category": "news/category/default",
            "news.articles": "news/news",
            "news.categories": "news/categories",
        ]
        self.templatePaths = templatePaths
    }

    func definition(for id: String) -> WebTemplateDefinition? {
        definitions.first { $0.id == id }
    }

    func templatePath(for id: String) -> String? {
        templatePaths[id]
    }
}
