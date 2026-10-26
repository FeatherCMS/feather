public import BlogModule
public import FeatherWebAdmin
public import FeatherWebShared
import Hummingbird

extension AuthorLink {
    public enum Router {
        public struct Routes: Sendable {
            let authors: WebRoute
            let authorsBreadcrumb: [AdminBreadcrumb.Link]

            public init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                self.authors = root
                self.authorsBreadcrumb = breadcrumb
            }

            var authorLinkAddRoute: WebRoute {
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(pathComponent: "add")
            }

            var authorLinkRemoveRoute: WebRoute {
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(pathComponent: "remove")
            }

            var authorLinkEditRoute: WebRoute {
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(parameter: "id")
                    .appending(pathComponent: "edit")
            }

            func authorPath(_ id: String) -> String {
                authors.appending(parameter: "id")
                    .path(parameter: "id", value: id)
            }

            func authorLinksPath(_ id: String) -> String {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "links")
                    .path(parameter: "id", value: id)
            }

            func authorLinksBreadcrumb(_ id: String)
                -> [AdminBreadcrumb.Link]
            {
                authorsBreadcrumb + [
                    .init(
                        label: "Links",
                        link: authorLinksPath(id)
                    )
                ]
            }

            func authorLinkPath(_ authorID: String, _ id: String) -> String {
                resolvedPath(
                    authors.appending(parameter: "authorID")
                        .appending(pathComponent: "links")
                        .appending(parameter: "id"),
                    parameters: [
                        "authorID": authorID,
                        "id": id,
                    ]
                )
            }

            func authorLinkAddPath(_ authorID: String) -> String {
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(pathComponent: "add")
                    .path(parameter: "authorID", value: authorID)
            }

            func authorLinkRemovePath(_ authorID: String) -> String {
                authors.appending(parameter: "authorID")
                    .appending(pathComponent: "links")
                    .appending(pathComponent: "remove")
                    .path(parameter: "authorID", value: authorID)
            }

            func authorLinkEditPath(_ authorID: String, _ id: String) -> String {
                resolvedPath(
                    authors.appending(parameter: "authorID")
                        .appending(pathComponent: "links")
                        .appending(parameter: "id")
                        .appending(pathComponent: "edit"),
                    parameters: [
                        "authorID": authorID,
                        "id": id,
                    ]
                )
            }

            private func resolvedPath(
                _ route: WebRoute,
                parameters: [String: String]
            ) -> String {
                do {
                    return try route.path(parameters: parameters)
                }
                catch {
                    preconditionFailure("A Blog route is missing a parameter.")
                }
            }

        }
    }
}
