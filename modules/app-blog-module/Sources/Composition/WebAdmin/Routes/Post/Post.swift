public import BlogModule
public import FeatherWebAdmin
import Hummingbird

extension Post {
    public enum Router {
        public struct Routes: Sendable {
            let posts: WebRoute
            let postsBreadcrumb: [AdminBreadcrumb.Link]

            public init(root: WebRoute, breadcrumb: [AdminBreadcrumb.Link]) {
                let posts = root.appending(pathComponent: "posts")
                self.posts = posts
                self.postsBreadcrumb =
                    breadcrumb + [
                        .init(label: "Posts", link: posts.path)
                    ]
            }

            func post(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    posts.appending(parameter: "id")
                        .path(parameter: "id", value: Self.parameterValue(id))
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
                        .path(parameter: "id", value: Self.parameterValue(id))
                )
            }

            func postEdit(_ id: RouterPath) -> RouterPath {
                RouterPath(
                    posts.appending(parameter: "id")
                        .appending(pathComponent: "edit")
                        .path(parameter: "id", value: Self.parameterValue(id))
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
                        "id": Self.parameterValue(id),
                        "metadataID": Self.parameterValue(metadataID),
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
