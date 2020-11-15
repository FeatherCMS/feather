//
//  SponsorInstaller.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

struct SponsorInstaller: ViperInstaller {

    func variables() -> [[String: Any]] {
        [
            [
                "key": "sponsor.isEnabled",
                "value": "true",
                "note": "",
            ],
            [
                "key": "sponsor.title",
                "value": "Sponsor title",
                "note": "",
            ],
            [
                "key": "sponsor.description",
                "value": "Sponsor description",
                "note": "",
            ],
            [
                "key": "sponsor.image.alt",
                "value": "The.Swift.Dev.",
                "note": "",
            ],
            [
                "key": "sponsor.image.url",
                "value": "https://theswiftdev.com/images/logos/logo.png",
                "note": "",
            ],
            [
                "key": "sponsor.button.title",
                "value": "The.Swift.Dev.",
                "note": "",
            ],
            [
                "key": "sponsor.button.url",
                "value": "https://theswiftdev.com/",
                "note": "",
            ],
            [
                "key": "sponsor.more.title",
                "value": "Learn more",
                "note": "",
            ],
            [
                "key": "sponsor.more.url",
                "value": "/about/",
                "note": "",
            ],
        ]
    }
}
