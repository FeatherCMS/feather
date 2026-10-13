public import FeatherAdmin
import Foundation
public import HTML
import SGML
import WebBuilders
public import WebComponents

public enum MediaAssetSelectionMode: String, Sendable {
    case single
    case multiple
}

public enum MediaAssetPopupAction: Sendable {
    case choose
    case upload
}

public struct MediaAssetPopupConfiguration: Sendable {
    public let field: String
    public let selectionMode: MediaAssetSelectionMode
    public let allowedExtensions: AllowedExtensions
    public let defaultFolderPath: String?
    public let previewVariant: String?

    public init(
        field: String,
        selectionMode: MediaAssetSelectionMode = .single,
        allowedExtensions: AllowedExtensions = .anything,
        defaultFolderPath: String? = nil,
        previewVariant: String? = nil
    ) {
        self.field = field
        self.selectionMode = selectionMode
        self.allowedExtensions = allowedExtensions
        self.defaultFolderPath = defaultFolderPath
        self.previewVariant = previewVariant
    }

    fileprivate func url(for action: MediaAssetPopupAction) -> String {
        var components = URLComponents()
        components.path =
            action == .choose
            ? "/admin/media/assets/"
            : "/admin/media/assets/add/"

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

public struct AdminMediaAssetPickerButton: Component {
    public let label: String
    public let style: NewAdminButtonStyle
    public let configuration: MediaAssetPopupConfiguration

    public init(
        _ label: String = "Choose asset",
        style: NewAdminButtonStyle = .ghost(.primary),
        configuration: MediaAssetPopupConfiguration
    ) {
        self.label = label
        self.style = style
        self.configuration = configuration
    }

    public func html(context: inout BuilderContext) -> Button {
        var button = context.build(
            NewAdminControlButton(label, style: style)
        )
        button =
            button
            .data(
                "admin-dialog-url",
                configuration.url(for: .choose)
            )
            .data("media-picker-open", configuration.field)
            .data(
                "media-picker-selection",
                configuration.selectionMode.rawValue
            )
        return button
    }
}

public struct AdminMediaAssetUploadButton: Component {
    public let label: String
    public let style: NewAdminButtonStyle
    public let configuration: MediaAssetPopupConfiguration

    public init(
        _ label: String = "Upload asset",
        style: NewAdminButtonStyle = .ghost(.primary),
        configuration: MediaAssetPopupConfiguration
    ) {
        self.label = label
        self.style = style
        self.configuration = configuration
    }

    public func html(context: inout BuilderContext) -> Button {
        var button = context.build(
            NewAdminControlButton(label, style: style)
        )
        button =
            button
            .data(
                "admin-dialog-url",
                configuration.url(for: .upload)
            )
            .data("media-picker-open", configuration.field)
            .data(
                "media-picker-selection",
                configuration.selectionMode.rawValue
            )
        return button
    }
}

public enum AdminMediaAssetSelectionOutput: Sendable {
    case singleInput(id: String)
    case multipleInputs(containerID: String, name: String)
    case callback(functionName: String)
}

public struct AdminMediaAssetSelectionBridge: Component {
    public let field: String
    public let output: AdminMediaAssetSelectionOutput
    public let submitFormID: String?

    public init(
        field: String,
        output: AdminMediaAssetSelectionOutput,
        submitFormID: String? = nil
    ) {
        self.field = field
        self.output = output
        self.submitFormID = submitFormID
    }

    public func html(context _: inout BuilderContext) -> Script {
        Script(selectionScript())
    }
}

extension AdminMediaAssetSelectionBridge {
    fileprivate func selectionScript() -> String {
        let field = javascriptString(field)
        let formID = submitFormID.map(javascriptString) ?? "null"
        let outputScript: String
        switch output {
        case .singleInput(let id):
            outputScript = """
                var input = document.getElementById(\(javascriptString(id)));
                if (!input || !assets.length) { return; }
                input.value = String(assets[0].id || "");
                input.dispatchEvent(new Event("change", { bubbles: true }));
                """
        case .multipleInputs(let containerID, let name):
            outputScript = """
                var container = document.getElementById(\(javascriptString(containerID)));
                if (!container) { return; }
                container.replaceChildren();
                assets.forEach(function(asset) {
                  if (!asset || !asset.id) { return; }
                  var input = document.createElement("input");
                  input.type = "hidden";
                  input.name = \(javascriptString(name));
                  input.value = String(asset.id);
                  container.appendChild(input);
                });
                if (!container.children.length) { return; }
                """
        case .callback(let functionName):
            outputScript = """
                var callback = window[\(javascriptString(functionName))];
                if (typeof callback !== "function") { return; }
                callback(assets);
                """
        }

        return """
            (function() {
              var field = \(field);
              var formID = \(formID);
              var marker = "new-admin-media-selection-bridge:" + field;
              if (document.documentElement.hasAttribute(marker)) { return; }
              document.documentElement.setAttribute(marker, "true");
              document.addEventListener("new-admin-media-picker-selection", function(event) {
                var detail = event.detail || {};
                if (String(detail.field || "") !== field) { return; }
                var assets = Array.isArray(detail.assets) ? detail.assets : [];
                if (!assets.length) { return; }
                \(outputScript)
                var form = formID ? document.getElementById(formID) : null;
                if (form) {
                  if (form.requestSubmit) { form.requestSubmit(); }
                  else { form.submit(); }
                }
              });
            }());
            """
    }

    fileprivate func javascriptString(_ value: String) -> String {
        let data = try? JSONEncoder().encode(value)
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "\"\""
    }
}
