import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuItemTable: Leaf {

    struct State {
        let menuId: String
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let canReorder: Bool
        let items: [Components.Schemas.WebMenuItemListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func selectors() -> [any Selector] {
        Class("web-menu-item-row") {
            UnsafeRawProperty(name: "cursor", value: "grab")
        }
        Class("web-menu-item-row.is-dragging") {
            Opacity(0.55)
        }
        Class("web-menu-item-drag") {
            Color(.variable("cms-light-font"))
            FontSize(18.px)
            Width(18.px)
            TextAlign(.center)
        }
        Class("web-menu-item-reorder-cell") {
            Display(.flex)
            AlignItems(.center)
            Gap(8.px)
        }
        Custom(".web-menu-item-row.is-drop-before") {
            UnsafeRawProperty(
                name: "box-shadow",
                value: "inset 0 3px 0 var(--cms-link-hover)"
            )
        }
        Custom(".web-menu-item-row.is-drop-after") {
            UnsafeRawProperty(
                name: "box-shadow",
                value: "inset 0 -3px 0 var(--cms-link-hover)"
            )
        }
        Class("web-menu-item-actions") {
            Display(.flex)
            Gap(4.px)
            AlignItems(.center)
        }
        Class("web-menu-item-reorder-status") {
            Color(.variable("cms-light-font"))
        }
    }

    func html() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).html()
                H1("Edit menu")
                AdminWebMenuTabs(menuID: state.menuId, active: .items).html()

                if state.isAdded {
                    P("Item added successfully.")
                }
                if state.isEdited {
                    P("Item edited successfully.")
                }
                if state.isRemoved {
                    P("Item removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add item",
                            href: "/admin/web/menus/\(state.menuId)/items/add/"
                        ).html()
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/web/menus/\(state.menuId)/items/",
                        placeholder: "Quick search items",
                        search: state.search
                    )
                ).html()

                if state.items.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1")
                                .href(
                                    "/admin/web/menus/\(state.menuId)/items/?page=1"
                                )
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/web/menus/\(state.menuId)/items/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No items yet."
                                : "No items match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "web:menu-items:delete"
                    )
                    ListTableRemoveForm(
                        state: .init(
                            action:
                                "/admin/web/menus/\(state.menuId)/items/remove/",
                            page: state.page,
                            search: state.search,
                            canRemove: canRemove,
                            buttonTitle: "Remove selected"
                        ),
                        table: ListTableShell(
                            table: Table {
                                Thead {
                                    Tr {
                                        if canRemove {
                                            ListTableSelectAllCheckbox().html()
                                        }
                                        if state.canReorder { Th("Order") }
                                        Th("Label")
                                        Th("URL")
                                        Th("Blank")
                                        Th("Permission")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for item in state.items {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: item.id
                                                    )
                                                ).html()
                                            }
                                            if state.canReorder {
                                                Td {
                                                    Div {
                                                        Span("⠿")
                                                            .class(
                                                                "web-menu-item-drag"
                                                            )
                                                        Div {
                                                            Button("↑")
                                                                .type(.button)
                                                                .class(
                                                                    "row-btn",
                                                                    "edit"
                                                                )
                                                                .data(
                                                                    "web-menu-item-move",
                                                                    "up"
                                                                )
                                                                .ariaLabel(
                                                                    "Move \(item.label) up"
                                                                )
                                                            Button("↓")
                                                                .type(.button)
                                                                .class(
                                                                    "row-btn",
                                                                    "edit"
                                                                )
                                                                .data(
                                                                    "web-menu-item-move",
                                                                    "down"
                                                                )
                                                                .ariaLabel(
                                                                    "Move \(item.label) down"
                                                                )
                                                        }
                                                        .class(
                                                            "web-menu-item-actions"
                                                        )
                                                    }
                                                    .class(
                                                        "web-menu-item-reorder-cell"
                                                    )
                                                }
                                            }
                                            Td(item.label)
                                                .data(
                                                    "label",
                                                    "Label"
                                                )
                                            Td(item.url)
                                                .data(
                                                    "label",
                                                    "URL"
                                                )
                                            Td(item.isBlank ? "Yes" : "No")
                                                .data(
                                                    "label",
                                                    "Blank"
                                                )
                                            Td(item.permission)
                                                .data(
                                                    "label",
                                                    "Permission"
                                                )
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/web/menus/\(state.menuId)/items/\(item.id)/",
                                                            className: nil,
                                                            permission:
                                                                "web:menu-items:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/web/menus/\(state.menuId)/items/\(item.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "web:menu-items:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/web/menus/\(state.menuId)/items/\(item.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "web:menu-items:delete"
                                                        ),
                                                    ],
                                                    permissions: state
                                                        .permissions
                                                )
                                            ).html()
                                        }
                                        .class("web-menu-item-row")
                                        .data("web-menu-item", item.id)
                                        .data(
                                            "web-menu-item-move-url",
                                            "/admin/web/menus/\(state.menuId)/items/\(item.id)/move/"
                                        )
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("select-table") }
                        ).html()
                    ).html()
                    if state.canReorder {
                        Script(reorderScript())
                    }
                    ListTablePagination(
                        state: .init(
                            path: "/admin/web/menus/\(state.menuId)/items/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    ).html()
                }
            }
        }
        .class("cms-section")
    }

    private func reorderScript() -> String {
        #"""
        (function () {
            function bind() {
                var list = document.querySelector('tbody');
                var status = document.getElementById('web-menu-item-reorder-status');
                if (!list) { return; }
                var dragged = null;
                var saving = false;

                function rows() {
                    return Array.from(list.querySelectorAll('[data-web-menu-item]'));
                }

                function clearIndicators() {
                    rows().forEach(function (row) {
                        row.classList.remove('is-drop-before', 'is-drop-after');
                    });
                }

                function setStatus(message, isError) {
                    if (!status) { return; }
                    status.textContent = message;
                    status.classList.toggle('error', Boolean(isError));
                }

                function setControlsDisabled(disabled) {
                    document.querySelectorAll('[data-web-menu-item-move]').forEach(function (button) {
                        button.disabled = disabled;
                    });
                }

                function restore(order) {
                    order.forEach(function (row) { list.appendChild(row); });
                }

                async function persistMove(row, beforeRow, previousOrder) {
                    var beforeItemId = beforeRow
                        ? beforeRow.getAttribute('data-web-menu-item')
                        : '';
                    var url = row.getAttribute('data-web-menu-item-move-url');
                    saving = true;
                    setControlsDisabled(true);
                    setStatus('Saving…', false);
                    try {
                        var response = await fetch(url, {
                            method: 'POST',
                            credentials: 'same-origin',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: new URLSearchParams({
                                beforeItemId: beforeItemId
                            })
                        });
                        if (!response.ok) { throw new Error('Move request failed'); }
                        setStatus('Saved', false);
                    } catch (error) {
                        restore(previousOrder);
                        setStatus('Unable to save item order.', true);
                    } finally {
                        saving = false;
                        setControlsDisabled(false);
                    }
                }

                function moveRow(row, beforeRow) {
                    if (saving) { return; }
                    var previousOrder = rows();
                    if (beforeRow === row || beforeRow === row.nextElementSibling) {
                        return;
                    }
                    list.removeChild(row);
                    if (beforeRow) {
                        list.insertBefore(row, beforeRow);
                    } else {
                        list.appendChild(row);
                    }
                    var finalBeforeRow = row.nextElementSibling;
                    persistMove(row, finalBeforeRow, previousOrder);
                }

                rows().forEach(function (row) { row.setAttribute('draggable', 'true'); });

                list.addEventListener('dragstart', function (event) {
                    if (saving) { return; }
                    dragged = event.target.closest('[data-web-menu-item]');
                    if (!dragged) { return; }
                    dragged.classList.add('is-dragging');
                    if (event.dataTransfer) { event.dataTransfer.effectAllowed = 'move'; }
                });

                list.addEventListener('dragend', function () {
                    if (dragged) { dragged.classList.remove('is-dragging'); }
                    clearIndicators();
                    dragged = null;
                });

                list.addEventListener('dragover', function (event) {
                    if (!dragged || saving) { return; }
                    event.preventDefault();
                    clearIndicators();
                    var target = event.target.closest('[data-web-menu-item]');
                    if (target && target !== dragged) {
                        var bounds = target.getBoundingClientRect();
                        target.classList.add(event.clientY < bounds.top + bounds.height / 2 ? 'is-drop-before' : 'is-drop-after');
                    }
                    if (event.dataTransfer) { event.dataTransfer.dropEffect = 'move'; }
                });

                list.addEventListener('drop', function (event) {
                    event.preventDefault();
                    if (!dragged || saving) { return; }
                    var target = event.target.closest('[data-web-menu-item]');
                    if (!target || target === dragged) { return; }
                    var dropBefore = event.clientY < target.getBoundingClientRect().top + target.getBoundingClientRect().height / 2;
                    var beforeRow = dropBefore ? target : target.nextElementSibling;
                    moveRow(dragged, beforeRow);
                    clearIndicators();
                });

                document.querySelectorAll('[data-web-menu-item-move]').forEach(function (button) {
                    button.addEventListener('click', function () {
                        if (saving) { return; }
                        var row = button.closest('[data-web-menu-item]');
                        if (!row) { return; }
                        var direction = button.getAttribute('data-web-menu-item-move');
                        if (direction === 'up') {
                            var previousRow = row.previousElementSibling;
                            if (previousRow) { moveRow(row, previousRow); }
                            return;
                        }
                        var nextRow = row.nextElementSibling;
                        if (nextRow) {
                            moveRow(row, nextRow.nextElementSibling);
                        }
                    });
                });
            }
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', bind, { once: true });
            } else {
                bind();
            }
        })();
        """#
    }
}
