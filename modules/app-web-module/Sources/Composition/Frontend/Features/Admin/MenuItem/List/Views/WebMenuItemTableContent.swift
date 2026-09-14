import CSS
import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

struct WebMenuItemTableContent: Component {
    struct State {
        let menuId: String
        let permissions: NewAdminListActions
        let items: [Components.Schemas.WebMenuItemListItemSchema]
        let pageState: NewAdminListPageState
        let search: String?
    }

    let state: State

    private var returnTo: String {
        NewAdminLocation.url(
            path: WebMenuItemRoutes.list(RouterPath(state.menuId)).description,
            page: state.pageState.page,
            search: state.search
        )
    }

    func selectors() -> [any CSS.Selector] {
        [
            Class("web-menu-item-row") {
                UnsafeRawProperty(name: "cursor", value: "grab")
            },
            Class("web-menu-item-row.is-dragging") {
                Opacity(0.55)
            },
            Class("web-menu-item-drag") {
                FontSize(18.px)
                Width(18.px)
                TextAlign(.center)
            },
            Class("web-menu-item-reorder-cell") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            },
            Custom(".web-menu-item-row.is-drop-before") {
                UnsafeRawProperty(
                    name: "box-shadow",
                    value: "inset 0 3px 0 var(--cms-link-hover)"
                )
            },
            Custom(".web-menu-item-row.is-drop-after") {
                UnsafeRawProperty(
                    name: "box-shadow",
                    value: "inset 0 -3px 0 var(--cms-link-hover)"
                )
            },
            Class("web-menu-item-actions") {
                Display(.flex)
                Gap(4.px)
                AlignItems(.center)
            },
        ]
    }

    func html(context: inout RenderContext) -> Div {
        let canDelete = state.permissions.allows(
            WebPermissions.MenuItems.delete
        )
        let canReorder = state.permissions.allows(
            WebPermissions.MenuItems.update
        )
        let searchValue = state.search ?? ""
        let hasActiveQuery = !(state.search?.isEmpty ?? true)

        return Div {
            context.render(
                NewAdminList(
                    table: {
                        if state.pageState.isPageOutOfRange {
                            context.render(
                                NewAdminListInvalidPageState(
                                    pageState: state.pageState,
                                    path:
                                        WebMenuItemRoutes.list(
                                            RouterPath(state.menuId)
                                        )
                                        .description
                                )
                            )
                        }
                        else if state.items.isEmpty {
                            if hasActiveQuery {
                                context.render(
                                    NewAdminListNoResultsState(
                                        message: "No items match your search.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            context.render(
                                                NewAdminButton(
                                                    "Reset search",
                                                    href:
                                                        WebMenuItemRoutes.list(
                                                            RouterPath(
                                                                state.menuId
                                                            )
                                                        )
                                                        .description,
                                                    style: .secondary
                                                )
                                            )
                                        }
                                    )
                                )
                            }
                            else {
                                context.render(
                                    NewAdminListEmptyState(
                                        message: "No items yet.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            if state.permissions.allows(
                                                WebPermissions.MenuItems.create
                                            ) {
                                                context.render(
                                                    NewAdminButton(
                                                        "Add new",
                                                        href:
                                                            WebMenuItemRoutes
                                                            .add(
                                                                RouterPath(
                                                                    state.menuId
                                                                )
                                                            )
                                                            .description
                                                    )
                                                )
                                            }
                                        }
                                    )
                                )
                            }
                        }
                        else {
                            context.render(
                                NewAdminListSelectionForm(
                                    state: .init(
                                        action:
                                            WebMenuItemRoutes.remove(
                                                RouterPath(state.menuId)
                                            )
                                            .description,
                                        pageState: state.pageState,
                                        search: searchValue,
                                        button: .init(
                                            "Remove selected",
                                            style: .destructive
                                        ),
                                        isEnabled: canDelete
                                    ),
                                    table: context.render(
                                        NewAdminListShell(
                                            layout: .init(
                                                name: "web-menu-items",
                                                columns: canReorder
                                                    ? [
                                                        .fixed(100),
                                                        .fraction(2),
                                                        .fraction(2),
                                                        .fixed(100),
                                                        .fraction(2),
                                                        .fixed(250),
                                                    ]
                                                    : [
                                                        .fraction(2),
                                                        .fraction(2),
                                                        .fixed(100),
                                                        .fraction(2),
                                                        .fixed(250),
                                                    ]
                                            ),
                                            hasSelection: canDelete,
                                            table: Table {
                                                Thead {
                                                    Tr {
                                                        if canDelete {
                                                            context.render(
                                                                NewAdminListSelectAllCheckbox()
                                                            )
                                                        }
                                                        if canReorder {
                                                            Th("Order")
                                                        }
                                                        Th("Label")
                                                        Th("URL")
                                                        Th("Blank")
                                                        Th("Permission")
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for item in state.items {
                                                        context.render(
                                                            WebMenuItemRow(
                                                                menuId: state
                                                                    .menuId,
                                                                item: item,
                                                                permissions:
                                                                    state
                                                                    .permissions,
                                                                canReorder:
                                                                    canReorder,
                                                                returnTo:
                                                                    returnTo
                                                            )
                                                        )
                                                    }
                                                }
                                            }
                                            .class("cms-table", "action-table")
                                            .if(canDelete) {
                                                $0.class("select-table")
                                            }
                                        )
                                    )
                                )
                            )
                        }
                    },
                    search: {
                        context.render(
                            NewAdminListSearch(
                                state: .init(
                                    action:
                                        WebMenuItemRoutes.list(
                                            RouterPath(state.menuId)
                                        )
                                        .description,
                                    placeholder: "Quick search items",
                                    search: searchValue
                                )
                            )
                        )
                    },
                    toolbar: {
                        if state.permissions.allows(
                            WebPermissions.MenuItems.create
                        ) {
                            context.render(
                                NewAdminListToolbar {
                                    context.render(
                                        NewAdminButton(
                                            "Add new",
                                            href:
                                                WebMenuItemRoutes.add(
                                                    RouterPath(state.menuId)
                                                )
                                                .description
                                        )
                                    )
                                }
                            )
                        }
                    },
                    pagination: {
                        context.render(
                            NewAdminListPagination(
                                state: .init(
                                    path:
                                        WebMenuItemRoutes.list(
                                            RouterPath(state.menuId)
                                        )
                                        .description,
                                    pageState: state.pageState,
                                    search: searchValue
                                )
                            )
                        )
                    }
                )
            )
            if canReorder { Script(reorderScript()) }
        }
    }

    private func reorderScript() -> String {
        #"""
        (function () {
            function bind() {
                var list = document.querySelector('tbody');
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
                    try {
                        var response = await fetch(url, {
                            method: 'POST',
                            credentials: 'same-origin',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: new URLSearchParams({ beforeItemId: beforeItemId })
                        });
                        if (!response.ok) { throw new Error('Move request failed'); }
                    } catch (error) {
                        restore(previousOrder);
                    } finally {
                        saving = false;
                        setControlsDisabled(false);
                    }
                }

                function moveRow(row, beforeRow) {
                    if (saving) { return; }
                    var previousOrder = rows();
                    if (beforeRow === row || beforeRow === row.nextElementSibling) { return; }
                    list.removeChild(row);
                    if (beforeRow) { list.insertBefore(row, beforeRow); }
                    else { list.appendChild(row); }
                    persistMove(row, row.nextElementSibling, previousOrder);
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
                    var beforeRow = event.clientY < target.getBoundingClientRect().top + target.getBoundingClientRect().height / 2
                        ? target : target.nextElementSibling;
                    moveRow(dragged, beforeRow);
                    clearIndicators();
                });
                document.querySelectorAll('[data-web-menu-item-move]').forEach(function (button) {
                    button.addEventListener('click', function () {
                        if (saving) { return; }
                        var row = button.closest('[data-web-menu-item]');
                        if (!row) { return; }
                        if (button.getAttribute('data-web-menu-item-move') === 'up') {
                            var previousRow = row.previousElementSibling;
                            if (previousRow) { moveRow(row, previousRow); }
                            return;
                        }
                        var nextRow = row.nextElementSibling;
                        if (nextRow) { moveRow(row, nextRow.nextElementSibling); }
                    });
                });
            }
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', bind, { once: true });
            } else { bind(); }
        })();
        """#
    }
}
