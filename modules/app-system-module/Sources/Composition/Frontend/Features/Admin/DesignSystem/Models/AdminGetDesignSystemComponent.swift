import FeatherAdmin
import CSS
import HTML
import SGML
import WebComponents
import WebBuilders

struct AdminGetDesignSystemComponent: Leaf {

    func rules() -> [any Rule] {
        Media {
            Custom(".button-row .feather-button") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Border(1.px, .solid, .variable(TokenKey.Colors.Accent.Primary.default))
                Background(.variable(TokenKey.Colors.Accent.Primary.hover))
                Color(.white)
                FontWeight(.number(700))
                BorderRadius(999.px)
                Padding(vertical: 8.px, horizontal: 14.px)
                Cursor(.pointer)
                TextDecoration(.none)
                UnsafeRawProperty(
                    name: "transition",
                    value: "background-color 0.18s ease, border-color 0.18s ease, color 0.18s ease"
                )
            }
            Custom(".button-row .feather-button--primary") {
                Background(.variable(TokenKey.Colors.Accent.Primary.hover))
                BorderColor(.variable(TokenKey.Colors.Accent.Primary.default))
                Color(.white)
            }
            Custom(".button-row .feather-button--primary:hover") {
                Background(.variable(TokenKey.Colors.Accent.Primary.hover))
                BorderColor(.variable(TokenKey.Colors.Accent.Primary.default))
                Color(.white)
            }
            Custom(".button-row .feather-button--secondary") {
                Background(.variable(TokenKey.Colors.Accent.Secondary.default))
                BorderColor(.variable(TokenKey.Colors.Accent.Secondary.default))
                Color(.white)
            }
            Custom(".button-row .feather-button.feather-button--secondary:hover") {
                Background(.variable(TokenKey.Colors.Accent.Secondary.hover))
                BorderColor(.variable(TokenKey.Colors.Accent.Secondary.hover))
                Color(.white)
            }
            Custom(".button-row .feather-button--destructive") {
                Background(.variable(TokenKey.Colors.Destructive.default))
                BorderColor(.variable(TokenKey.Colors.Destructive.default))
                Color(.white)
            }
            Custom(".button-row .feather-button--destructive:hover") {
                Background(.variable(TokenKey.Colors.Destructive.hover))
                BorderColor(.variable(TokenKey.Colors.Destructive.hover))
                Color(.white)
            }
            Custom(".button-row .feather-button--primary-ghost") {
                Background(.variable(TokenKey.Colors.Ghost.Primary.default))
                BorderColor(.variable(TokenKey.Colors.Ghost.Primary.default))
                Color(.white)
            }
            Custom(".button-row .feather-button--primary-ghost:hover") {
                Background(.variable(TokenKey.Colors.Ghost.Primary.hover))
                BorderColor(.variable(TokenKey.Colors.Ghost.Primary.hover))
                Color(.white)
            }
            Custom(".button-row .feather-button--secondary-ghost") {
                Background(.variable(TokenKey.Colors.Ghost.Secondary.default))
                BorderColor(.variable(TokenKey.Colors.Ghost.Secondary.default))
                Color(.white)
            }
            Custom(".button-row .feather-button--secondary-ghost:hover") {
                Background(.variable(TokenKey.Colors.Ghost.Secondary.hover))
                BorderColor(.variable(TokenKey.Colors.Ghost.Secondary.hover))
                Color(.white)
            }
            Custom(".button-row .feather-button--disabled") {
                Background(.variable(TokenKey.Colors.Button.Disabled.background))
                BorderColor(.variable(TokenKey.Colors.Button.Disabled.border))
                Color(.variable(TokenKey.Colors.Button.Disabled.text))
                Cursor(.notAllowed)
            }
            Custom(".button-row .feather-button--disabled:hover") {
                Cursor(.notAllowed)
            }
            Custom(".button-row .feather-button--action") {
                Padding(vertical: 7.px, horizontal: 10.px)
                BorderRadius(6.px)
            }
            Custom(".design-system-type-scale h1, .design-system-type-scale h2, .design-system-type-scale h3, .design-system-type-scale h4, .design-system-type-scale h5, .design-system-type-scale h6") {
                Color(.variable(TokenKey.Colors.Text.secondary))
                Margin(vertical: 18.px, horizontal: 0.px)
                LineHeight(1.2)
                LetterSpacing((-0.02).em)
            }
            Custom(".design-system-type-scale h1") {
                FontSize(2.3.rem)
            }
            Custom(".design-system-type-scale h2") {
                FontSize(1.75.rem)
            }
            Custom(".design-system-type-scale h3") {
                FontSize(1.25.rem)
            }
            Custom(".design-system-type-scale h4") {
                FontSize(1.1.rem)
            }
            Custom(".design-system-type-scale h5") {
                FontSize(0.95.rem)
                TextTransform(.uppercase)
                LetterSpacing(0.04.em)
            }
            Custom(".design-system-type-scale h6") {
                FontSize(0.84.rem)
                TextTransform(.uppercase)
                LetterSpacing(0.06.em)
            }
            Custom(".design-system-text p") {
                LineHeight(1.55)
                Margin(vertical: 8.px, horizontal: 0.px)
            }
            Custom(".design-system-text small") {
                Color(.variable(TokenKey.Colors.Text.muted))
            }
            Custom(".design-system-lists ul, .design-system-lists ol") {
                PaddingLeft(24.px)
                LineHeight(1.55)
            }
            Custom(".design-system-color-grid") {
                Display(.grid)
                GridTemplateColumns(.repeat(4, .fraction(1.fr)))
                Gap(16.px)
            }
            Custom(".design-system-color-tile") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                Gap(8.px)
                TextAlign(.center)
            }
            Custom(".design-system-color-swatch") {
                Width(64.px)
                Height(64.px)
                Border(1.px, .solid, .variable(TokenKey.Colors.Border.secondary))
                BorderRadius(10.px)
                BoxSizing(.borderBox)
            }
            Custom(".design-system-color-tile span") {
                FontSize(0.78.rem)
                Color(.variable(TokenKey.Colors.Text.tertiary))
            }
            Custom(".design-system-color-swatch--background-primary") {
                Background(.variable(TokenKey.Colors.Background.primary))
            }
            Custom(".design-system-color-swatch--background-secondary") {
                Background(.variable(TokenKey.Colors.Background.secondary))
            }
            Custom(".design-system-color-swatch--background-tertiary") {
                Background(.variable(TokenKey.Colors.Background.tertiary))
            }
            Custom(".design-system-color-swatch--background-muted") {
                Background(.variable(TokenKey.Colors.Background.muted))
            }
            Custom(".design-system-color-swatch--selection-primary") {
                Background(.variable(TokenKey.Colors.Selection.primary))
            }
            Custom(".design-system-color-swatch--selection-secondary") {
                Background(.variable(TokenKey.Colors.Selection.secondary))
            }
            Custom(".design-system-color-swatch--selection-tertiary") {
                Background(.variable(TokenKey.Colors.Selection.tertiary))
            }
            Custom(".design-system-color-swatch--selection-muted") {
                Background(.variable(TokenKey.Colors.Selection.muted))
            }
            Custom(".design-system-color-swatch--selection-text") {
                Background(.variable(TokenKey.Colors.Selection.text))
            }
            Custom(".design-system-color-swatch--link-default") {
                Background(.variable(TokenKey.Colors.Link.default))
            }
            Custom(".design-system-color-swatch--link-hover") {
                Background(.variable(TokenKey.Colors.Link.hover))
            }
            Custom(".design-system-color-swatch--link-visited") {
                Background(.variable(TokenKey.Colors.Link.visited))
            }
            Custom(".design-system-color-swatch--link-active") {
                Background(.variable(TokenKey.Colors.Link.active))
            }
            Custom(".design-system-color-swatch--accent-primary") {
                Background(.variable(TokenKey.Colors.Accent.Primary.default))
            }
            Custom(".design-system-color-swatch--accent-primary-hover") {
                Background(.variable(TokenKey.Colors.Accent.Primary.hover))
            }
            Custom(".design-system-color-swatch--accent-secondary") {
                Background(.variable(TokenKey.Colors.Accent.Secondary.default))
            }
            Custom(".design-system-color-swatch--accent-secondary-hover") {
                Background(.variable(TokenKey.Colors.Accent.Secondary.hover))
            }
            Custom(".design-system-table-toolbar") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                FlexWrap(.wrap)
                MarginBottom(16.px)
            }
            Custom(".design-system-table-toolbar input[type='search']") {
                Flex(1, .number(1), .number(280.px))
            }
            Custom(".design-system-table-toolbar select") {
                Flex(0, .number(1), .number(180.px))
            }
            Custom(".design-system-table-shell") {
                Border(1.px, .solid, .variable(TokenKey.Colors.Border.secondary))
                BorderRadius(12.px)
                Overflow(.hidden)
                Background(.variable(TokenKey.Colors.Background.primary))
            }
            Custom(".design-system-table-shell .table-wrap") {
                OverflowX(.auto)
            }
            Custom(".design-system-table-shell .cms-table") {
                MinWidth(860.px)
            }
            Custom(".design-system-table-shell .cms-table th") {
                Background(.variable(TokenKey.Colors.Background.secondary))
                BorderBottom(1.px, .solid, .variable(TokenKey.Colors.Border.secondary))
                Color(.variable(TokenKey.Colors.Text.secondary))
            }
            Custom(".design-system-table-shell .cms-table td") {
                BorderBottom(1.px, .solid, .variable(TokenKey.Colors.Border.secondary))
            }
            Custom(".design-system-table-shell .cms-table tbody tr") {
                Background(.variable(TokenKey.Colors.Background.primary))
            }
            Custom(".design-system-table-shell .cms-table tbody tr:hover") {
                Background(.variable(TokenKey.Colors.Background.secondary))
            }
            Custom(".design-system-table-shell .select-cell") {
                Width(44.px)
                TextAlign(.center)
            }
            Custom(".design-system-table-shell .action-cell") {
                WhiteSpace(.nowrap)
            }
            Custom(".design-system-table-bulk-actions") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                FlexWrap(.wrap)
                Padding(16.px)
                BorderTop(1.px, .solid, .variable(TokenKey.Colors.Border.secondary))
                Background(.variable(TokenKey.Colors.Background.secondary))
            }
            Custom(".design-system-table-bulk-actions p") {
                Flex(1, .number(1), .number(240.px))
                Margin(0)
                Color(.variable(TokenKey.Colors.Text.tertiary))
            }
            Custom(".design-system-table-pagination") {
                MarginTop(12.px)
            }
        }
    }

    func html() -> Section {
        Section {

            H1("Design System")
            P("Design-system component showcase")

            Section {
                H2("Tokens")
                P("Basic color, background, and link tokens.")
                Div {
                    Div { Span("Primary background") }
                        .class("design-system-token design-system-token--primary")
                    Div { Span("Secondary background") }
                        .class("design-system-token design-system-token--secondary")
                    Div { Span("Subtle background") }
                        .class("design-system-token design-system-token--subtle")
                    Div { Span("Destructive background") }
                        .class("design-system-token design-system-token--destructive")
                }
                .class("design-system-token-list")
                P {
                    A("Primary link")
                        .href("#primary-link")
                        .class("design-system-token-link")
                    A("Hover link")
                        .href("#hover-link")
                        .class("design-system-token-link")
                }
            }
            .class("cms-section")

            Section {
                H2("Backgrounds and selections")
                P("Available background and selection colors across the design system.")
                Div {
                    colorTile(name: "Background primary", className: "background-primary")
                    colorTile(name: "Background secondary", className: "background-secondary")
                    colorTile(name: "Background tertiary", className: "background-tertiary")
                    colorTile(name: "Background muted", className: "background-muted")
                    colorTile(name: "Selection primary", className: "selection-primary")
                    colorTile(name: "Selection secondary", className: "selection-secondary")
                    colorTile(name: "Selection tertiary", className: "selection-tertiary")
                    colorTile(name: "Selection muted", className: "selection-muted")
                    colorTile(name: "Selection text", className: "selection-text")
                    colorTile(name: "Link default", className: "link-default")
                    colorTile(name: "Link hover", className: "link-hover")
                    colorTile(name: "Link visited", className: "link-visited")
                    colorTile(name: "Link active", className: "link-active")
                    colorTile(name: "Accent primary", className: "accent-primary")
                    colorTile(name: "Accent primary hover", className: "accent-primary-hover")
                    colorTile(name: "Accent secondary", className: "accent-secondary")
                    colorTile(name: "Accent secondary hover", className: "accent-secondary-hover")
                }
                .class("design-system-color-grid")
            }
            .class("cms-section")

            Section {
                H2("Headings")
                H1("Heading 1")
                H2("Heading 2")
                H3("Heading 3")
                H4("Heading 4")
                H5("Heading 5")
                H6("Heading 6")
            }
            .class("cms-section", "design-system-type-scale")

            Section {
                H2("Text")
                P("Regular paragraph text for general content and descriptions.")
                P {
                    Strong("Strong text")
                    " and emphasized content can be combined in a paragraph."
                }
                P { Small("Muted supporting text for secondary information.") }
            }
            .class("cms-section", "design-system-text")

            Section {
                H2("Lists")
                H3("Unordered list")
                Ul {
                    Li("First list item")
                    Li("Second list item")
                    Li("Third list item")
                }
                H3("Ordered list")
                Ol {
                    Li("First step")
                    Li("Second step")
                    Li("Third step")
                }
            }
            .class("cms-section", "design-system-lists")

            Section {
                H2("Data table")
                P("A members-style list with multi-select, filters, row actions, and pagination.")
                Form {
                    Input()
                        .type(.search)
                        .name("search")
                        .value("")
                        .placeholder("Quick search members")
                    Select {
                        Option("All statuses").value("").selected()
                        Option("Active").value("active")
                        Option("Invited").value("invited")
                        Option("Suspended").value("suspended")
                    }
                    .name("status")
                    Select {
                        Option("All roles").value("").selected()
                        Option("Administrator").value("administrator")
                        Option("Editor").value("editor")
                        Option("Member").value("member")
                    }
                    .name("role")
                    Button("Apply filters")
                        .type(.submit)
                        .class("feather-button", "feather-button--secondary")
                    A("Reset")
                        .href("/admin/design-system")
                        .class("table-search-reset")
                }
                .method(.get)
                .action("/admin/design-system")
                .class("design-system-table-toolbar", "button-row")

                Form {
                    ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    ListTableSelectAllCheckbox().html()
                                    Th("Member")
                                    Th("Email")
                                    Th("Role")
                                    Th("Status")
                                    Th("Last active")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for member in designSystemMembers {
                                    Tr {
                                        ListTableRowSelectCheckbox(
                                            state: .init(id: member.id)
                                        ).html()
                                        Td(member.name).data("label", "Member")
                                        Td(member.email).data("label", "Email")
                                        Td(member.role).data("label", "Role")
                                        Td {
                                            Span(member.status)
                                                .class("status-pill", member.statusClass)
                                        }
                                        .data("label", "Status")
                                        Td(member.lastActive).data("label", "Last active")
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Details",
                                                        href: "#member-details",
                                                        permission: "members:read"
                                                    ),
                                                    .init(
                                                        title: "Edit",
                                                        href: "#member-edit",
                                                        className: "edit",
                                                        permission: "members:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href: "#member-remove",
                                                        className: "delete",
                                                        permission: "members:delete"
                                                    ),
                                                ],
                                                permissions: [
                                                    "members:read",
                                                    "members:update",
                                                    "members:delete",
                                                ]
                                            )
                                        ).html()
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table", "select-table")
                    ).html()
                    Div {
                        P("3 members selected · bulk actions apply to selected rows")
                        SecondaryActionButton("Export selected", href: "#export-members")
                        DestructiveActionButton("Remove selected", href: "#remove-members")
                    }
                    .class("design-system-table-bulk-actions", "button-row")
                }
                .method(.post)
                .action("#members-bulk-actions")
                .id("members-table")

                ListTablePagination(
                    state: .init(
                        path: "/admin/design-system",
                        page: 2,
                        pageSize: 5,
                        total: 18,
                        search: "",
                        queryItems: [("status", "active")]
                    )
                ).html()
            }
            .class("cms-section", "design-system-table-pagination")

            Section {
                H2("Buttons")
                Div {
                    PrimaryButton("Primary", href: "#primary")
                    SecondaryButton("Secondary", href: "#secondary")
                    PrimaryGhostButton("Primary ghost", href: "#ghost-primary")
                    SecondaryGhostButton("Secondary ghost", href: "#ghost-secondary")
                    DestructiveButton("Destructive", href: "#destructive")
                    DisabledButton("Disabled")
                }
                .class("button-row")
            }
            .class("cms-section")

            Section {
                H2("Action buttons")
                Div {
                    PrimaryActionButton("Primary action", href: "#primary-action")
                    SecondaryActionButton("Secondary action", href: "#secondary-action")
                    PrimaryGhostActionButton("Primary ghost action", href: "#ghost-primary-action")
                    SecondaryGhostActionButton("Secondary ghost action", href: "#ghost-secondary-action")
                    DestructiveActionButton(
                        "Destructive action",
                        href: "#destructive-action"
                    )
                    DisabledActionButton("Disabled action")
                }
                .class("button-row")
            }
            .class("cms-section")
        }
        .class("cms-section")
    }

    private var designSystemMembers: [DesignSystemMember] {
        [
            .init(id: "member-001", name: "Ada Lovelace", email: "ada@example.com", role: "Administrator", status: "Active", statusClass: "published", lastActive: "Today, 09:42"),
            .init(id: "member-002", name: "Grace Hopper", email: "grace@example.com", role: "Editor", status: "Active", statusClass: "published", lastActive: "Today, 08:17"),
            .init(id: "member-003", name: "Alan Turing", email: "alan@example.com", role: "Member", status: "Invited", statusClass: "review", lastActive: "Never"),
            .init(id: "member-004", name: "Katherine Johnson", email: "katherine@example.com", role: "Editor", status: "Active", statusClass: "published", lastActive: "Yesterday, 16:03"),
            .init(id: "member-005", name: "Edsger Dijkstra", email: "edsger@example.com", role: "Member", status: "Suspended", statusClass: "draft", lastActive: "Aug 21, 2026"),
        ]
    }

    private func colorTile(name: String, className: String) -> Div {
        Div {
            Div {}
                .class("design-system-color-swatch", "design-system-color-swatch--\(className)")
            Span(name)
        }
        .class("design-system-color-tile")
    }
}

private struct DesignSystemMember: Sendable {
    let id: String
    let name: String
    let email: String
    let role: String
    let status: String
    let statusClass: String
    let lastActive: String
}
