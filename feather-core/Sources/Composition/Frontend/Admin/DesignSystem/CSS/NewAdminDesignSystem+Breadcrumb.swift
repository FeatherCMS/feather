import CSS
import WebBuilders

extension NewAdminDesignSystem {

    @Builder<CSS.Rule>
    func breadcrumb(
    ) -> [any Rule] {
        Media {
            Custom(".breadcrumb") {
                MarginBottom(15.px)
            }
            Custom(".breadcrumb ol") {
                ListStyle(.none)
                Margin(0)
                Padding(0)
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(5.px)
            }
            Custom(".breadcrumb li") {
                Display(.inlineFlex)
                AlignItems(.center)
                FontSize(0.84.rem)
                LineHeight(1.2)
            }
            Custom(".breadcrumb li:not(:last-child)::after") {
                Content(.string("\"›\""))
                MarginLeft(5.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom(".breadcrumb li a") {
                Display(.inlineFlex)
                AlignItems(.center)
                Padding(vertical: 5.px, horizontal: 10.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
                TextDecoration(.none)
                BorderRadius(10.px)
                UnsafeRawProperty(
                    name: "transition",
                    value: "background-color 0.18s ease, color 0.18s ease"
                )
            }
            Custom(".breadcrumb li a:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Link.hover))
            }
        }
    }
}
