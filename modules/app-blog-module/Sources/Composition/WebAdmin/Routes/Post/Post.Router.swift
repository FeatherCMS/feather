public import BlogModule
public import FeatherWebAdmin
public import FeatherWebShared
import Foundation
import Hummingbird

extension Post {
    public enum Router {
        public struct Routes: Sendable {
            let posts: WebRoute
            let mediaAssetList: WebRoute
            let postsBreadcrumb: [AdminBreadcrumb.Link]

            public init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                mediaAssetList: WebRoute
            ) {
                let posts = root.appending(pathComponent: "posts")
                self.posts = posts
                self.mediaAssetList = mediaAssetList
                self.postsBreadcrumb =
                    breadcrumb + [
                        .init(label: "Posts", link: posts.path)
                    ]
            }

            func imagePickerPath(_ field: String) -> String {
                var components = URLComponents()
                components.path = mediaAssetList.path
                components.queryItems = [
                    URLQueryItem(name: "picker", value: "1"),
                    URLQueryItem(name: "field", value: field),
                    URLQueryItem(
                        name: "extensions",
                        value: AllowedExtensions.images.queryValue
                    ),
                ]
                return components.string ?? components.path
            }

            var postAddRoute: WebRoute {
                posts.appending(pathComponent: "add")
            }

            var postRemoveRoute: WebRoute {
                posts.appending(pathComponent: "remove")
            }

            var postStatusRoute: WebRoute {
                posts.appending(parameter: "id")
                    .appending(pathComponent: "status")
            }

            func postPath(_ id: String) -> String {
                posts.appending(parameter: "id")
                    .path(parameter: "id", value: id)
            }

            func postAddPath() -> String {
                postAddRoute.path
            }

            func postRemovePath() -> String {
                postRemoveRoute.path
            }

            func postRemovePath(ids: [String]) -> String {
                var components = URLComponents(string: postRemoveRoute.path)
                components?.queryItems = ids.map {
                    URLQueryItem(name: "ids", value: $0)
                }
                return components?.string ?? postRemoveRoute.path
            }

            func postEditPath(_ id: String) -> String {
                posts.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: id)
            }

            func postEditMetadataPath(_ id: String, _ metadataID: String)
                -> String
            {
                resolvedPath(
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

            func postStatusPath(_ id: String) -> String {
                posts.appending(parameter: "id")
                    .appending(pathComponent: "status")
                    .path(parameter: "id", value: id)
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
