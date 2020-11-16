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
            ],
            [
                "key": "site.excerpt",
                "value": "Feather is an open-source CMS written in Swift using Vapor 4.",
                "note": "Description of the website",
            ],
            [
                "key": "site.css",
                "note": "Global CSS injection for the site",
            ],
            [
                "key": "site.js",
                "note": "Global JavaScript injection for the site",
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
                "value": "This page is not available anymore.",
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
