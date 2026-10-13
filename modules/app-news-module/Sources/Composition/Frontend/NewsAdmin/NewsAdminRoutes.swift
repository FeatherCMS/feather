import FeatherAdmin
import Hummingbird

enum NewsAdminRoutes {
    static let admin = RouterPath("admin")
    static let news = admin.appendingPath(RouterPath("news"))
    static let articles = news.appendingPath(RouterPath("articles"))
    static let categories = news.appendingPath(RouterPath("categories"))

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "News", link: news.description + "/"),
    ]

    static let articlesBreadcrumb =
        breadcrumb + [
            .init(label: "Articles", link: articles.description + "/")
        ]

    static let categoriesBreadcrumb =
        breadcrumb + [
            .init(label: "Categories", link: categories.description + "/")
        ]

    static func article(
        _ id: RouterPath
    ) -> RouterPath {
        articles.appendingPath(id)
    }

    static func articleAdd() -> RouterPath {
        articles.appendingPath(RouterPath("add"))
    }

    static func articleEdit(
        _ id: RouterPath
    ) -> RouterPath {
        article(id).appendingPath(RouterPath("edit"))
    }

    static func articleRemove(
        _ id: RouterPath
    ) -> RouterPath {
        article(id).appendingPath(RouterPath("remove"))
    }

    static func category(
        _ id: RouterPath
    ) -> RouterPath {
        categories.appendingPath(id)
    }

    static func categoryAdd() -> RouterPath {
        categories.appendingPath(RouterPath("add"))
    }

    static func categoryEdit(
        _ id: RouterPath
    ) -> RouterPath {
        category(id).appendingPath(RouterPath("edit"))
    }

    static func categoryRemove(
        _ id: RouterPath
    ) -> RouterPath {
        category(id).appendingPath(RouterPath("remove"))
    }
}
