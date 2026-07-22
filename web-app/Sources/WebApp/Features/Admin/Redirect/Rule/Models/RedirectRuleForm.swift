import CSS
import HTML
import SGML
import WebStandards

struct RedirectRuleForm: Component, FlowContent {

    private static let statusOptions = [
        ("301", "301 Moved Permanently"),
        ("302", "302 Found"),
        ("307", "307 Temporary Redirect"),
        ("308", "308 Permanent Redirect"),
    ]

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
        var source: FieldState
        var destination: FieldState
        var statusCode: FieldState
        var notes: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            source.error = errors[source.key]
            destination.error = errors[destination.key]
            statusCode.error = errors[statusCode.key]
            notes.error = errors[notes.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
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

            FormInputField(
                name: state.source.key,
                label: state.source.label,
                value: state.source.value,
                error: state.source.error,
                isRequired: true
            )

            FormInputField(
                name: state.destination.key,
                label: state.destination.label,
                value: state.destination.value,
                error: state.destination.error,
                isRequired: true
            )

            FormSelectField(
                name: state.statusCode.key,
                label: state.statusCode.label,
                options: Self.statusOptions.map {
                    .init(label: $0.1, value: $0.0)
                },
                selectedValue: state.statusCode.value ?? "301",
                error: state.statusCode.error,
                isRequired: true
            )

            FormInputField(
                name: state.notes.key,
                label: state.notes.label,
                value: state.notes.value,
                error: state.notes.error
            )

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
