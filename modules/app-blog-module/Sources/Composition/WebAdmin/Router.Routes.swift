public import BlogModule
public import FeatherWebAdmin
public import FeatherWebShared
import MediaWebAdmin

extension Router {
    public struct Routes: Sendable {
        public let blog: WebRoute
        let mediaAssetList: WebRoute
        public let breadcrumb: [AdminBreadcrumb.Link]
        public let post: Post.Routes
        public let author: Author.Routes
        public let authorLink: AuthorLink.Routes
        public let tag: Tag.Routes
        public let settings: Settings.Routes

        public static let standard = Self(
            root: WebRoute.root.appending(pathComponent: "admin"),
            mediaAssetList: MediaWebAdmin.Routes.standard.assetList
        )

        public init(
            root: WebRoute,
            mediaAssetList: WebRoute? = nil
        ) {
            let blog = root.appending(pathComponent: "blog")
            let breadcrumb: [AdminBreadcrumb.Link] = [
                .init(label: "Admin", link: root.path),
                .init(label: "Blog", link: blog.path),
            ]

            self.blog = blog
            let mediaAssetList =
                mediaAssetList ?? MediaWebAdmin.Routes.standard.assetList
            self.mediaAssetList = mediaAssetList
            self.breadcrumb = breadcrumb
            self.post = .init(
                root: blog,
                breadcrumb: breadcrumb,
                mediaAssetList: mediaAssetList
            )
            self.author = .init(
                root: blog,
                breadcrumb: breadcrumb,
                mediaAssetList: mediaAssetList
            )
            self.authorLink = .init(
                root: blog.appending(pathComponent: "authors"),
                breadcrumb: self.author.authorsBreadcrumb
            )
            self.tag = .init(
                root: blog,
                breadcrumb: breadcrumb,
                mediaAssetList: mediaAssetList
            )
            self.settings = .init(root: blog, breadcrumb: breadcrumb)
        }
    }
}
