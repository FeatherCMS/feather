import FeatherWebAdmin
import Foundation
public import HTML
public import MediaModule
import WebBuilders
public import WebComponents

extension Asset.Picker {
    public struct SelectionBridge: Component {
        public let field: String
        public let output: SelectionOutput
        public let submitFormID: String?

        public init(
            field: String,
            output: SelectionOutput,
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
}

extension Asset.Picker.SelectionBridge {
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
              var marker = "admin-media-selection-bridge:" + field;
              if (document.documentElement.hasAttribute(marker)) { return; }
              document.documentElement.setAttribute(marker, "true");
              document.addEventListener("admin-media-picker-selection", function(event) {
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
