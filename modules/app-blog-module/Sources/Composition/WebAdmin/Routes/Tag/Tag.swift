public import BlogModule
public import FeatherWebAdmin
import Hummingbird

extension Tag {
    public enum Router {
        public struct Routes: Sendable {
            let tags: WebRoute
            let tagsBreadcrumb: [AdminBreadcrumb.Link]

            public init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let tags = root.appending(pathComponent: "tags")
                self.tags = tags
                self.tagsBreadcrumb =
                    breadcrumb + [
                        .init(label: "Tags", link: tags.path)
                    ]
            }

            var tagAddRoute: WebRoute {
                tags.appending(pathComponent: "add")
            }

            var tagRemoveRoute: WebRoute {
                tags.appending(pathComponent: "remove")
            }

            var tagRemoveByIDRoute: WebRoute {
                tags.appending(parameter: "id")
                    .appending(pathComponent: "remove")
            }

            var tagStatusRoute: WebRoute {
                tags.appending(parameter: "id")
                    .appending(pathComponent: "status")
            }

            func tag(_ id: String) -> String {
                tags.appending(parameter: "id")
                    .path(parameter: "id", value: id)
            }

            func tagAdd() -> String {
                tagAddRoute.path
            }

            func tagRemove() -> String {
                tagRemoveRoute.path
            }

            func tagRemove(_ id: String) -> String {
                tagRemoveByIDRoute
                    .path(parameter: "id", value: id)
            }

            func tagEdit(_ id: String) -> String {
                tags.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: id)
            }

            func tagEditMetadata(_ id: String, _ metadataID: String) -> String {
                resolved(
                    tags.appending(parameter: "id")
                        .appending(pathComponent: "edit")
                        .appending(pathComponent: "metadata")
                        .appending(parameter: "metadataID"),
                    parameters: [
                        "id": id,
                        "metadataID": metadataID,
                    ]
                )
            }

            func tagEditMetadataRoute() -> WebRoute {
                tags.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID")
            }

            func tagStatus(_ id: String) -> String {
                tags.appending(parameter: "id")
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
