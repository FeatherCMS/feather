public import BlogModule
public import FeatherWebAdmin
import Hummingbird

extension Author {
    public enum Router {
        public struct Routes: Sendable {
            let authors: WebRoute
            let authorsBreadcrumb: [AdminBreadcrumb.Link]

            public init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let authors = root.appending(pathComponent: "authors")
                self.authors = authors
                self.authorsBreadcrumb =
                    breadcrumb + [
                        .init(label: "Authors", link: authors.path)
                    ]
            }

            func author(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    authors.appending(parameter: "id")
                        .path(parameter: "id", value: Self.parameterValue(id))
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
                        .path(parameter: "id", value: Self.parameterValue(id))
                )
            }

            func authorEdit(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    authors.appending(parameter: "id")
                        .appending(pathComponent: "edit")
                        .path(parameter: "id", value: Self.parameterValue(id))
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
                        "id": Self.parameterValue(id),
                        "metadataID": Self.parameterValue(metadataID),
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
                        .path(parameter: "id", value: Self.parameterValue(id))
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
