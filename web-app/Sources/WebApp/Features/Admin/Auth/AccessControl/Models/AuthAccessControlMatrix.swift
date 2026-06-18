import AdminOpenAPI
import Foundation
import HTML
import SGML
import WebStandards

struct AuthAccessControlMatrix: Component {

    struct State {
        let isEdited: Bool
        let error: String?
        let canEdit: Bool
        let roles: [Components.Schemas.UserRoleListItemSchema]
        let permissions: [Components.Schemas.SystemPermissionListItemSchema]
        let selectedPairs: Set<String>
        let search: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        let visiblePermissions = state.permissions.filter {
            state.search.isEmpty
                || $0.name.localizedCaseInsensitiveContains(state.search)
        }
        let groupedPermissions = groupPermissions(visiblePermissions)
        let table = matrixTable(groups: groupedPermissions)

        return Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Access Control")
            P("Rows are permissions, columns are roles.")

            if state.isEdited {
                P("Access Control edited successfully.")
            }
            if let error = state.error {
                P(error).class("error-text")
            }

            Div {
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/access-control/",
                        placeholder: "Quick search access control",
                        search: state.search
                    )
                )
            }
            .setAttribute(
                name: "style",
                value: "margin: 1.5rem 0 0.75rem;"
            )

            if state.roles.isEmpty || state.permissions.isEmpty {
                P("Please create at least one role and one permission first.")
            }
            else if groupedPermissions.isEmpty {
                P("No permissions match your search.")
            }
            else if state.canEdit {
                Form {
                    ListTableShell(table: table)

                    Div {
                        Button("Save access control")
                            .type(.submit)
                    }
                    .class("button-row", "auth-access-control-actions")

                    if !state.search.isEmpty {
                        Input()
                            .type(.hidden)
                            .name("search")
                            .value(state.search)
                    }
                }
                .method(.post)
                .action("/admin/auth/access-control/")
            }
            else {
                P(
                    "You can view the access control matrix, but you need update permission to save changes."
                )
                ListTableShell(table: table)
            }
        }
        .class("cms-section")
    }
}

private struct PermissionGroup: Sendable {
    let key: String
    let title: String
    let permissions: [Components.Schemas.SystemPermissionListItemSchema]
}

extension AuthAccessControlMatrix {
    fileprivate func matrixTable(
        groups: [PermissionGroup]
    ) -> Table {
        Table {
            Thead {
                Tr {
                    Th("Permission")
                        .class("role-permission-matrix-permission")
                    for role in state.roles {
                        Th(role.name)
                            .class("role-permission-matrix-checkbox")
                    }
                }
            }
            Tbody {
                for group in groups {
                    let groupToken = cssToken(group.key)

                    Tr {
                        Th(group.title)
                            .class(
                                "role-permission-matrix-permission",
                                "role-permission-matrix-group-title"
                            )
                        for role in state.roles {
                            let roleToken = cssToken(role.id)
                            let rowClass =
                                "acl-select-row-\(groupToken)-\(roleToken)"
                            let allSelected = group.permissions.allSatisfy {
                                state.selectedPairs.contains(
                                    "\(role.id)|\($0.id)"
                                )
                            }

                            Th {
                                Input()
                                    .type(.checkbox)
                                    .ariaLabel(
                                        "Select all \(group.title) permissions for \(role.name)"
                                    )
                                    .class(
                                        "role-permission-matrix-group-toggle",
                                        "acl-select-all",
                                        "acl-select-all-\(groupToken)-\(roleToken)"
                                    )
                                    .if(allSelected) { $0.checked() }
                                    .if(state.canEdit == false) {
                                        $0.setAttribute(
                                            name: "disabled",
                                            value: ""
                                        )
                                    }
                                    .setAttribute(
                                        name: "onchange",
                                        value:
                                            "this.closest('form').querySelectorAll('input.\(rowClass)').forEach(function(input) { input.checked = this.checked; }, this)"
                                    )
                            }
                            .class(
                                "role-permission-matrix-checkbox",
                                "role-permission-matrix-group-toggle-cell"
                            )
                        }
                    }
                    .class("role-permission-matrix-section")

                    for permission in group.permissions {
                        Tr {
                            Td(permissionRowTitle(permission.name))
                                .class("role-permission-matrix-permission")
                            for role in state.roles {
                                let pair = "\(role.id)|\(permission.id)"
                                let roleToken = cssToken(role.id)
                                let rowClass =
                                    "acl-select-row-\(groupToken)-\(roleToken)"

                                Td {
                                    Input()
                                        .type(.checkbox)
                                        .name("pairs")
                                        .value(pair)
                                        .class(
                                            "acl-select-row",
                                            rowClass
                                        )
                                        .if(
                                            state.selectedPairs.contains(pair)
                                        ) { $0.checked() }
                                        .if(state.canEdit == false) {
                                            $0.setAttribute(
                                                name: "disabled",
                                                value: ""
                                            )
                                        }
                                }
                                .class("role-permission-matrix-checkbox")
                            }
                        }
                    }
                }
            }
        }
        .class("cms-table", "role-permission-matrix")
    }

    fileprivate func groupPermissions(
        _ permissions: [Components.Schemas.SystemPermissionListItemSchema]
    ) -> [PermissionGroup] {
        Dictionary(grouping: permissions, by: permissionGroupKey(for:))
            .map { key, groupedPermissions in
                PermissionGroup(
                    key: key,
                    title: permissionGroupTitle(from: key),
                    permissions: groupedPermissions.sorted {
                        $0.name.localizedCaseInsensitiveCompare($1.name)
                            == .orderedAscending
                    }
                )
            }
            .sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title)
                    == .orderedAscending
            }
    }

    fileprivate func permissionGroupKey(
        for permission: Components.Schemas.SystemPermissionListItemSchema
    ) -> String {
        let parts = permission.name.split(
            separator: ":",
            omittingEmptySubsequences: true
        )
        guard parts.count >= 2 else {
            return permission.name
        }
        return "\(parts[0]):\(parts[1])"
    }

    fileprivate func permissionGroupTitle(
        from key: String
    ) -> String {
        let parts = key.split(
            separator: ":",
            omittingEmptySubsequences: true
        )
        guard parts.count >= 2 else {
            return titleCased(String(key))
        }
        return
            "\(titleCased(String(parts[0]))) / \(titleCased(String(parts[1])))"
    }

    fileprivate func titleCased(
        _ value: String
    ) -> String {
        value
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .split(separator: " ")
            .map { word in
                guard let first = word.first else { return "" }
                return String(first).uppercased()
                    + word.dropFirst().lowercased()
            }
            .joined(separator: " ")
    }

    fileprivate func permissionRowTitle(
        _ value: String
    ) -> String {
        let parts = value.split(separator: ":", omittingEmptySubsequences: true)
        guard let last = parts.last else {
            return titleCased(value)
        }
        return titleCased(String(last))
    }

    fileprivate func cssToken(
        _ value: String
    ) -> String {
        value
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
    }
}
