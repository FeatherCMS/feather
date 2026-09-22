import FeatherAdmin
import Foundation
import HTML
import UserAdminAPI
import WebBuilders
import WebComponents

struct UserIdentityEditForm: Component {
    struct State: Sendable {
        var name: NewAdminFormFieldInput.State
        var status: NewAdminFormFieldSelect.State
        var roleOptions: [NewAdminFormFieldCheckboxGroup.Option]
        var roleIdsError: String?
        var error: String?

        mutating func apply(errors: [String: String]) {
            name.error = errors[name.name]
            status.error = errors[status.name]
            roleIdsError = errors["roleIds"] ?? errors["roleIds[]"]
        }

        static func empty(
            roleOptions: [UserIdentityEditRoleOptionModel] = []
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
            roleOptions: [UserIdentityEditRoleOptionModel] = []
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

        private static var statusOptions: [NewAdminFormFieldSelect.SelectOption]
        {
            UserAdminAPI.Components.Schemas.UserIdentityStatusField.allCases.map
            {
                .init(label: $0.rawValue.capitalized, value: $0.rawValue)
            }
        }
    }

    let state: State
    let action: String
    let submitLabel: String
    let viewHref: String?
    let removeHref: String?
    let nonceToken: String?

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: nonceToken) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(NewAdminFormFieldInput(state: state.name))
            context.build(NewAdminFormFieldSelect(state: state.status))
            if !state.roleOptions.isEmpty {
                context.build(
                    NewAdminFormFieldCheckboxGroup(
                        name: "roleIds[]",
                        label: "Roles",
                        options: state.roleOptions,
                        error: state.roleIdsError
                    )
                )
            }
            Div {
                context.build(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
                if let viewHref {
                    context.build(
                        NewAdminButton(
                            "View",
                            href: viewHref,
                            style: .secondary
                        )
                    )
                }
                if let removeHref {
                    context.build(
                        NewAdminButton(
                            "Remove",
                            href: removeHref,
                            style: .destructive
                        )
                    )
                }
            }
            .class("new-admin-form__actions")
        }
        return context.build(form)
    }
}
