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
                self.tagsBreadcrumb = breadcrumb + [
                    .init(label: "Tags", link: tags.path)
                ]
            }

            func tag(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    tags.appending(parameter: "id")
                        .path(parameter: "id", value: Self.parameterValue(id))
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
                        .path(parameter: "id", value: Self.parameterValue(id))
                )
            }

            func tagEdit(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    tags.appending(parameter: "id")
                        .appending(pathComponent: "edit")
                        .path(parameter: "id", value: Self.parameterValue(id))
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
                        "id": Self.parameterValue(id),
                        "metadataID": Self.parameterValue(metadataID),
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
