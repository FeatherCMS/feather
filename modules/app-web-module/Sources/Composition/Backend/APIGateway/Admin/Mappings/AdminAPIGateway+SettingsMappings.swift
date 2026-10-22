import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import Foundation
import WebAdminAPI
import WebAppAPI
import WebApplication
import WebDomain

extension AdminAPIGateway {
    func map(_ detail: Settings.Detail.Output)
        -> WebAdminAPI.Components.Schemas.SettingsDetailSchema
    {
        .init(
            logo: detail.logo,
            logoDark: detail.logoDark,
            metaImage: detail.metaImage,
            primaryColor: detail.primaryColor,
            secondaryColor: detail.secondaryColor,
            tertiaryColor: detail.tertiaryColor,
            primaryFont: detail.primaryFont,
            secondaryFont: detail.secondaryFont,
            homePageId: detail.homePageId,
            locale: detail.locale,
            timezone: detail.timezone,
            title: detail.title,
            excerpt: detail.excerpt,
            noIndex: detail.noIndex,
            css: detail.css,
            js: detail.js
        )
    }
}
