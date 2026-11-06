public import BlogModule
public import FeatherWebAdmin
public import FeatherWebShared
import Foundation
import Hummingbird

extension Author {
    public enum Router {
        public struct Routes: Sendable {
            let authors: WebRoute
            let mediaAssetList: WebRoute
            let authorsBreadcrumb: [AdminBreadcrumb.Link]

            public init(
                root: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                mediaAssetList: WebRoute
            ) {
                let authors = root.appending(pathComponent: "authors")
                self.authors = authors
                self.mediaAssetList = mediaAssetList
                self.authorsBreadcrumb =
                    breadcrumb + [
                        .init(label: "Authors", link: authors.path)
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

            var authorAddRoute: WebRoute {
                authors.appending(pathComponent: "add")
            }

            var authorRemoveRoute: WebRoute {
                authors.appending(pathComponent: "remove")
            }

            var authorStatusRoute: WebRoute {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "status")
            }

            func authorPath(_ id: String) -> String {
                authors.appending(parameter: "id")
                    .path(parameter: "id", value: id)
            }

            func authorAddPath() -> String {
                authorAddRoute.path
            }

            func authorRemovePath() -> String {
                authorRemoveRoute.path
            }

            func authorRemovePath(ids: [String]) -> String {
                var components = URLComponents(string: authorRemoveRoute.path)
                components?.queryItems = ids.map {
                    URLQueryItem(name: "ids", value: $0)
                }
                return components?.string ?? authorRemoveRoute.path
            }

            func authorEditPath(_ id: String) -> String {
                authors.appending(parameter: "id")
                    .appending(pathComponent: "edit")
                    .path(parameter: "id", value: id)
            }

            func authorEditMetadataPath(_ id: String, _ metadataID: String)
                -> String
            {
                resolvedPath(
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

            func authorStatusPath(_ id: String) -> String {
                authors.appending(parameter: "id")
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
