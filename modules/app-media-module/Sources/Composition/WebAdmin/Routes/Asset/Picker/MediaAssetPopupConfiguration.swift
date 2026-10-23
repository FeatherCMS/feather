public import FeatherWebAdmin
import FeatherWebShared
import MediaModule
import Foundation

public struct MediaAssetPopupConfiguration: Sendable {
    public let field: String
    public let selectionMode: MediaAssetSelectionMode
    public let allowedExtensions: AllowedExtensions
    public let defaultFolderPath: String?
    public let previewVariant: String?
    public let routes: Router.Routes

    public init(
        field: String,
        selectionMode: MediaAssetSelectionMode = .single,
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

    func url(for action: MediaAssetPopupAction) -> String {
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
