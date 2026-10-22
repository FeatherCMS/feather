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

            var postAddRoute: WebRoute {
                posts.appending(pathComponent: "add")
            }

            var postRemoveRoute: WebRoute {
                posts.appending(pathComponent: "remove")
            }

            var postRemoveByIDRoute: WebRoute {
                posts.appending(parameter: "id")
                    .appending(pathComponent: "remove")
            }

            var postStatusRoute: WebRoute {
                posts.appending(parameter: "id")
                    .appending(pathComponent: "status")
            }

            func post(_ id: String) -> String {
                posts.appending(parameter: "id")
                    .path(parameter: "id", value: id)
            }

            func postAdd() -> String {
                postAddRoute.path
            }

            func postRemove() -> String {
                postRemoveRoute.path
            }

            func postRemove(_ id: String) -> String {
                postRemoveByIDRoute
                    .path(parameter: "id", value: id)
            }

            func postEdit(_ id: String) -> String {
                posts.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: id)
            }

            func postEditMetadata(_ id: String, _ metadataID: String)
                -> String
            {
                resolved(
                    posts.appending(parameter: "id")
                        .appending(pathComponent: "edit")
                        .appending(pathComponent: "metadata")
                        .appending(parameter: "metadataID"),
                    parameters: [
                        "id": id,
                        "metadataID": metadataID,
                    ]
                )
            }

            func postEditMetadataRoute() -> WebRoute {
                posts.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .appending(pathComponent: "metadata")
                    .appending(parameter: "metadataID")
            }

            func postStatus(_ id: String) -> String {
                posts.appending(parameter: "id")
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
