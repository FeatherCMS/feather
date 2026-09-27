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

                window.__newAdminDialog = {
                    mountHTML: mountHTML,
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
                    if (event.defaultPrevented) { return; }
                    var form = event.target;
                    if (!form || !form.closest) { return; }
                    var dialog = form.closest("dialog[data-admin-dialog]");
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
