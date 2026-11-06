public import FeatherWebAdmin
import FeatherWebShared
import Foundation
public import MediaModule

extension Asset.Picker.Popup {
    public struct Configuration: Sendable {
        public let field: String
        public let selectionMode: Asset.Picker.SelectionMode
        public let allowedExtensions: AllowedExtensions
        public let defaultFolderPath: String?
        public let previewVariant: String?
        public let routes: Router.Routes

        public init(
            field: String,
            selectionMode: Asset.Picker.SelectionMode = .single,
            allowedExtensions: AllowedExtensions = .anything,
            defaultFolderPath: String? = nil,
            previewVariant: String? = nil,
            routes: Router.Routes = .standard
        ) {
            self.field = field
            self.selectionMode = selectionMode
            self.allowedExtensions = allowedExtensions
            self.defaultFolderPath = defaultFolderPath
            self.previewVariant = previewVariant
            self.routes = routes
        }

        func url(for action: Action) -> String {
            var components = URLComponents()
            components.path =
                action == .choose
                ? routes.assetList.path
                : routes.assetAdd.path

            var queryItems = [
                URLQueryItem(name: "picker", value: "1"),
                URLQueryItem(name: "field", value: field),
                URLQueryItem(
                    name: "selection",
                    value: selectionMode.rawValue
                ),
            ]
            if selectionMode == .multiple {
                queryItems.append(
                    .init(name: "selection_reset", value: "1")
                )
            }
            if !allowedExtensions.isAnything {
                queryItems.append(
                    .init(
                        name: "extensions",
                        value: allowedExtensions.queryValue
                    )
                )
            }
            if let defaultFolderPath, !defaultFolderPath.isEmpty {
                queryItems.append(
                    .init(
                        name: "default_folder_path",
                        value: defaultFolderPath
                    )
                )
            }
            if let previewVariant, !previewVariant.isEmpty {
                queryItems.append(
                    .init(name: "preview_variant", value: previewVariant)
                )
            }
            components.queryItems = queryItems
            return components.string ?? components.path
        }
    }
}
