//
//  SystemInstaller.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import FeatherCore

struct SystemInstaller: ViperInstaller {

    func variables() -> [[String: Any]] {
        [
            [
                "key": "site.title",
                "value": "Feather",
                "note": "Title of the website",
                "hidden": true,
            ],
            [
                "key": "site.excerpt",
                "value": "Feather is an open-source CMS written in Swift using Vapor 4.",
                "note": "Description of the website",
                "hidden": true,
            ],
            [
                "key": "site.color.primary",
                "note": "Primary color of the website",
                "hidden": true,
            ],
            [
                "key": "site.color.secondary",
                "note": "Secondary color of the website",
                "hidden": true,
            ],
            [
                "key": "site.font.family",
                "note": "Custom font family for the site",
                "hidden": true,
            ],
            [
                "key": "site.font.size",
                "note": "Custom font size for the site",
                "hidden": true,
            ],
            [
                "key": "site.locale",
                "value": "en_US",
                "note": "Locale code of the website (eg. en_US)",
                "hidden": true,
            ],
            [
                "key": "site.timezone",
                "value": "America/Los_Angeles",
                "note": "Timezone of the website (eg. America/Los_Angeles)",
                "hidden": true,
            ],
            [
                "key": "site.css",
                "note": "Global CSS injection for the site",
                "hidden": true,
            ],
            [
                "key": "site.js",
                "note": "Global JavaScript injection for the site",
                "hidden": true,
            ],
            [
                "key": "site.footer",
                "value": "",
                "note": "Custom contents for the footer",
                "hidden": true,
            ],
            [
                "key": "site.copy",
                "value": "This site is powered by <a href=\"https://github.com/binarybirds/feather\" target=\"_blank\">Feather</a>",
                "note": "",
                "hidden": true,
            ],
            [
                "key": "home.page.title",
                "value": "Home page title",
                "note": "Title of the home page",
            ],
            [
                "key": "home.page.description",
                "value": "Home page description",
                "note": "Description of the home page",
            ],
            [
                "key": "page.not.found.icon",
                "value": "🙉",
                "note": "Icon for the not found page",
            ],
            [
                "key": "page.not.found.title",
                "value": "Page not found",
                "note": "Title of the not found page",
            ],
            [
                "key": "page.not.found.description",
                "value": "Unfortunately the requested page is not available.",
                "note": "Description of the not found page",
            ],
            [
                "key": "page.not.found.link",
                "value": "Go to the home page →",
                "note": "Retry link text for the not found page",
            ],
            [
                "key": "empty.list.icon",
                "value": "🔍",
                "note": "Icon for the empty list box",
            ],
            [
                "key": "empty.list.title",
                "value": "Empty list",
                "note": "Title of the empty list box",
            ],
            [
                "key": "empty.list.description",
                "value": "Unfortunately there are no results.",
                "note": "Description of the empty list box",
            ],
            [
                "key": "empty.list.link",
                "value": "Try again from scratch →",
                "note": "Start over link text for the empty list box",
            ],
        ]
    }
}
