import FeatherWebAdmin
public import FeatherWebShared
import MediaWebAdmin

extension Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let news: WebRoute
        public let articles: WebRoute
        public let categories: WebRoute
        let mediaAssetList: WebRoute

        public init(
            admin: WebRoute,
            mediaAssetList: WebRoute? = nil
        ) {
            self.admin = admin
            self.news = admin.appending(pathComponent: "news")
            self.articles = news.appending(pathComponent: "articles")
            self.categories = news.appending(pathComponent: "categories")
            self.mediaAssetList =
                mediaAssetList ?? MediaWebAdmin.Routes.standard.assetList
        }

        public static let standard = Routes(
            admin: .root.appending(pathComponent: "admin"),
            mediaAssetList: MediaWebAdmin.Routes.standard.assetList
        )

        var breadcrumb: [AdminBreadcrumb.Link] {
            [
                .init(label: "Admin", link: admin.path),
                .init(label: "News", link: news.path),
            ]
        }
    }
}
