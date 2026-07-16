//
//  Settings+DTOs.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import WebDomain

extension Settings {

    var asDetail: SettingsDetail {
        .init(
            id: id,
            logo: logo,
            logoDark: logoDark,
            metaImage: metaImage,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            tertiaryColor: tertiaryColor,
            primaryFont: primaryFont,
            secondaryFont: secondaryFont,
            homePageId: homePageId,
            locale: locale,
            timezone: timezone,
            title: title,
            excerpt: excerpt,
            noIndex: noIndex,
            css: css,
            js: js
        )
    }
}
