import FeatherWebAdmin
public import FeatherWebShared

extension Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let news: WebRoute
        public let articles: WebRoute
        public let categories: WebRoute

        public init(admin: WebRoute) {
            self.admin = admin
            self.news = admin.appending(pathComponent: "news")
            self.articles = news.appending(pathComponent: "articles")
            self.categories = news.appending(pathComponent: "categories")
        }

        public static let standard = Routes(
            admin: .root.appending(pathComponent: "admin")
        )

        var breadcrumb: [AdminBreadcrumb.Link] {
            [
                .init(label: "Admin", link: admin.path),
                .init(label: "News", link: news.path),
            ]
        }
    }
}
