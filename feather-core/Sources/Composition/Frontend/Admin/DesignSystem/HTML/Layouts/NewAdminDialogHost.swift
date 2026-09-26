public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminDialogHost: Component {
    public init() {}

    public func html(context _: inout BuilderContext) -> Div {
        Div {}.id("new-admin-dialog-host")
    }

    public func scripts() -> [String] {
        [
            #"""
            (function () {
                if (window.__newAdminDialogController) { return; }
                window.__newAdminDialogController = true;

                function host() {
                    return document.getElementById("new-admin-dialog-host");
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

                function adoptScripts(source) {
                    source.querySelectorAll("script:not([src])").forEach(function (script) {
                        var code = script.textContent || "";
                        if (!code) { return; }
                        var copy = document.createElement("script");
                        copy.textContent = code;
                        document.body.appendChild(copy);
                    });
                }

                function parseDialog(html) {
                    var source = new DOMParser().parseFromString(html, "text/html");
                    var dialog = source.querySelector("dialog[data-admin-dialog]");
                    if (!dialog) { throw new Error("Dialog content was not found"); }
                    adoptStyles(source);
                    adoptScripts(source);
                    return dialog;
                }

                function mount(dialog) {
                    var root = host();
                    if (!root) { return; }
                    root.replaceChildren(dialog);
                    document.documentElement.classList.add("new-admin-dialog-open");
                    dialog.addEventListener("close", function () {
                        dialog.remove();
                        document.documentElement.classList.remove("new-admin-dialog-open");
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

                function open(url, fallback) {
                    fetch(url, {
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

                function replaceFromResponse(dialog, response) {
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

                document.addEventListener("click", function (event) {
                    var target = event.target;
                    if (!target || !target.closest) { return; }

                    var trigger = target.closest("[data-admin-dialog-url]");
                    if (trigger) {
                        event.preventDefault();
                        open(
                            trigger.getAttribute("data-admin-dialog-url"),
                            trigger.getAttribute("href")
                        );
                        return;
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
                    var form = event.target;
                    if (!form || !form.closest) { return; }
                    var dialog = form.closest("dialog[data-admin-dialog]");
                    if (!dialog) { return; }

                    event.preventDefault();
                    var body = new URLSearchParams();
                    new FormData(form).forEach(function (value, key) {
                        body.append(key, typeof value === "string" ? value : "");
                    });
                    fetch(form.action, {
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
                        window.location.href = form.action;
                    });
                });
            }());
            """#
        ]
    }
}
