import AnalyticsModule
import CSS
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension Log.List.Filter {
    struct DateRange: WebComponents.Component {
        struct QueryItem: Sendable {
            let name: String
            let value: String
        }

        struct State: Sendable {
            let action: String
            let from: String
            let to: String
            let queryItems: [QueryItem]
        }

        let state: State

        func rules() -> [any Rule] {
            Media {
                Custom(".analytics-date-range-filter__fields") {
                    Display(.grid)
                    GridTemplateColumns(
                        .tracks([
                            .fraction(1.fr), .fraction(1.fr), .auto,
                        ])
                    )
                    AlignItems(.center)
                    Gap(16.px)
                }
                Custom(
                    ".analytics-date-range-filter__fields "
                        + ".admin-date-picker .admin-form-field-label"
                ) {
                    Display(.none)
                }
            }
            Media(.maxWidth(768.px)) {
                Custom(".analytics-date-range-filter__fields") {
                    GridTemplateColumns(.fraction(1.fr))
                }
            }
        }

        func html(context: inout BuilderContext) -> Form {
            let form = AdminForm(
                action: state.action,
                method: .get,
                hiddenFields: state.queryItems.map {
                    .init(name: $0.name, value: $0.value)
                }
            ) {
                Div {
                    context.build(
                        AdminFormFieldDatePicker(
                            state: .init(
                                name: "from",
                                label: "From",
                                value: state.from,
                                placeholder: "Select start date and time"
                            )
                        )
                    )
                    context.build(
                        AdminFormFieldDatePicker(
                            state: .init(
                                name: "to",
                                label: "To",
                                value: state.to,
                                placeholder: "Select end date and time"
                            )
                        )
                    )
                    context.build(
                        AdminSubmitButton(
                            "Apply",
                            style: .ghost(.primary),
                            isRowButton: true
                        )
                    )
                }
                .class("analytics-date-range-filter__fields")
            }
            return context.build(form)
        }
    }
}
