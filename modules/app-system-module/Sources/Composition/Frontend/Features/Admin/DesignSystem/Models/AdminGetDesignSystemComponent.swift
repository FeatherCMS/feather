import CSS
import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminGetDesignSystemComponent: Component {

    let breadcrumb: NewAdminBreadcrumb
    let primaryLink = NewAdminButton("Primary", href: "#primary", style: .primary)
    let secondaryLink = NewAdminButton("Secondary", href: "#secondary", style: .secondary)
    let ghostPrimaryLink = NewAdminButton("Primary ghost", href: "#ghost-primary", style: .ghost(.primary))
    let ghostSecondaryLink = NewAdminButton("Secondary ghost", href: "#ghost-secondary", style: .ghost(.secondary))
    let destructiveLink = NewAdminButton("Destructive", href: "#destructive", style: .destructive)
    let disabledLink = NewAdminButton("Disabled", style: .disabled)
    let primaryRowLink = NewAdminRowButton("Primary", href: "#primary-action", style: .primary)
    let secondaryRowLink = NewAdminRowButton("Secondary", href: "#secondary-action", style: .secondary)
    let ghostPrimaryRowLink = NewAdminRowButton("Primary ghost", href: "#ghost-primary-action", style: .ghost(.primary))
    let ghostSecondaryRowLink = NewAdminRowButton("Secondary ghost", href: "#ghost-secondary-action", style: .ghost(.secondary))
    let destructiveRowLink = NewAdminRowButton("Destructive", href: "#destructive-action", style: .destructive)
    let disabledRowLink = NewAdminRowButton("Disabled", style: .disabled)

    init() {
        self.breadcrumb = .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Lorem ipsum", link: "/admin/"),
                .init(label: "Design System", link: "/admin/design-system/"),
                .init(label: "Components", link: "#components")]
        )
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

        }
    }




    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(breadcrumb)

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
                        context.render(primaryLink)
                        context.render(secondaryLink)
                        context.render(ghostPrimaryLink)
                        context.render(ghostSecondaryLink)
                        context.render(destructiveLink)
                        context.render(disabledLink)
                    }
                    .class("design-system-component-row")
                    A("Sample link")
                        .href("#sample-link")
                        .class("design-system-sample-link")
                }
                .class("design-system-component-group")

                Div {
                    H3("Row buttons")
                    Div {
                        context.render(primaryRowLink)
                        context.render(secondaryRowLink)
                        context.render(ghostPrimaryRowLink)
                        context.render(ghostSecondaryRowLink)
                        context.render(destructiveRowLink)
                        context.render(disabledRowLink)
                    }
                    .class("design-system-component-row")
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
