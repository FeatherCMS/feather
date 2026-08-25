import FeatherAdmin
import Foundation
import HTML
import SGML
import WebStandards

struct WebMenuItemPermissionPicker: Component, FlowContent {

    struct State {
        let field: WebMenuItemForm.FieldState
        let permissions: [String]
    }

    let state: State

    func content() -> some BasicTag {
        FormSelectField(
            name: state.field.key,
            label: state.field.label,
            options: options(),
            selectedValue: state.field.value ?? "",
            error: state.field.error
        )
    }

    private func options() -> [FormSelectField.Option] {
        var options = [
            FormSelectField.Option(
                label: "No permission",
                value: ""
            )
        ]
        let selectedValue = state.field.value ?? ""
        let availablePermissions = Set(state.permissions)

        options += state.permissions.map {
            FormSelectField.Option(label: $0, value: $0)
        }
        if !selectedValue.isEmpty
            && !availablePermissions.contains(selectedValue)
        {
            options.append(
                .init(
                    label: "\(selectedValue) (unavailable)",
                    value: selectedValue
                )
            )
        }
        return options
    }
}
