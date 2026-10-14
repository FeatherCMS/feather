import CSS
import WebBuilders

extension NewAdminDesignSystem {

    @Builder<CSS.Rule>
    func topbar() -> [any Rule] {
        Media {
            Class("top-bar") {
                Position(.relative)
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Padding(vertical: 12.px, horizontal: 16.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
            }
            Class("top-bar-brand") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            }
            Class("top-bar-title") {
                Position(.absolute)
                Left(50.percent)
                Transform(.translateX((-50).percent))
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                TextAlign(.center)
                UnsafeRawProperty(
                    name: "max-width",
                    value: "calc(100% - 120px)"
                )
            }
            Custom(".top-bar-title h1") {
                Margin(0.px)
                FontSize(24.px)
                WhiteSpace(.nowrap)
                Overflow(.hidden)
                TextOverflow(.ellipsis)
            }
            Custom(
                ".top-bar-title-link, .top-bar-title-link:hover, .top-bar-title-link:visited, .top-bar-title-link:active"
            ) {
                BackgroundImage(
                    .linearGradient(
                        LinearGradient(
                            direction: .angle(120.deg),
                            stops: [
                                .init(
                                    CSSColor(
                                        stringLiteral:
                                            "var(--\(TokenKey.Colors.Accents.Primary.tint.propertyName))"
                                    ),
                                    0.percent
                                ),
                                .init(
                                    CSSColor(
                                        stringLiteral:
                                            "var(--\(TokenKey.Colors.Accents.Secondary.tint.propertyName))"
                                    ),
                                    100.percent
                                ),
                            ]
                        )
                    )
                )
                UnsafeRawProperty(
                    name: "-webkit-background-clip",
                    value: "text"
                )
                UnsafeRawProperty(name: "background-clip", value: "text")
                Color(.transparent)
                WebkitTextFillColor(.transparent)
                TextDecoration(.none)
            }
            Class("menu-trigger") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Cursor(.pointer)
                Padding(2.px)
            }
            Class("menu-trigger-icon") {
                Display(.block)
            }
            Custom(".menu-trigger .sr-only, .account-trigger .sr-only") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Padding(0)
                Margin((-1).px)
                Overflow(.hidden)
                Clip(.shape("rect(0, 0, 0, 0)"))
                WhiteSpace(.nowrap)
                Border(0)
            }
            Custom("#accountToggle, #accountToggle + .account-trigger") {
                Cursor(.pointer)
            }
            Id("accountToggle") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Opacity(0)
                PointerEvents(.none)
            }
            Class("account-trigger") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Padding(2.px)
            }
            Custom(".account-trigger img") {
                Display(.block)
                Width(28.px)
                Height(28.px)
                BorderRadius(999.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                BoxSizing(.borderBox)
            }
            Custom(".menu-trigger-icon, .account-trigger .account-profile-icon")
            {
                Display(.block)
                Width(24.px)
                Height(24.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                UnsafeRawProperty(name: "stroke-width", value: "2")
            }
            Class("account-menu") {
                Position(.absolute)
                Right(0.px)
                Top(40.px)
                MinWidth(140.px)
                ListStyle(.none)
                Padding(vertical: 8.px, horizontal: 0.px)
                Margin(0)
                Display(.none)
                ZIndex(.number(20))
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(10.px)
                BoxShadow(
                    0.px,
                    10.px,
                    blur: 24.px,
                    color: CSSColor(
                        stringLiteral:
                            "var(--\(TokenKey.Colors.BoxShadow.tint.propertyName))"
                    )
                )
            }
            Custom(".account-menu li a") {
                Display(.block)
                Padding(vertical: 8.px, horizontal: 12.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                TextDecoration(.none)
            }
            Custom("#accountToggle:checked + .account-trigger + .account-menu")
            {
                Display(.block)
            }
            Custom(".account-menu li a:hover, .account-menu li a:focus-visible")
            {
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            }
            Custom(".menu-trigger-mobile line") {
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 0.32s ease 0s"
                )
                UnsafeRawProperty(name: "transform-origin", value: "center")
                UnsafeRawProperty(name: "transform-box", value: "fill-box")
            }
            Class("top-bar-actions") {
                Display(.flex)
                AlignItems(.center)
                Position(.relative)
            }
        }
    }
}
