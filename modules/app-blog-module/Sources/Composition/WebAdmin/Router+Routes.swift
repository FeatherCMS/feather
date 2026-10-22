public import BlogModule
public import FeatherWebAdmin

extension Router {
    public struct Routes: Sendable {
        public let blog: WebRoute
        public let breadcrumb: [AdminBreadcrumb.Link]
        public let post: Post.Router.Routes
        public let author: Author.Router.Routes
        public let authorLink: AuthorLink.Router.Routes
        public let tag: Tag.Router.Routes
        public let settings: Settings.Router.Routes

        public static let standard = Self(
            root: WebRoute.root.appending(pathComponent: "admin")
        )

        public init(root: WebRoute) {
            let blog = root.appending(pathComponent: "blog")
            let breadcrumb: [AdminBreadcrumb.Link] = [
                .init(label: "Admin", link: root.path),
                .init(label: "Blog", link: blog.path),
            ]

            self.blog = blog
            self.breadcrumb = breadcrumb
            self.post = .init(root: blog, breadcrumb: breadcrumb)
            self.author = .init(root: blog, breadcrumb: breadcrumb)
            self.authorLink = .init(
                root: blog.appending(pathComponent: "authors"),
                breadcrumb: self.author.authorsBreadcrumb
            )
            self.tag = .init(root: blog, breadcrumb: breadcrumb)
            self.settings = .init(root: blog, breadcrumb: breadcrumb)
        }
    }
}
