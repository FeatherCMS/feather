import CSS
import HTML
import SGML
import WebStandards

struct ContactFormForm: Component, FlowContent {
    struct State: Object {
        var name: String
        var successMessage: String
        var failureMessage: String
        var redirectUrl: String?
        var fieldIDs: [String]
        var availableFields: [AdminManageContactFormFieldOption]
        var mails: [AdminManageContactFormMail]
        var error: String?
        var success: String?
    }

    var state: State
    var action: String
    var submitLabel: String

    func selectors() -> [any Selector] {
        Class("contact-form-field-picker") {
            Display(.grid)
            Gap(16.px)
            MarginTop(8.px)
        }
        Class("contact-form-field-group") {
            Display(.grid)
            Gap(8.px)
        }
        Class("contact-form-field-group-title") {
            Margin(0)
            FontSize(0.95.rem)
            FontWeight(.number(600))
            Color(.variable("cms-strong-font"))
        }
        Class("contact-form-field-group-help") {
            Margin(0)
            Color(.variable("cms-light-font"))
            FontSize(0.9.rem)
        }
        Class("contact-form-field-list") {
            Display(.grid)
            Gap(8.px)
        }
        Class("contact-form-field-row") {
            Display(.flex)
            AlignItems(.center)
            Gap(10.px)
            Padding(vertical: 10.px, horizontal: 12.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(10.px)
            Background(color: .color(.variable("cms-bg")))
        }
        Custom(".contact-form-field-row.is-available") {
            Background(color: .color(.variable("cms-white")))
        }
        Class("contact-form-field-drag") {
            Color(.variable("cms-light-font"))
            FontSize(18.px)
            Width(18.px)
            TextAlign(.center)
        }
        Class("contact-form-field-content") {
            Flex(1)
            MinWidth(0.px)
        }
        Class("contact-form-field-actions") {
            Display(.flex)
            Gap(4.px)
            AlignItems(.center)
        }
        Custom(".contact-form-field-row.is-available .contact-form-field-actions") {
            Display(.none)
        }
        Custom(".contact-form-field-row.is-selected") {
            UnsafeRawProperty(name: "cursor", value: "grab")
        }
        Custom(".contact-form-field-row.is-available") {
            UnsafeRawProperty(name: "cursor", value: "grab")
        }
        Custom(".contact-form-field-row.is-dragging") {
            Opacity(0.55)
        }
    }

    func content() -> some BasicTag {
        Form {
            if let success = state.success { P(success).class("success") }
            if let error = state.error { P(error).class("error") }
            Section {
                Label {
                    AdminFieldLabel(label: "Name", required: true)
                    Input().type(.text).id("name").name("name").value(state.name).required()
                }
            }.if(state.error != nil) { $0.class("has-error") }
            Section {
                Label {
                    AdminFieldLabel(label: "Success message", required: false)
                    Input().type(.text).id("successMessage").name("successMessage").value(state.successMessage)
                }
                Label {
                    AdminFieldLabel(label: "Failure message", required: false)
                    Input().type(.text).id("failureMessage").name("failureMessage").value(state.failureMessage)
                }
                Label {
                    AdminFieldLabel(label: "Redirect URL", required: false)
                    Input().type(.text).id("redirectUrl").name("redirectUrl").value(state.redirectUrl ?? "")
                }
            }
            if !state.availableFields.isEmpty {
                Section {
                    AdminFieldLabel(label: "Fields", required: false)
                    Div {
                        Div {
                            H3("Selected fields").class("contact-form-field-group-title")
                            P("These fields will appear in this order.").class("contact-form-field-group-help")
                            Div {
                                for field in selectedFields {
                                    fieldRow(field: field, isSelected: true)
                                }
                            }
                            .class("contact-form-field-list", "contact-form-selected-fields")
                        }
                        .class("contact-form-field-group")
                        Div {
                            H3("Available fields").class("contact-form-field-group-title")
                            P("Select a field to add it to the form.").class("contact-form-field-group-help")
                            Div {
                                for field in availableUnselectedFields {
                                    fieldRow(field: field, isSelected: false)
                                }
                            }
                            .class("contact-form-field-list", "contact-form-available-fields")
                        }
                        .class("contact-form-field-group")
                    }
                    .class("contact-form-field-picker")
                }
            }
            Section { Div { Button(submitLabel).type(.submit) }.class("button-row") }
            Script(reorderScript())
        }.encType(.urlencoded).method(.post).action(action).class("cms-form")
    }

    private var selectedFields: [AdminManageContactFormFieldOption] {
        let fieldsByID = Dictionary(uniqueKeysWithValues: state.availableFields.map { ($0.id, $0) })
        return state.fieldIDs.compactMap { fieldsByID[$0] }
    }

    private var availableUnselectedFields: [AdminManageContactFormFieldOption] {
        let selectedIDs = Set(state.fieldIDs)
        return state.availableFields.filter { !selectedIDs.contains($0.id) }
    }

    private func fieldRow(
        field: AdminManageContactFormFieldOption,
        isSelected: Bool
    ) -> some FlowContent {
        Div {
            Span("⠿").class("contact-form-field-drag")
            Input()
                .type(.checkbox)
                .id("contact-form-field-\(field.id)")
                .name("fieldIds[]")
                .value(field.id)
                .if(isSelected) { $0.checked() }
            Label(field.label)
                .for("contact-form-field-\(field.id)")
                .class("contact-form-field-content")
            Div {
                Button("↑")
                    .type(.button)
                    .class("row-btn", "edit")
                    .data("contact-form-field-move", "up")
                    .ariaLabel("Move \(field.label) up")
                Button("↓")
                    .type(.button)
                    .class("row-btn", "edit")
                    .data("contact-form-field-move", "down")
                    .ariaLabel("Move \(field.label) down")
            }
            .class("contact-form-field-actions")
        }
        .class("contact-form-field-row", isSelected ? "is-selected" : "is-available")
        .data("contact-form-field", field.id)
    }

    private func reorderScript() -> String {
        #"""
        (function () {
            function bind() {
                var selected = document.querySelector('.contact-form-selected-fields');
                var available = document.querySelector('.contact-form-available-fields');
                var draggedField = null;

                if (!selected || !available) { return; }

                function updateDraggableState(field) {
                    field.setAttribute("draggable", "true");
                }

                selected.querySelectorAll('[data-contact-form-field]').forEach(updateDraggableState);
                available.querySelectorAll('[data-contact-form-field]').forEach(updateDraggableState);

                function dragStart(event) {
                    var field = event.target.closest('[data-contact-form-field]');
                    if (!field || field.getAttribute("draggable") !== "true") { return; }
                    draggedField = field;
                    field.classList.add("is-dragging");
                    if (event.dataTransfer) { event.dataTransfer.effectAllowed = "move"; }
                }

                function dragEnd() {
                    if (draggedField) { draggedField.classList.remove("is-dragging"); }
                    draggedField = null;
                }

                function dragOver(event) {
                    if (!draggedField) { return; }
                    event.preventDefault();
                    if (event.dataTransfer) { event.dataTransfer.dropEffect = "move"; }
                }

                function drop(event) {
                    event.preventDefault();
                    if (!draggedField) { return; }
                    var list = event.currentTarget;
                    var target = event.target.closest('[data-contact-form-field]');
                    var isSelectedList = list === selected;
                    var checkbox = draggedField.querySelector('input[type="checkbox"]');
                    if (checkbox) { checkbox.checked = isSelectedList; }
                    draggedField.classList.toggle("is-selected", isSelectedList);
                    draggedField.classList.toggle("is-available", !isSelectedList);
                    if (target && target !== draggedField && target.parentNode === list) {
                        var bounds = target.getBoundingClientRect();
                        var insertBefore = event.clientY < bounds.top + bounds.height / 2;
                        list.insertBefore(draggedField, insertBefore ? target : target.nextElementSibling);
                    } else {
                        list.appendChild(draggedField);
                    }
                }

                [selected, available].forEach(function (list) {
                    list.addEventListener("dragstart", dragStart);
                    list.addEventListener("dragend", dragEnd);
                    list.addEventListener("dragover", dragOver);
                    list.addEventListener("drop", drop);
                });

                document.querySelectorAll('[data-contact-form-field-move]').forEach(function (button) {
                    if (button.dataset.bound === "1") { return; }
                    button.dataset.bound = "1";
                    button.addEventListener("click", function () {
                        var field = button.closest('[data-contact-form-field]');
                        if (!field) { return; }
                        var direction = button.getAttribute("data-contact-form-field-move");
                        var list = field.parentNode;
                        var sibling = direction === "up" ? field.previousElementSibling : field.nextElementSibling;
                        if (!sibling || sibling.parentNode !== list) { return; }
                        if (direction === "up") {
                            field.parentNode.insertBefore(field, sibling);
                        } else {
                            field.parentNode.insertBefore(sibling, field);
                        }
                    });
                });

                document.querySelectorAll('[data-contact-form-field] input[type="checkbox"]').forEach(function (input) {
                    if (input.dataset.bound === "1") { return; }
                    input.dataset.bound = "1";
                    input.addEventListener("change", function () {
                        var field = input.closest('[data-contact-form-field]');
                        var selected = document.querySelector('.contact-form-selected-fields');
                        var available = document.querySelector('.contact-form-available-fields');
                        if (!field || !selected || !available) { return; }
                        if (input.checked) {
                            selected.appendChild(field);
                            field.classList.remove("is-available");
                            field.classList.add("is-selected");
                        } else {
                            available.appendChild(field);
                            field.classList.remove("is-selected");
                            field.classList.add("is-available");
                        }
                        updateDraggableState(field);
                    });
                });
            }
            if (document.readyState === "loading") {
                document.addEventListener("DOMContentLoaded", bind, { once: true });
            } else {
                bind();
            }
        })();
        """#
    }
}
