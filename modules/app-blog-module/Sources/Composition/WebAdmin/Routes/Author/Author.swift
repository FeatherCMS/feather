public import BlogModule
public import FeatherWebAdmin
public import FeatherWebShared
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

            var authorAddRoute: WebRoute {
                authors.appending(pathComponent: "add")
            }

            var authorRemoveRoute: WebRoute {
                authors.appending(pathComponent: "remove")
            }

            var authorRemoveByIDRoute: WebRoute {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "remove")
            }

            var authorStatusRoute: WebRoute {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "status")
            }

            func author(_ id: String) -> String {
                authors.appending(parameter: "id")
                    .path(parameter: "id", value: id)
            }

            func authorAdd() -> String {
                authorAddRoute.path
            }

            func authorRemove() -> String {
                authorRemoveRoute.path
            }

            func authorRemove(_ id: String) -> String {
                authorRemoveByIDRoute
                    .path(parameter: "id", value: id)
            }

            func authorEdit(_ id: String) -> String {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: id)
            }

            func authorEditMetadata(_ id: String, _ metadataID: String)
                -> String
            {
                resolved(
                    authors.appending(parameter: "id")
                        .appending(pathComponent: "edit")
                        .appending(pathComponent: "metadata")
                        .appending(parameter: "metadataID"),
                    parameters: [
                        "id": id,
                        "metadataID": metadataID,
                    ]
                )
            }

            func authorEditMetadataRoute() -> WebRoute {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID")
            }

            func authorStatus(_ id: String) -> String {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "status")
                    .path(parameter: "id", value: id)
            }

            private func resolved(
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
