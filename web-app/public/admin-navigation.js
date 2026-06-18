(function () {
    var key = "adminMenuCollapsed";
    var menuToggle = document.getElementById("menuToggle");
    var toastNode = document.getElementById("admin-toast");

    if (menuToggle) {
        try {
            var collapsed = window.localStorage.getItem(key);
            if (collapsed === "1") {
                menuToggle.checked = true;
            }
        }
        catch (_) {
            // Ignore storage access errors and fall back to default behavior.
        }

        menuToggle.addEventListener("change", function () {
            try {
                window.localStorage.setItem(key, menuToggle.checked ? "1" : "0");
            }
            catch (_) {
                // Ignore storage access errors and keep UI functional.
            }
        });
    }

    if (!toastNode || !window.toast) {
        return;
    }

    window.toast.show({
        type: toastNode.dataset.toastType || "success",
        title: toastNode.dataset.toastTitle || "Success",
        message: toastNode.dataset.toastMessage || "",
        position: toastNode.dataset.toastPosition || "top-right"
    });

    try {
        var url = new URL(window.location.href);
        [
            "toastType",
            "toastTitle",
            "toastMessage",
            "toastPosition"
        ].forEach(function (queryKey) {
            url.searchParams.delete(queryKey);
        });
        var next = url.pathname;
        var search = url.searchParams.toString();
        if (search) {
            next += "?" + search;
        }
        if (url.hash) {
            next += url.hash;
        }
        window.history.replaceState(window.history.state, "", next);
    }
    catch (_) {
        // Ignore History and URL API errors.
    }
})();
