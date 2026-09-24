public import CSS
import Foundation
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminStatusSelectField: Component {
    public let formID: String
    public let selectedStatus: String
    public let options: [String]

    public init(
        formID: String,
        selectedStatus: String,
        options: [String] = ["draft", "published", "archived"]
    ) {
        self.formID = formID
        self.selectedStatus = selectedStatus
        self.options = options
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-status-select") {
                MinHeight(32.px)
                MinWidth(6.75.rem)
                Padding(vertical: 7.px, horizontal: 9.px)
                PaddingRight(30.px)
                FontSize(0.875.rem)
                LineHeight(1.2)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
                UnsafeRawProperty(name: "appearance", value: "none")
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value: "calc(100% - 14px) 50%, calc(100% - 9px) 50%"
                )
                UnsafeRawProperty(name: "background-size", value: "5px 5px")
                UnsafeRawProperty(name: "background-repeat", value: "no-repeat")
            },
            Class("new-admin-status-select:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Select {
        Select {
            for option in options {
                Option(option.capitalized)
                    .value(option)
                    .if(option == selectedStatus) { $0.selected() }
            }
        }
        .name("status")
        .form(formID)
        .onChange("document.getElementById('\(formID)').requestSubmit();")
        .class("new-admin-status-select")
    }
}
