import CSS
import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct ContactFormForm: Component {
    struct State: FeatherAdmin.Object {
        var name: String
        var successMessage: String
        var failureMessage: String
        var redirectUrl: String?
        var fieldIDs: [String]
        var availableFields: [AdminContactFormFieldOption]
        var mails: [AdminContactFormEmail]
        var error: String?
        var success: String?
    }

    var state: State
    var action: String
    var submitLabel: String
    var isReadOnly: Bool = false

    func selectors() -> [any Selector] {
        [
            Class("contact-form-field-picker") {
                Display(.grid)
                Gap(16.px)
                MarginTop(8.px)
            },
            Class("contact-form-field-group") {
                Display(.grid)
                Gap(8.px)
            },
            Custom(".contact-form-field-group-title") {
                Margin(0)
                FontSize(0.95.rem)
                FontWeight(.number(600))
            },
            Custom(".contact-form-field-group-help") {
                Margin(0)
                FontSize(0.9.rem)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Class("contact-form-field-list") {
                Display(.grid)
                Gap(8.px)
            },
            Class("contact-form-field-row") {
                Display(.flex)
                AlignItems(.center)
                Gap(10.px)
                Padding(vertical: 10.px, horizontal: 12.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(10.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Class("contact-form-field-drag") {
                FontSize(18.px)
                Width(18.px)
                TextAlign(.center)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Class("contact-form-field-content") {
                Flex(1)
                MinWidth(0.px)
            },
            Class("contact-form-field-actions") {
                Display(.flex)
                Gap(4.px)
                AlignItems(.center)
            },
            Custom(
                ".contact-form-field-row.is-available .contact-form-field-actions"
            ) { Display(.none) },
            Custom(
                ".contact-form-field-row.is-selected, .contact-form-field-row.is-available"
            ) { UnsafeRawProperty(name: "cursor", value: "grab") },
            Custom(".contact-form-field-row.is-dragging") { Opacity(0.55) },
            Custom(".contact-form-field-row.is-drop-before") {
                UnsafeRawProperty(
                    name: "box-shadow",
                    value: "inset 0 3px 0 var(--link-color-hover)"
                )
            },
            Custom(".contact-form-field-row.is-drop-after") {
                UnsafeRawProperty(
                    name: "box-shadow",
                    value: "inset 0 -3px 0 var(--link-color-hover)"
                )
            },
            Custom(".contact-form-field-list.is-drop-zone") {
                UnsafeRawProperty(
                    name: "outline",
                    value: "2px dashed var(--link-color-hover)"
                )
                UnsafeRawProperty(name: "outline-offset", value: "4px")
            },
        ]
    }

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let success = state.success {
                P(success).class("new-admin-form__success")
            }
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "name",
                        label: "Name",
                        value: state.name,
                        isRequired: true,
                        isReadOnly: isReadOnly
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "successMessage",
                        label: "Success message",
                        value: state.successMessage,
                        help: "Shown after a successful submission.",
                        isReadOnly: isReadOnly
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "failureMessage",
                        label: "Failure message",
                        value: state.failureMessage,
                        help: "Shown when a submission cannot be processed.",
                        isReadOnly: isReadOnly
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "redirectUrl",
                        label: "Redirect URL",
                        value: state.redirectUrl ?? "",
                        help: "Optional URL to use after submission.",
                        isReadOnly: isReadOnly
                    )
                )
            )
            if !state.availableFields.isEmpty {
                Section {
                    H3("Fields").class("contact-form-field-group-title")
                    P(
                        "Choose fields and drag selected fields to set their order."
                    )
                    .class("contact-form-field-group-help")
                    Div {
                        Div {
                            H4("Selected fields")
                                .class("contact-form-field-group-title")
                            Div {
                                for field in selectedFields {
                                    fieldRow(
                                        field: field,
                                        isSelected: true,
                                        context: &context
                                    )
                                }
                            }
                            .class(
                                "contact-form-field-list",
                                "contact-form-selected-fields"
                            )
                        }
                        .class("contact-form-field-group")
                        Div {
                            H4("Available fields")
                                .class("contact-form-field-group-title")
                            Div {
                                for field in availableUnselectedFields {
                                    fieldRow(
                                        field: field,
                                        isSelected: false,
                                        context: &context
                                    )
                                }
                            }
                            .class(
                                "contact-form-field-list",
                                "contact-form-available-fields"
                            )
                        }
                        .class("contact-form-field-group")
                    }
                    .class("contact-form-field-picker")
                }
            }
            if !isReadOnly {
                Div { context.build(NewAdminSubmitButton(submitLabel)) }
                    .class("new-admin-form__actions")
                Script(reorderScript())
            }
        }
        return context.build(form)
    }

    private var selectedFields: [AdminContactFormFieldOption] {
        let fieldsByID = Dictionary(
            uniqueKeysWithValues: state.availableFields.map { ($0.id, $0) }
        )
        return state.fieldIDs.compactMap { fieldsByID[$0] }
    }

    private var availableUnselectedFields: [AdminContactFormFieldOption] {
        let selectedIDs = Set(state.fieldIDs)
        return state.availableFields.filter { !selectedIDs.contains($0.id) }
    }

    private func fieldRow(
        field: AdminContactFormFieldOption,
        isSelected: Bool,
        context: inout BuilderContext
    ) -> some FlowContent {
        Div {
            Span("⠿").class("contact-form-field-drag")
            context.build(fieldCheckbox(field: field, isSelected: isSelected))
            Label(field.label).for("contact-form-field-\(field.id)")
                .class("contact-form-field-content")
            Div {
                if !isReadOnly {
                    Button("↑").type(.button).class("button", "ghost-secondary")
                        .data("contact-form-field-move", "up")
                        .ariaLabel("Move \(field.label) up")
                    Button("↓").type(.button).class("button", "ghost-secondary")
                        .data("contact-form-field-move", "down")
                        .ariaLabel("Move \(field.label) down")
                }
            }
            .class("contact-form-field-actions")
        }
        .class(
            "contact-form-field-row",
            isSelected ? "is-selected" : "is-available"
        )
        .data("contact-form-field", field.id)
    }

    private func fieldCheckbox(
        field: AdminContactFormFieldOption,
        isSelected: Bool
    ) -> NewAdminCheckbox {
        .init(
            name: "fieldIds[]",
            value: field.id,
            id: "contact-form-field-\(field.id)",
            ariaLabel: "Select \(field.label)",
            isChecked: isSelected,
            isDisabled: isReadOnly
        )
    }

    private func reorderScript() -> String {
        #"""
        (function () {
            function bind() {
                var selected = document.querySelector('.contact-form-selected-fields');
                var available = document.querySelector('.contact-form-available-fields');
                var draggedField = null;
                if (!selected || !available) { return; }
                function update(field) { field.setAttribute('draggable', 'true'); }
                selected.querySelectorAll('[data-contact-form-field]').forEach(update);
                available.querySelectorAll('[data-contact-form-field]').forEach(update);
                function clear() { document.querySelectorAll('.is-drop-before,.is-drop-after').forEach(function (f) { f.classList.remove('is-drop-before','is-drop-after'); }); selected.classList.remove('is-drop-zone'); available.classList.remove('is-drop-zone'); }
                function start(e) { var field = e.target.closest('[data-contact-form-field]'); if (!field) { return; } draggedField = field; field.classList.add('is-dragging'); }
                function end() { if (draggedField) { draggedField.classList.remove('is-dragging'); } clear(); draggedField = null; }
                function over(e) { if (!draggedField) { return; } e.preventDefault(); clear(); var target = e.target.closest('[data-contact-form-field]'); if (target && target !== draggedField && target.parentNode === e.currentTarget) { target.classList.add(e.clientY < target.getBoundingClientRect().top + target.offsetHeight / 2 ? 'is-drop-before' : 'is-drop-after'); } else { e.currentTarget.classList.add('is-drop-zone'); } }
                function drop(e) { e.preventDefault(); if (!draggedField) { return; } var list = e.currentTarget; var target = e.target.closest('[data-contact-form-field]'); var selectedList = list === selected; var checkbox = draggedField.querySelector('input[type=checkbox]'); if (checkbox) { checkbox.checked = selectedList; } draggedField.classList.toggle('is-selected', selectedList); draggedField.classList.toggle('is-available', !selectedList); if (target && target !== draggedField && target.parentNode === list) { list.insertBefore(draggedField, e.clientY < target.getBoundingClientRect().top + target.offsetHeight / 2 ? target : target.nextElementSibling); } else { list.appendChild(draggedField); } clear(); }
                [selected, available].forEach(function (list) { list.addEventListener('dragstart', start); list.addEventListener('dragend', end); list.addEventListener('dragover', over); list.addEventListener('drop', drop); });
                document.querySelectorAll('[data-contact-form-field-move]').forEach(function (button) { button.addEventListener('click', function () { var field = button.closest('[data-contact-form-field]'); var sibling = button.dataset.contactFormFieldMove === 'up' ? field.previousElementSibling : field.nextElementSibling; if (sibling) { field.parentNode.insertBefore(button.dataset.contactFormFieldMove === 'up' ? field : sibling, button.dataset.contactFormFieldMove === 'up' ? sibling : field); } }); });
                document.querySelectorAll('[data-contact-form-field] input[type=checkbox]').forEach(function (input) { input.addEventListener('change', function () { var field = input.closest('[data-contact-form-field]'); var list = input.checked ? selected : available; list.appendChild(field); field.classList.toggle('is-selected', input.checked); field.classList.toggle('is-available', !input.checked); update(field); }); });
            }
            if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', bind, { once: true }); } else { bind(); }
        })();
        """#
    }
}
