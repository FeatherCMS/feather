public import BlogModule
public import FeatherWebAdmin
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

            func author(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    authors.appending(parameter: "id")
                        .path(parameter: "id", value: Self.parameterValue(id))
                )
            }

            func authorLinks(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    authors.appending(parameter: "id")
                        .appending(pathComponent: "links")
                        .path(parameter: "id", value: Self.parameterValue(id))
                )
            }

            func authorLinksBreadcrumb(_ id: RouterPath)
                -> [AdminBreadcrumb.Link]
            {
                authorsBreadcrumb + [
                    .init(
                        label: "Links",
                        link: authorLinks(id).description + "/"
                    )
                ]
            }

            func authorLink(_ authorID: RouterPath, _ id: RouterPath)
                -> RouterPath
            {
                resolved(
                    authors.appending(parameter: "authorID")
                        .appending(pathComponent: "links")
                        .appending(parameter: "id"),
                    parameters: [
                        "authorID": Self.parameterValue(authorID),
                        "id": Self.parameterValue(id),
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
                            value: Self.parameterValue(authorID)
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
                            value: Self.parameterValue(authorID)
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
                        "authorID": Self.parameterValue(authorID),
                        "id": Self.parameterValue(id),
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

            private static func parameterValue(_ path: RouterPath) -> String {
                let value = path.description
                return value.hasPrefix("/") ? String(value.dropFirst()) : value
            }
        }
    }
}
