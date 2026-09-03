import CSS
import FeatherAdmin
import HTML
import SGML
import UserAdminAPI
import WebStandards
import Foundation

struct UserIdentityForm: Component, FlowContent {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var isRequired: Bool
        var value: String?
        var error: String?
    }

    struct RoleOptionState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String
        var isSelected: Bool
    }

    struct State: FeatherAdmin.Object {
        var status: FieldState
        var roleOptions: [RoleOptionState]
        var roleIdsError: String?
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            status.error = errors[status.key]
            roleIdsError = errors["roleIds"] ?? errors["roleIds[]"]
        }
    }

    var state: State
    var action: String = "/admin/user/identities/add/"
    var submitLabel: String = "Add identity"
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormSelectField(
                name: state.status.key,
                label: state.status.label,
                options: UserAdminAPI.Components.Schemas
                    .UserIdentityStatusField.allCases
                    .map {
                        .init(
                            label: $0.rawValue.capitalized,
                            value: $0.rawValue
                        )
                    },
                selectedValue: state.status.value,
                error: state.status.error,
                isRequired: state.status.isRequired,
                selectClass: "text-input"
            )

            if !state.roleOptions.isEmpty {
                Section {
                    AdminFieldLabel(label: "Roles", required: false)
                    Div {
                        for option in state.roleOptions {
                            Label {
                                Input()
                                    .type(.checkbox)
                                    .name(option.key)
                                    .value(option.value)
                                    .if(option.isSelected) { $0.checked() }
                                InlineText(option.label)
                            }
                            .class("multi-option")
                        }
                    }
                    .class("checkbox-multiselect")
                    if let error = state.roleIdsError {
                        Span(error).class("field-error")
                    }
                }
                .if(state.roleIdsError != nil) { $0.class("has-error") }
            }

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        )
                    }
                }
                .class("button-row")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }
}
