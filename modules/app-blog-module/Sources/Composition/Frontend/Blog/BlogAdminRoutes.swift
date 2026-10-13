import FeatherAdmin
import Hummingbird

enum BlogAdminRoutes {
    static let admin = RouterPath("admin")
    static let blog = admin.appendingPath(RouterPath("blog"))
    static let posts = blog.appendingPath(RouterPath("posts"))
    static let authors = blog.appendingPath(RouterPath("authors"))
    static let tags = blog.appendingPath(RouterPath("tags"))

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Blog", link: blog.description + "/"),
    ]

    static let postsBreadcrumb =
        breadcrumb + [
            .init(label: "Posts", link: posts.description + "/")
        ]
    static let authorsBreadcrumb =
        breadcrumb + [
            .init(label: "Authors", link: authors.description + "/")
        ]
    static let tagsBreadcrumb =
        breadcrumb + [
            .init(label: "Tags", link: tags.description + "/")
        ]

    static func post(_ id: RouterPath) -> RouterPath { posts.appendingPath(id) }
    static func postAdd() -> RouterPath {
        posts.appendingPath(RouterPath("add"))
    }
    static func postRemove() -> RouterPath {
        posts.appendingPath(RouterPath("remove"))
    }
    static func postRemove(_ id: RouterPath) -> RouterPath {
        post(id).appendingPath(RouterPath("remove"))
    }
    static func postEdit(_ id: RouterPath) -> RouterPath {
        post(id).appendingPath(RouterPath("edit"))
    }
    static func postStatus(_ id: RouterPath) -> RouterPath {
        post(id).appendingPath(RouterPath("status"))
    }

    static func author(_ id: RouterPath) -> RouterPath {
        authors.appendingPath(id)
    }
    static func authorAdd() -> RouterPath {
        authors.appendingPath(RouterPath("add"))
    }
    static func authorRemove() -> RouterPath {
        authors.appendingPath(RouterPath("remove"))
    }
    static func authorRemove(_ id: RouterPath) -> RouterPath {
        author(id).appendingPath(RouterPath("remove"))
    }
    static func authorEdit(_ id: RouterPath) -> RouterPath {
        author(id).appendingPath(RouterPath("edit"))
    }
    static func authorStatus(_ id: RouterPath) -> RouterPath {
        author(id).appendingPath(RouterPath("status"))
    }
    static func authorLinks(_ id: RouterPath) -> RouterPath {
        author(id).appendingPath(RouterPath("links"))
    }
    static func authorLinksBreadcrumb(_ id: RouterPath) -> [NewAdminBreadcrumb
        .Link]
    {
        authorsBreadcrumb + [
            .init(label: "Links", link: authorLinks(id).description + "/")
        ]
    }

    static func tag(_ id: RouterPath) -> RouterPath { tags.appendingPath(id) }
    static func tagAdd() -> RouterPath { tags.appendingPath(RouterPath("add")) }
    static func tagRemove() -> RouterPath {
        tags.appendingPath(RouterPath("remove"))
    }
    static func tagRemove(_ id: RouterPath) -> RouterPath {
        tag(id).appendingPath(RouterPath("remove"))
    }
    static func tagEdit(_ id: RouterPath) -> RouterPath {
        tag(id).appendingPath(RouterPath("edit"))
    }
    static func tagStatus(_ id: RouterPath) -> RouterPath {
        tag(id).appendingPath(RouterPath("status"))
    }

    static func authorLink(_ authorID: RouterPath, _ id: RouterPath)
        -> RouterPath
    {
        authorLinks(authorID).appendingPath(id)
    }
    static func authorLinkAdd(_ authorID: RouterPath) -> RouterPath {
        authorLinks(authorID).appendingPath(RouterPath("add"))
    }
    static func authorLinkRemove(_ authorID: RouterPath) -> RouterPath {
        authorLinks(authorID).appendingPath(RouterPath("remove"))
    }
    static func authorLinkEdit(_ authorID: RouterPath, _ id: RouterPath)
        -> RouterPath
    {
        authorLink(authorID, id).appendingPath(RouterPath("edit"))
    }
}
