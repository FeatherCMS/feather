import CSS
import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminGetDesignSystemComponent: Branch {

    let breadcrumb: NewAdminBreadcrumb

    init() {
        self.breadcrumb = .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Lorem ipsum", link: "/admin/"),
                .init(label: "Design System", link: "/admin/design-system/"),
                .init(label: "Components", link: "#components"),
                .init(label: "Breadcrumb", link: "#breadcrumb")
            ]
        )
    }

    var children: [any Component] {
        breadcrumb
    }

    func rules() -> [any Rule] {
        Media {
            Custom(".design-system-color-group + .design-system-color-group") {
                MarginTop(32.px)
            }
            Custom(".design-system-color-grid") {
                Display(.grid)
                GridTemplateColumns(.repeat(4, .fraction(1.fr)))
                Gap(16.px)
            }
            Custom(".design-system-color-swatch") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            }
            Custom(".design-system-color-swatch-preview") {
                Width(100.percent)
                Height(96.px)
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(8.px)
                BoxSizing(.borderBox)
            }
            Custom(".design-system-color-swatch-label") {
                FontSize(0.8.rem)
            }
            Custom(".design-system-component-group + .design-system-component-group") {
                MarginTop(24.px)
            }
            Custom(".design-system-component-row") {
                Display(.flex)
                AlignItems(.center)
                FlexWrap(.wrap)
                Gap(12.px)
            }
            Custom(".button-row .feather-button") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontWeight(.number(700))
                BorderRadius(999.px)
                Padding(vertical: 10.px, horizontal: 16.px)
                Cursor(.pointer)
                TextDecoration(.none)
                UnsafeRawProperty(
                    name: "transition",
                    value: "background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease"
                )
            }
            Custom(".button-row .feather-button--primary") {
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                BorderColor(.variable(TokenKey.Colors.Accents.Primary.border))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            }
            Custom(".button-row .feather-button--primary:hover") {
                Background(.variable(TokenKey.Colors.Accents.Primary.hover))
            }
            Custom(".button-row .feather-button--secondary") {
                Background(.variable(TokenKey.Colors.Accents.Secondary.tint))
                BorderColor(.variable(TokenKey.Colors.Accents.Secondary.border))
                Color(.variable(TokenKey.Colors.Accents.Secondary.text))
            }
            Custom(".button-row .feather-button--secondary:hover") {
                Background(.variable(TokenKey.Colors.Accents.Secondary.hover))
            }
            Custom(".button-row .feather-button--destructive") {
                Background(.variable(TokenKey.Colors.Buttons.Destructive.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Destructive.border))
                Color(.variable(TokenKey.Colors.Buttons.Destructive.text))
            }
            Custom(".button-row .feather-button--destructive:hover") {
                Background(.variable(TokenKey.Colors.Buttons.Destructive.hover))
            }
            Custom(".button-row .feather-button--primary-ghost") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Primary.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Ghost.Primary.border))
                Color(.variable(TokenKey.Colors.Buttons.Ghost.Primary.text))
            }
            Custom(".button-row .feather-button--primary-ghost:hover") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Primary.hover))
            }
            Custom(".button-row .feather-button--secondary-ghost") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.border))
                Color(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.text))
            }
            Custom(".button-row .feather-button--secondary-ghost:hover") {
                Background(.variable(TokenKey.Colors.Buttons.Ghost.Secondary.hover))
            }
            Custom(".button-row .feather-button--disabled") {
                Background(.variable(TokenKey.Colors.Buttons.Disabled.tint))
                BorderColor(.variable(TokenKey.Colors.Buttons.Disabled.border))
                Color(.variable(TokenKey.Colors.Buttons.Disabled.text))
                Cursor(.notAllowed)
            }
            Custom(".button-row .feather-button--disabled:hover") {
                Background(.variable(TokenKey.Colors.Buttons.Disabled.hover))
            }
            Custom(".button-row .feather-button--action") {
                BorderRadius(6.px)
                Padding(vertical: 7.px, horizontal: 10.px)
                FontSize(0.875.rem)
                FontWeight(.normal)
            }
        }
    }




    func html() -> Section {
        Section {
            breadcrumb.html()

            H1("Design System")
            P("Available design-system materials, colors, and components.")

            Section {
                H2("Materials")
                colorGroup(
                    title: "Primary",
                    swatches: swatches(prefix: "material-color-primary")
                )
                colorGroup(
                    title: "Secondary",
                    swatches: swatches(prefix: "material-color-secondary")
                )
                colorGroup(
                    title: "Tertiary",
                    swatches: swatches(prefix: "material-color-tertiary")
                )
            }
            .class("cms-section")

            Section {
                H2("Accents")
                colorGroup(
                    title: "Primary",
                    swatches: swatches(prefix: "accent-color-primary")
                )
                colorGroup(
                    title: "Secondary",
                    swatches: swatches(prefix: "accent-color-secondary")
                )
            }
            .class("cms-section")

            Section {
                H2("Button colors")
                colorGroup(
                    title: "Destructive",
                    swatches: swatches(prefix: "destructive-button-color")
                )
                colorGroup(
                    title: "Primary ghost",
                    swatches: swatches(prefix: "ghost-button-color-primary")
                )
                colorGroup(
                    title: "Secondary ghost",
                    swatches: swatches(prefix: "ghost-button-color-secondary")
                )
                colorGroup(
                    title: "Disabled",
                    swatches: swatches(prefix: "disabled-button-color")
                )
            }
            .class("cms-section")

            Section {
                H2("Links")
                colorGroup(
                    title: "Link states",
                    swatches: swatches(
                        prefix: "link-color",
                        suffixes: ["default", "hover", "visited", "active"]
                    )
                )
            }
            .class("cms-section")

            Section {
                H2("Components")

                Div {
                    H3("Buttons")
                    Div {
                        PrimaryButton("Primary", href: "#primary")
                        SecondaryButton("Secondary", href: "#secondary")
                        PrimaryGhostButton("Primary ghost", href: "#primary-ghost")
                        SecondaryGhostButton("Secondary ghost", href: "#secondary-ghost")
                        DestructiveButton("Destructive", href: "#destructive")
                        DisabledButton("Disabled")
                    }
                    .class("design-system-component-row", "button-row")
                    A("Sample link")
                        .href("#sample-link")
                        .class("design-system-sample-link")
                }
                .class("design-system-component-group")

                Div {
                    H3("Action buttons")
                    Div {
                        PrimaryActionButton("Primary", href: "#primary-action")
                        SecondaryActionButton("Secondary", href: "#secondary-action")
                        PrimaryGhostActionButton("Primary ghost", href: "#primary-ghost-action")
                        SecondaryGhostActionButton("Secondary ghost", href: "#secondary-ghost-action")
                        DestructiveActionButton("Destructive", href: "#destructive-action")
                        DisabledActionButton("Disabled")
                    }
                    .class("design-system-component-row", "button-row")
                }
                .class("design-system-component-group")
            }
            .class("cms-section")
        }
        .class("cms-section")
    }

    private func colorGroup(
        title: String,
        swatches: [DesignSystemSwatch]
    ) -> Div {
        Div {
            H3(title)
            Div {
                for swatch in swatches {
                    colorSwatch(swatch)
                }
            }
            .class("design-system-color-grid")
        }
        .class("design-system-color-group")
    }

    private func colorSwatch(_ swatch: DesignSystemSwatch) -> Div {
        Div {
            Div {}
                .class("design-system-color-swatch-preview")
                .style("background-color: var(--\(swatch.variable));")
            Span(swatch.label)
                .class("design-system-color-swatch-label")
        }
        .class("design-system-color-swatch")
    }

    private func swatches(
        prefix: String,
        suffixes: [String] = ["tint", "hover", "border", "text"]
    ) -> [DesignSystemSwatch] {
        suffixes.map { suffix in
            DesignSystemSwatch(
                label: suffix,
                variable: "\(prefix)-\(suffix)"
            )
        }
    }
}

private struct DesignSystemSwatch: Sendable {
    let label: String
    let variable: String
}
