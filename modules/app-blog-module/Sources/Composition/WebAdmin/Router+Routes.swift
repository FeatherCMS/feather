public import FeatherWebAdmin
import Hummingbird

extension Router {
    public struct Routes: Sendable {
        public let blog: WebRoute
        public let posts: WebRoute
        public let authors: WebRoute
        public let tags: WebRoute
        public let settings: WebRoute

        public let breadcrumb: [AdminBreadcrumb.Link]
        public let postsBreadcrumb: [AdminBreadcrumb.Link]
        public let authorsBreadcrumb: [AdminBreadcrumb.Link]
        public let tagsBreadcrumb: [AdminBreadcrumb.Link]

        public static let standard = Self(
            root: WebRoute.root.appending(pathComponent: "admin")
        )

        public init(root: WebRoute) {
            let admin = root.appending(pathComponent: "blog")
            let posts = admin.appending(pathComponent: "posts")
            let authors = admin.appending(pathComponent: "authors")
            let tags = admin.appending(pathComponent: "tags")

            self.blog = admin
            self.posts = posts
            self.authors = authors
            self.tags = tags
            self.settings = admin.appending(pathComponent: "settings")
            self.breadcrumb = [
                .init(label: "Admin", link: root.path),
                .init(label: "Blog", link: admin.path),
            ]
            self.postsBreadcrumb =
                self.breadcrumb + [
                    .init(label: "Posts", link: posts.path)
                ]
            self.authorsBreadcrumb =
                self.breadcrumb + [
                    .init(label: "Authors", link: authors.path)
                ]
            self.tagsBreadcrumb =
                self.breadcrumb + [
                    .init(label: "Tags", link: tags.path)
                ]
        }

        func post(_ id: RouterPath) -> RouterPath {
            RouterPath(
                posts.appending(parameter: "id")
                    .path(
                        parameter: "id",
                        value: parameterValue(id)
                    )
            )
        }

        func postAdd() -> RouterPath {
            posts.appending(pathComponent: "add").routerPath
        }

        func postRemove() -> RouterPath {
            posts.appending(pathComponent: "remove").routerPath
        }

        func postRemove(_ id: RouterPath) -> RouterPath {
            RouterPath(
                posts.appending(parameter: "id")
                    .appending(pathComponent: "remove")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func postEdit(_ id: RouterPath) -> RouterPath {
            RouterPath(
                posts.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func postEditMetadata(_ id: RouterPath, _ metadataID: RouterPath)
            -> RouterPath
        {
            resolved(
                posts.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID"),
                parameters: [
                    "id": parameterValue(id),
                    "metadataID": parameterValue(metadataID),
                ]
            )
        }

        func postEditMetadataRoute() -> RouterPath {
            posts.appending(parameter: "id")
                .appending(pathComponent: "edit")
                .appending(pathComponent: "metadata")
                .appending(parameter: "metadataID")
                .routerPath
        }

        func postStatus(_ id: RouterPath) -> RouterPath {
            RouterPath(
                posts.appending(parameter: "id")
                    .appending(pathComponent: "status")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func author(_ id: RouterPath) -> RouterPath {
            RouterPath(
                authors.appending(parameter: "id")
                    .path(
                        parameter: "id",
                        value: parameterValue(id)
                    )
            )
        }

        func authorAdd() -> RouterPath {
            authors.appending(pathComponent: "add").routerPath
        }

        func authorRemove() -> RouterPath {
            authors.appending(pathComponent: "remove").routerPath
        }

        func authorRemove(_ id: RouterPath) -> RouterPath {
            RouterPath(
                authors.appending(parameter: "id")
                    .appending(pathComponent: "remove")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func authorEdit(_ id: RouterPath) -> RouterPath {
            RouterPath(
                authors.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func authorEditMetadata(_ id: RouterPath, _ metadataID: RouterPath)
            -> RouterPath
        {
            resolved(
                authors.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID"),
                parameters: [
                    "id": parameterValue(id),
                    "metadataID": parameterValue(metadataID),
                ]
            )
        }

        func authorEditMetadataRoute() -> RouterPath {
            authors.appending(parameter: "id")
                .appending(pathComponent: "edit")
                .appending(pathComponent: "metadata")
                .appending(parameter: "metadataID")
                .routerPath
        }

        func authorStatus(_ id: RouterPath) -> RouterPath {
            RouterPath(
                authors.appending(parameter: "id")
                    .appending(pathComponent: "status")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func authorLinks(_ id: RouterPath) -> RouterPath {
            RouterPath(
                authors.appending(parameter: "id")
                    .appending(pathComponent: "links")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func authorLinksBreadcrumb(_ id: RouterPath)
            -> [AdminBreadcrumb.Link]
        {
            authorsBreadcrumb + [
                .init(label: "Links", link: authorLinks(id).description + "/")
            ]
        }

        func tag(_ id: RouterPath) -> RouterPath {
            RouterPath(
                tags.appending(parameter: "id")
                    .path(
                        parameter: "id",
                        value: parameterValue(id)
                    )
            )
        }

        func tagAdd() -> RouterPath {
            tags.appending(pathComponent: "add").routerPath
        }

        func tagRemove() -> RouterPath {
            tags.appending(pathComponent: "remove").routerPath
        }

        func tagRemove(_ id: RouterPath) -> RouterPath {
            RouterPath(
                tags.appending(parameter: "id")
                    .appending(pathComponent: "remove")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func tagEdit(_ id: RouterPath) -> RouterPath {
            RouterPath(
                tags.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func tagEditMetadata(_ id: RouterPath, _ metadataID: RouterPath)
            -> RouterPath
        {
            resolved(
                tags.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID"),
                parameters: [
                    "id": parameterValue(id),
                    "metadataID": parameterValue(metadataID),
                ]
            )
        }

        func tagEditMetadataRoute() -> RouterPath {
            tags.appending(parameter: "id")
                .appending(pathComponent: "edit")
                .appending(pathComponent: "metadata")
                .appending(parameter: "metadataID")
                .routerPath
        }

        func tagStatus(_ id: RouterPath) -> RouterPath {
            RouterPath(
                tags.appending(parameter: "id")
                    .appending(pathComponent: "status")
                    .path(parameter: "id", value: parameterValue(id))
            )
        }

        func authorLink(_ authorID: RouterPath, _ id: RouterPath)
            -> RouterPath
        {
            resolved(
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(parameter: "id"),
                parameters: [
                    "authorID": parameterValue(authorID),
                    "id": parameterValue(id),
                ]
            )
        }

        func authorLinkAdd(_ authorID: RouterPath) -> RouterPath {
            RouterPath(
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(pathComponent: "add")
                    .path(
                        parameter: "authorID",
                        value: parameterValue(authorID)
                    )
            )
        }

        func authorLinkRemove(_ authorID: RouterPath) -> RouterPath {
            RouterPath(
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(pathComponent: "remove")
                    .path(
                        parameter: "authorID",
                        value: parameterValue(authorID)
                    )
            )
        }

        func authorLinkEdit(_ authorID: RouterPath, _ id: RouterPath)
            -> RouterPath
        {
            resolved(
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(parameter: "id")
                    .appending(pathComponent: "edit"),
                parameters: [
                    "authorID": parameterValue(authorID),
                    "id": parameterValue(id),
                ]
            )
        }

        private func resolved(
            _ route: WebRoute,
            parameters: [String: String]
        ) -> RouterPath {
            do {
                return RouterPath(try route.path(parameters: parameters))
            }
            catch {
                preconditionFailure("A Blog route is missing a parameter.")
            }
        }

        private func parameterValue(_ path: RouterPath) -> String {
            let value = path.description
            return value.hasPrefix("/") ? String(value.dropFirst()) : value
        }
    }
}
