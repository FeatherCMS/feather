import FeatherWebAdmin
import Foundation
import HTML
import UserAdminAPI
import UserModule
import WebBuilders
import WebComponents

extension Identity.Add.Form {
    struct Component: WebComponents.Component {
        struct State: Sendable {
            var name: AdminFormFieldInput.State
            var status: AdminFormFieldSelect.State
            var roleOptions: [AdminFormFieldCheckboxGroup.Option]
            var roleIdsError: String?
            var error: String?

            mutating func apply(errors: [String: String]) {
                name.error = errors[name.name]
                status.error = errors[status.name]
                roleIdsError = errors["roleIds"] ?? errors["roleIds[]"]
            }

            static func empty(
                roleOptions: [Identity.Add.RoleOption] = []
            ) -> Self {
                .init(
                    name: .init(name: "name", label: "Name", isRequired: true),
                    status: .init(
                        name: "status",
                        label: "Status",
                        value: "invited",
                        options: statusOptions,
                        isRequired: true
                    ),
                    roleOptions: roleOptions.map {
                        .init(label: $0.name, value: $0.id)
                    },
                    roleIdsError: nil,
                    error: nil
                )
            }

            static func from(
                name: String,
                status: String,
                roleIds: [String] = [],
                roleOptions: [Identity.Add.RoleOption] = []
            ) -> Self {
                let selected = Set(roleIds)
                return .init(
                    name: .init(
                        name: "name",
                        label: "Name",
                        value: name,
                        isRequired: true
                    ),
                    status: .init(
                        name: "status",
                        label: "Status",
                        value: status,
                        options: statusOptions,
                        isRequired: true
                    ),
                    roleOptions: roleOptions.map {
                        .init(
                            label: $0.name,
                            value: $0.id,
                            isSelected: selected.contains($0.id)
                        )
                    },
                    roleIdsError: nil,
                    error: nil
                )
            }

            private static var statusOptions:
                [AdminFormFieldSelect.SelectOption]
            {
                UserAdminAPI.Components.Schemas.UserIdentityStatusField.allCases
                    .map {
                        .init(
                            label: $0.rawValue.capitalized,
                            value: $0.rawValue
                        )
                    }
            }
        }

        let state: State
        let action: String
        let submitLabel: String
        let nonceToken: String?

        func html(context: inout BuilderContext) -> Form {
            let form = AdminForm(action: action, nonceToken: nonceToken) {
                if let error = state.error {
                    P(error).class("admin-form__error")
                }
                context.build(
                    AdminFormFieldInput(state: state.name)
                        .setAsRemoveConfirmationLabel()
                )
                context.build(AdminFormFieldSelect(state: state.status))
                if !state.roleOptions.isEmpty {
                    context.build(
                        AdminFormFieldCheckboxGroup(
                            name: "roleIds[]",
                            label: "Roles",
                            options: state.roleOptions,
                            error: state.roleIdsError
                        )
                    )
                }
                Div {
                    context.build(
                        AdminSubmitButton(submitLabel, style: .primary)
                    )
                }
                .class("admin-form__actions")
            }
            return context.build(form)
        }
    }
}
