public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminDialogHost: Component {
    public init() {}

    public func html(context _: inout BuilderContext) -> Div {
        Div {}.id("admin-dialog-host")
    }

    public func scripts() -> [String] {
        [
            #"""
            (function () {
                if (window.__adminDialogController) { return; }
                window.__adminDialogController = true;

                function host() {
                    return document.getElementById("admin-dialog-host");
                }

                function focusControl(dialog) {
                    var control = dialog.querySelector(
                        "input:not([type='hidden']):not([disabled]), select:not([disabled]), textarea:not([disabled])"
                    );
                    if (control) { control.focus(); }
                }

                function adoptStyles(source) {
                    source.querySelectorAll("style").forEach(function (style) {
                        var css = style.textContent || "";
                        var exists = Array.prototype.some.call(
                            document.querySelectorAll("style[data-admin-dialog-style]"),
                            function (existing) {
                                return existing.textContent === css;
                            }
                        );
                        if (exists) { return; }
                        var copy = document.createElement("style");
                        copy.setAttribute("data-admin-dialog-style", "");
                        copy.textContent = css;
                        document.head.appendChild(copy);
                    });
                }

                function adoptScripts(dialog) {
                    dialog.querySelectorAll("script:not([src])").forEach(function (script) {
                        var code = script.textContent || "";
                        if (!code) { return; }
                        window.setTimeout(function () {
                            var copy = document.createElement("script");
                            copy.textContent = code;
                            try {
                                document.body.appendChild(copy);
                            } catch (_) {
                                // Keep the dialog usable if one component script fails.
                            }
                        }, 0);
                    });
                }

                function parseDialog(html) {
                    var source = new DOMParser().parseFromString(html, "text/html");
                    var dialog = source.querySelector("dialog[data-admin-dialog]");
                    if (!dialog) { throw new Error("Dialog content was not found"); }
                    adoptStyles(source);
                    return { dialog: dialog, source: source };
                }

                function mount(parsed) {
                    var dialog = parsed.dialog;
                    adoptScripts(dialog);
                    var root = host();
                    if (!root) { return; }
                    root.replaceChildren(dialog);
                    document.documentElement.classList.add("admin-dialog-open");
                    dialog.addEventListener("close", function () {
                        dialog.remove();
                        document.documentElement.classList.remove("admin-dialog-open");
                    }, { once: true });
                    if (dialog.showModal) {
                        dialog.showModal();
                    } else {
                        dialog.setAttribute("open", "");
                    }
                    focusControl(dialog);
                }

                function close(dialog) {
                    if (!dialog) { return; }
                    if (dialog.open && dialog.close) {
                        dialog.close();
                    } else {
                        dialog.remove();
                    }
                }

                function rowLabel(row, fallback) {
                    if (!row) { return fallback; }
                    var marked = row.querySelector("[data-remove-label]");
                    if (marked) {
                        var markedValue = marked.getAttribute("data-remove-label");
                        var markedLabel = markedValue && markedValue !== "true"
                            ? markedValue
                            : (marked.innerText || marked.textContent || "");
                        markedLabel = markedLabel.trim().replace(/\s+/g, " ");
                        if (markedLabel) { return markedLabel; }
                    }
                    var cells = row.querySelectorAll("td");
                    for (var index = 0; index < cells.length; index += 1) {
                        var cell = cells[index];
                        if (cell.classList.contains("select-cell") ||
                            cell.classList.contains("action-cell")) {
                            continue;
                        }
                        var label = (cell.innerText || cell.textContent || "")
                            .trim().replace(/\s+/g, " ");
                        if (label) { return label; }
                    }
                    return fallback;
                }

                function formContextLabel(trigger) {
                    var form = trigger.closest("form");
                    if (!form) { return null; }
                    var preferred = [
                        "name", "title", "email", "subject", "label",
                        "username", "slug", "key", "url", "source",
                        "destination", "filename", "file name", "path"
                    ];
                    var ignored = [
                        "id", "status", "created", "created at", "updated at",
                        "expires at", "roles", "permissions"
                    ];
                    var candidates = [];
                    form.querySelectorAll(".admin-form-field").forEach(
                        function (field) {
                            var control = field.querySelector(
                                "input:not([type='hidden']), select, textarea"
                            );
                            var label = field.querySelector(
                                ".admin-form-field-label"
                            );
                            if (!control || !label) { return; }
                            var labelText = (label.innerText || label.textContent || "")
                                .trim()
                                .replace(/\s+/g, " ")
                                .replace(/\s*\(optional\)$/, "");
                            var value = control.value || "";
                            if (
                                control.tagName === "SELECT" &&
                                control.selectedOptions.length
                            ) {
                                value = control.selectedOptions[0].textContent || value;
                            }
                            value = value.trim().replace(/\s+/g, " ");
                            var normalizedLabel = labelText.toLowerCase();
                            if (
                                !labelText || !value || value === "—" ||
                                ignored.indexOf(normalizedLabel) >= 0
                            ) {
                                return;
                            }
                            candidates.push({
                                label: labelText,
                                value: value
                            });
                        }
                    );
                    var candidate = null;
                    for (var index = 0; index < preferred.length; index += 1) {
                        candidate = candidates.find(function (item) {
                            return item.label.toLowerCase() === preferred[index];
                        });
                        if (candidate) { break; }
                    }
                    candidate = candidate || candidates[0];
                    return candidate ? candidate.value : null;
                }

                function makeButton(label, classes, action) {
                    var button = document.createElement("button");
                    button.type = "button";
                    button.className = "button " + classes;
                    button.textContent = label;
                    button.addEventListener("click", action);
                    return button;
                }

                function showRemoveConfirmation(items, onConfirm, message) {
                    var dialog = document.createElement("dialog");
                    dialog.className = "admin-dialog";
                    dialog.setAttribute("data-admin-dialog", "");
                    dialog.setAttribute("aria-label", "Are you sure?");

                    var panel = document.createElement("div");
                    panel.className = "admin-dialog__panel";
                    var header = document.createElement("div");
                    header.className = "admin-dialog__header";
                    var title = document.createElement("h2");
                    title.textContent = "Are you sure?";
                    var closeButton = makeButton(
                        "Close",
                        "secondary-ghost admin-dialog__close",
                        function () { close(dialog); }
                    );
                    header.append(title, closeButton);
                    panel.appendChild(header);

                    var description = document.createElement("p");
                    description.textContent = message ||
                        "This action cannot be undone. Do you want to remove " +
                        (items.length === 1 ? "this item" : "these items") + "?";
                    panel.appendChild(description);

                    if (items.length > 0) {
                        var itemBox = document.createElement("div");
                        itemBox.className = "admin-confirmation-items";
                        var list = document.createElement("ul");
                        items.slice(0, 20).forEach(function (item) {
                            var entry = document.createElement("li");
                            entry.textContent = item;
                            list.appendChild(entry);
                        });
                        if (items.length > 20) {
                            var more = document.createElement("li");
                            more.textContent = "And " + (items.length - 20) + " more.";
                            list.appendChild(more);
                        }
                        itemBox.appendChild(list);
                        panel.appendChild(itemBox);
                    }

                    var buttons = document.createElement("div");
                    buttons.className = "button-row";
                    if (typeof onConfirm === "function") {
                        buttons.appendChild(makeButton(
                            "Remove",
                            "destructive",
                            function () {
                                close(dialog);
                                onConfirm();
                            }
                        ));
                    }
                    buttons.appendChild(makeButton(
                        "Cancel",
                        "primary-ghost",
                        function () { close(dialog); }
                    ));
                    panel.appendChild(buttons);
                    dialog.appendChild(panel);
                    mount({ dialog: dialog });
                }

                function dialogURL(url) {
                    var resolved = new URL(url, window.location.href);
                    if (resolved.origin === window.location.origin) {
                        resolved.searchParams.set("presentation", "dialog");
                    }
                    return resolved.href;
                }

                function open(url, fallback) {
                    var requestURL = dialogURL(url);
                    fetch(requestURL, {
                        credentials: "same-origin",
                        headers: { "Accept": "text/html; type=admin-dialog" }
                    })
                    .then(function (response) {
                        if (!response.ok) { throw new Error("Unable to load dialog"); }
                        return response.text();
                    })
                    .then(function (html) { mount(parseDialog(html)); })
                    .catch(function () { window.location.href = fallback || url; });
                }

                function mountHTML(html) {
                    try {
                        mount(parseDialog(html));
                        return true;
                    } catch (_) {
                        return false;
                    }
                }

                var submitHandlers = new WeakMap();

                function registerFormSubmitHandler(form, handler) {
                    if (!form || typeof handler !== "function") { return; }
                    submitHandlers.set(form, handler);
                }

                function replaceFromResponse(dialog, response) {
                    if (response.redirected) {
                        window.location.assign(response.url);
                        return;
                    }
                    if (response.status === 204) {
                        close(dialog);
                        window.location.reload();
                        return;
                    }
                    if (!response.ok) { throw new Error("Unable to submit dialog"); }
                    return response.text().then(function (html) {
                        mount(parseDialog(html));
                    });
                }

                window.__adminDialog = {
                    mountHTML: mountHTML,
                    openURL: function (url, fallback) {
                        open(url, fallback);
                    },
                    registerFormSubmitHandler: registerFormSubmitHandler,
                    replaceResponse: function (response) {
                        var dialog = document.querySelector(
                            "dialog[data-admin-dialog][open]"
                        );
                        return replaceFromResponse(dialog, response);
                    }
                };

                document.addEventListener("click", function (event) {
                    var target = event.target;
                    if (!target || !target.closest) { return; }

                    var removeTrigger = target.closest(
                        "[data-admin-remove-confirm='true']"
                    );
                    if (removeTrigger) {
                        event.preventDefault();
                        var nonceMeta = document.querySelector(
                            "meta[name='admin-remove-nonce']"
                        );
                        var nonce = nonceMeta && nonceMeta.content;
                        if (!nonce) {
                            showRemoveConfirmation(
                                [],
                                null,
                                "Unable to remove this item. Please reload the page."
                            );
                            return;
                        }
                        var removeURL = removeTrigger.getAttribute(
                            "data-admin-dialog-url"
                        );
                        var removeRow = removeTrigger.closest("tr");
                        var removeLabel = removeTrigger.getAttribute(
                            "data-remove-label"
                        );
                        if (!removeLabel || removeLabel === "true") {
                            removeLabel = rowLabel(removeRow, "Selected item");
                        }
                        if (removeLabel === "Selected item") {
                            removeLabel = formContextLabel(removeTrigger) || removeLabel;
                        }
                        showRemoveConfirmation([removeLabel], function () {
                            var form = document.createElement("form");
                            form.method = "POST";
                            var removeTarget = new URL(
                                removeURL,
                                window.location.href
                            );
                            form.action = removeTarget.pathname;
                            removeTarget.searchParams.forEach(
                                function (value, name) {
                                    var input = document.createElement("input");
                                    input.type = "hidden";
                                    input.name = name;
                                    input.value = value;
                                    form.appendChild(input);
                                }
                            );
                            var nonceInput = document.createElement("input");
                            nonceInput.type = "hidden";
                            nonceInput.name = "_nonce";
                            nonceInput.value = nonce;
                            form.appendChild(nonceInput);
                            document.body.appendChild(form);
                            HTMLFormElement.prototype.submit.call(form);
                        });
                        return;
                    }

                    var trigger = target.closest("[data-admin-dialog-url]");
                    if (trigger) {
                        event.preventDefault();
                        open(
                            trigger.getAttribute("data-admin-dialog-url"),
                            trigger.getAttribute("href")
                        );
                        return;
                    }

                    var dialogLink = target.closest(
                        "dialog[data-admin-dialog] a[href]"
                    );
                    if (
                        dialogLink &&
                        dialogLink.getAttribute("target") !== "_blank"
                    ) {
                        var href = dialogLink.getAttribute("href") || "";
                        if (
                            href &&
                            !href.startsWith("#") &&
                            !href.startsWith("mailto:") &&
                            !href.startsWith("javascript:")
                        ) {
                            var resolved = new URL(href, window.location.href);
                            if (resolved.origin === window.location.origin) {
                                event.preventDefault();
                                open(resolved.href, href);
                                return;
                            }
                        }
                    }

                    var closeButton = target.closest("[data-admin-dialog-close]");
                    if (closeButton) {
                        close(closeButton.closest("dialog[data-admin-dialog]"));
                        return;
                    }
                });

                document.addEventListener("keydown", function (event) {
                    if (event.key !== "Escape") { return; }
                    var dialog = document.querySelector(
                        "dialog[data-admin-dialog][open]"
                    );
                    if (!dialog) { return; }
                    event.preventDefault();
                    close(dialog);
                });

                document.addEventListener("submit", function (event) {
                    var selectionForm = event.target;
                    if (
                        selectionForm &&
                        selectionForm.matches &&
                        selectionForm.matches("form.table-remove-form")
                    ) {
                        event.preventDefault();
                        var selected = Array.prototype.slice.call(
                            selectionForm.querySelectorAll("input.select-row:checked")
                        );
                        if (selected.length === 0) { return; }
                        var labels = selected.map(function (input) {
                            return rowLabel(input.closest("tr"), input.value);
                        });
                        var nonceMeta = document.querySelector(
                            "meta[name='admin-remove-nonce']"
                        );
                        var nonce = nonceMeta && nonceMeta.content;
                        if (!nonce) {
                            showRemoveConfirmation(
                                labels,
                                null,
                                "Unable to remove the selected items. Please reload the page."
                            );
                            return;
                        }
                        showRemoveConfirmation(labels, function () {
                            var nonceInput = selectionForm.querySelector(
                                "input[name='_nonce']"
                            );
                            if (!nonceInput) {
                                nonceInput = document.createElement("input");
                                nonceInput.type = "hidden";
                                nonceInput.name = "_nonce";
                                selectionForm.appendChild(nonceInput);
                            }
                            nonceInput.value = nonce;
                            HTMLFormElement.prototype.submit.call(selectionForm);
                        });
                        return;
                    }
                    if (event.defaultPrevented) { return; }
                    var form = event.target;
                    if (!form || !form.closest) { return; }
                    var dialog = form.closest("dialog[data-admin-dialog]");
                    if (!dialog && form.matches("form[data-admin-dialog-form]")) {
                        event.preventDefault();
                        event.stopImmediatePropagation();
                        var url = new URL(form.action, window.location.href);
                        new FormData(form).forEach(function (value, key) {
                            url.searchParams.append(
                                key,
                                typeof value === "string" ? value : ""
                            );
                        });
                        open(url.href, form.action);
                        return;
                    }
                    if (!dialog) { return; }

                    var handler = submitHandlers.get(form);
                    if (handler) {
                        event.preventDefault();
                        event.stopPropagation();
                        try {
                            var result = handler(event, form, dialog, {
                                close: function () { close(dialog); },
                                replaceResponse: function (response) {
                                    return replaceFromResponse(dialog, response);
                                }
                            });
                            if (result && typeof result.catch === "function") {
                                result.catch(function () {
                                    window.alert("Unable to submit dialog.");
                                });
                            }
                        } catch (_) {
                            window.alert("Unable to submit dialog.");
                        }
                        return;
                    }

                    event.preventDefault();
                    var body = new URLSearchParams();
                    new FormData(form).forEach(function (value, key) {
                        body.append(key, typeof value === "string" ? value : "");
                    });
                    fetch(dialogURL(form.action), {
                        method: (form.method || "POST").toUpperCase(),
                        credentials: "same-origin",
                        headers: {
                            "Accept": "text/html; type=admin-dialog",
                            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                        },
                        body: body.toString()
                    })
                    .then(function (response) {
                        return replaceFromResponse(dialog, response);
                    })
                    .catch(function () {
                        window.alert("Unable to submit dialog.");
                    });
                });
            }());
            """#
        ]
    }
}
