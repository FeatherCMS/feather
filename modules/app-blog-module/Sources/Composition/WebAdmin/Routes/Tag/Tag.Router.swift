public import BlogModule
public import FeatherWebAdmin
public import FeatherWebShared
import Foundation
import Hummingbird

extension Tag {
    public enum Router {
        public struct Routes: Sendable {
            let tags: WebRoute
            let mediaAssetList: WebRoute
            let tagsBreadcrumb: [AdminBreadcrumb.Link]

            public init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                mediaAssetList: WebRoute
            ) {
                let tags = root.appending(pathComponent: "tags")
                self.tags = tags
                self.mediaAssetList = mediaAssetList
                self.tagsBreadcrumb =
                    breadcrumb + [
                        .init(label: "Tags", link: tags.path)
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

            func tagPath(_ id: String) -> String {
                tags.appending(parameter: "id")
                    .path(parameter: "id", value: id)
            }

            func tagAddPath() -> String {
                tagAddRoute.path
            }

            func tagRemovePath() -> String {
                tagRemoveRoute.path
            }

            func tagRemovePath(_ id: String) -> String {
                tagRemoveByIDRoute
                    .path(parameter: "id", value: id)
            }

            func tagEditPath(_ id: String) -> String {
                tags.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: id)
            }

            func tagEditMetadataPath(_ id: String, _ metadataID: String)
                -> String
            {
                resolvedPath(
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

            func tagStatusPath(_ id: String) -> String {
                tags.appending(parameter: "id")
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
