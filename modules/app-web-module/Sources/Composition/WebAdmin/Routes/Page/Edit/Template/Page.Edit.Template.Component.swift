import FeatherWebAdmin
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Page.Edit.Template {
    struct Component: WebComponents.Component {
        struct FieldState: Sendable {
            let key: String
            let title: String
            let kind: WebModule.Template.Field.Kind
            let editor: WebModule.Template.Field.Editor
            let value: String
            let required: Bool
        }

        let model: Page.Edit.Template.Model
        let breadcrumb: [AdminBreadcrumb.Link]
        let action: String
        let detailsHref: String
        let metadataHref: String

        func html(context: inout BuilderContext) -> some BasicTag {
            let form = AdminForm(action: action) {
                context.build(
                    AdminTabBar(
                        links: [
                            .init(
                                label: "Details",
                                href: detailsHref,
                                isCurrent: false
                            ),
                            .init(
                                label: "Metadata",
                                href: metadataHref,
                                isCurrent: false
                            ),
                            .init(
                                label: "Template",
                                href: action,
                                isCurrent: true
                            ),
                        ]
                    )
                )

                if let error = model.error {
                    P(error).class("admin-form__error")
                }
                if let success = model.success {
                    P(success).class("admin-form__success")
                }

                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: model.templateTitle,
                            description:
                                "Edit the values used by this page template."
                        )
                    ) {
                        for definition in model.fields {
                            context.build(
                                AdminFormGroup(
                                    id: "web-template-\(definition.key)",
                                    title: definition.title
                                ) {
                                    if case .list(let itemKind) = definition.kind {
                                        context.build(
                                            ListEditor(
                                                name: "field"
                                                    + definition.key.split(
                                                        separator: "."
                                                    )
                                                    .map { "[\($0)]" }
                                                    .joined(),
                                                title: definition.title,
                                                itemKind: itemKind,
                                                editor: definition.editor,
                                                required: definition.required,
                                                values: listValues(
                                                    for: definition.key
                                                )
                                            )
                                        )
                                    }
                                    else {
                                        for field in fieldStates where
                                            isInside(field.key, definition.key)
                                        {
                                            render(field, context: &context)
                                        }
                                    }
                                }
                            )
                        }
                    }
                )

                Script(listEditorScript())

                Section {
                    Div {
                        context.build(AdminSubmitButton("Save template"))
                    }
                    .class("admin-form__actions")
                }
            }
            let normalizedSlug = model.slug.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            return Section {
                context.build(AdminBreadcrumb(links: breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit page",
                            description:
                                "Update the page content and publication settings.",
                            preview: .init(
                                label: "Preview",
                                href: normalizedSlug.isEmpty
                                    ? nil
                                    : "/\(normalizedSlug)/"
                            )
                        )
                    )
                )
                context.build(form)
            }
            .class("cms-section")
        }

        private var fieldStates: [FieldState] {
            let value: WebModule.Template.Value
            if let data = model.templateData.data(using: .utf8),
                let decoded = try? JSONDecoder().decode(
                    WebModule.Template.Value.self,
                    from: data
                ),
                case .object = decoded
            {
                value = decoded
            }
            else {
                value = .object([:])
            }
            return model.fields.flatMap {
                flatten(
                    field: $0,
                    path: "",
                    value: value
                )
            }
        }

        private func flatten(
            field: WebModule.Template.Field,
            path: String,
            value: WebModule.Template.Value
        ) -> [FieldState] {
            let key = path.isEmpty ? field.key : "\(path).\(field.key)"
            let label = field.title
            switch field.kind {
            case .object(let fields):
                return fields.flatMap {
                    flatten(
                        field: $0,
                        path: key,
                        value: value
                    )
                }
            case .list(_):
                return [
                    .init(
                        key: key,
                        title: label,
                        kind: field.kind,
                        editor: field.editor,
                        value: submittedValue(
                            for: key,
                            fallback: encodedValue(
                                valueAt(key, in: value) ?? .array([])
                            ),
                            kind: field.kind
                        ),
                        required: field.required
                    )
                ]
            case .string, .boolean, .integer, .float, .double, .date:
                return [
                    .init(
                        key: key,
                        title: label,
                        kind: field.kind,
                        editor: field.editor,
                        value: submittedValue(
                            for: key,
                            fallback: scalarValue(
                                valueAt(key, in: value),
                                kind: field.kind
                            ),
                            kind: field.kind
                        ),
                        required: field.required
                    )
                ]
            }
        }

        private func valueAt(
            _ path: String,
            in value: WebModule.Template.Value
        ) -> WebModule.Template.Value? {
            var current: WebModule.Template.Value? = value
            for component in path.split(separator: ".") {
                guard
                    let currentValue = current,
                    case .object(let object) = currentValue
                else {
                    return nil
                }
                current = object[String(component)]
            }
            return current
        }

        private func scalarValue(
            _ value: WebModule.Template.Value?,
            kind: WebModule.Template.Field.Kind
        ) -> String {
            switch (value, kind) {
            case (.string(let value), _): value
            case (.boolean(let value), _): value ? "true" : "false"
            case (.integer(let value), _): String(value)
            case (.number(let value), _): String(value)
            case (_, .boolean): "false"
            default: ""
            }
        }

        private func submittedValue(
            for key: String,
            fallback: String,
            kind: WebModule.Template.Field.Kind
        ) -> String {
            guard let formValues = model.formValues else {
                return fallback
            }
            if let value = formValues[key] {
                return value
            }
            if case .boolean = kind {
                return "false"
            }
            if case .list = kind {
                return "[]"
            }
            return ""
        }

        private func encodedValue(
            _ value: WebModule.Template.Value
        ) -> String {
            guard
                let data = try? JSONEncoder().encode(value),
                let string = String(data: data, encoding: .utf8)
            else {
                return "[]"
            }
            return string
        }

        private func isInside(_ key: String, _ root: String) -> Bool {
            key == root || key.hasPrefix("\(root).")
        }

        private func listValues(
            for key: String
        ) -> [WebModule.Template.Value] {
            guard let state = fieldStates.first(where: { $0.key == key }),
                let data = state.value.data(using: .utf8),
                let value = try? JSONDecoder().decode(
                    WebModule.Template.Value.self,
                    from: data
                ),
                case .array(let values) = value
            else {
                return []
            }
            return values
        }

        private func render(
            _ field: FieldState,
            context: inout BuilderContext
        ) -> any FlowContent {
            switch field.kind {
            case .boolean:
                return context.build(
                    AdminFormFieldCheckbox(
                        state: .init(
                            name: "field"
                                + field.key.split(separator: ".")
                                    .map { "[\($0)]" }
                                    .joined(),
                            checkboxLabel: field.title,
                            isChecked: field.value == "true"
                        )
                    )
                )
            case .list(let itemKind):
                return context.build(
                    ListEditor(
                        name: "field"
                            + field.key.split(separator: ".")
                                .map { "[\($0)]" }
                                .joined(),
                        title: field.title,
                        itemKind: itemKind,
                        editor: field.editor,
                        required: field.required,
                        values: listValues(for: field.key)
                    )
                )
            case .string where field.editor == .textarea:
                return context.build(
                    AdminFormFieldTextArea(
                        state: .init(
                            name: "field"
                                + field.key.split(separator: ".")
                                    .map { "[\($0)]" }
                                    .joined(),
                            label: field.title,
                            value: field.value,
                            style: .small,
                            isRequired: field.required
                        )
                    )
                )
            case .string, .integer, .float, .double, .date:
                return context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "field"
                                + field.key.split(separator: ".")
                                    .map { "[\($0)]" }
                                    .joined(),
                            label: field.title,
                            value: field.value,
                            type: field.kind == .integer
                                ? .number
                                : field.kind == .date ? .date : .text,
                            isRequired: field.required
                        )
                    )
                )
            case .object(_):
                return P("")
            }
        }

        private func listEditorScript() -> String {
            #"""
            (function () {
              function setPath(object, path, value) {
                var parts = path.split(".");
                var current = object;
                parts.forEach(function (part, index) {
                  if (index === parts.length - 1) {
                    current[part] = value;
                  } else {
                    if (!current[part] || typeof current[part] !== "object") {
                      current[part] = {};
                    }
                    current = current[part];
                  }
                });
              }

              function readControl(wrapper) {
                var control = wrapper.querySelector("input:not([type=hidden]), textarea, select");
                if (!control) { return { skip: true }; }
                var kind = wrapper.dataset.templateListKind;
                if (kind === "boolean") { return { value: control.checked }; }
                if (kind === "integer" || kind === "float" || kind === "double") {
                  if (!control.value.trim()) { return { skip: true }; }
                  var number = Number(control.value);
                  return Number.isFinite(number) ? { value: number } : { skip: true };
                }
                if (kind === "date" && !control.value) { return { skip: true }; }
                if (kind === "list") {
                  try { return { value: JSON.parse(control.value || "[]") }; }
                  catch (error) { return { skip: true }; }
                }
                return { value: control.value };
              }

              function readItem(item) {
                var fields = item.querySelectorAll("[data-template-list-path]");
                var result = {};
                var scalar = null;
                fields.forEach(function (wrapper) {
                  var value = readControl(wrapper);
                  if (value.skip) { return; }
                  var path = wrapper.dataset.templateListPath;
                  if (path === "$value") { scalar = value.value; }
                  else { setPath(result, path, value.value); }
                });
                return scalar === null ? result : scalar;
              }

              function sync(root) {
                var values = Array.prototype.map.call(
                  root.querySelectorAll("[data-template-list-item]:not([data-template-list-prototype])"),
                  readItem
                );
                var output = root.querySelector(".template-list-editor__value");
                if (output) { output.value = JSON.stringify(values); }
              }

              function renumber(root) {
                root.querySelectorAll("[data-template-list-item]:not([data-template-list-prototype]) h3")
                  .forEach(function (heading, index) {
                    heading.textContent = root.dataset.templateListTitle.replace(/s$/, "") + " " + (index + 1);
                  });
              }

              function updateRemoveButtons(root) {
                var itemCount = root.querySelectorAll(
                  "[data-template-list-item]:not([data-template-list-prototype])"
                ).length;
                var minimumItems = root.dataset.templateListRequired === "true" ? 1 : 0;
                root.querySelectorAll("[data-template-list-remove]")
                  .forEach(function (button) {
                    button.disabled = itemCount <= minimumItems;
                  });
              }

              document.querySelectorAll("[data-template-list-editor]").forEach(function (root) {
                var items = root.querySelector(".template-list-editor__items");
                var prototype = root.querySelector("[data-template-list-prototype]");
                var status = root.querySelector(".template-list-editor__status");
                if (!items || !prototype) { return; }

                root.addEventListener("click", function (event) {
                  var add = event.target.closest("[data-template-list-add]");
                  var remove = event.target.closest("[data-template-list-remove]");
                  if (add) {
                    var item = prototype.cloneNode(true);
                    item.classList.remove("template-list-editor__prototype");
                    item.removeAttribute("data-template-list-prototype");
                    var idSuffix = Date.now().toString(36) + Math.random().toString(36).slice(2);
                    var idMap = {};
                    item.querySelectorAll("[name]").forEach(function (element) {
                      element.name = element.name + "-" + idSuffix;
                    });
                    item.querySelectorAll("[id]").forEach(function (element) {
                      var previousID = element.id;
                      element.id = previousID + "-" + idSuffix;
                      idMap[previousID] = element.id;
                    });
                    item.querySelectorAll("label[for]").forEach(function (label) {
                      var previousID = label.getAttribute("for");
                      if (idMap[previousID]) { label.setAttribute("for", idMap[previousID]); }
                    });
                    item.querySelectorAll("input").forEach(function (input) {
                      input.disabled = false;
                      if (input.type === "checkbox") { input.checked = false; }
                      else { input.value = ""; }
                    });
                    item.querySelectorAll("textarea, select").forEach(function (control) {
                      control.disabled = false;
                      if (control.tagName === "TEXTAREA") {
                        var wrapper = control.closest("[data-template-list-kind]");
                        control.value = wrapper && wrapper.dataset.templateListKind === "list" ? "[]" : "";
                      }
                      else { control.selectedIndex = 0; }
                    });
                    items.insertBefore(item, prototype);
                    requestAnimationFrame(function () {
                      item.querySelectorAll(".admin-form-textarea textarea").forEach(function (textarea) {
                        textarea.style.height = "auto";
                        textarea.style.height = textarea.scrollHeight + "px";
                      });
                    });
                    renumber(root);
                    updateRemoveButtons(root);
                    sync(root);
                    if (status) { status.textContent = "Item added."; }
                  } else if (remove) {
                    var itemCount = root.querySelectorAll(
                      "[data-template-list-item]:not([data-template-list-prototype])"
                    ).length;
                    var minimumItems = root.dataset.templateListRequired === "true" ? 1 : 0;
                    if (itemCount <= minimumItems) { return; }
                    remove.closest("[data-template-list-item]").remove();
                    renumber(root);
                    updateRemoveButtons(root);
                    sync(root);
                  }
                });

                root.addEventListener("input", function () { sync(root); });
                root.addEventListener("change", function () { sync(root); });
                var form = root.closest("form");
                if (form) { form.addEventListener("submit", function () { sync(root); }); }
                renumber(root);
                updateRemoveButtons(root);
                sync(root);
              });
            })();
            """#
        }
    }
}
