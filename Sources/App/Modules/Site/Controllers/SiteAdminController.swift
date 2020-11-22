//
//  SiteFrontendController.swift
//  Site
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import FeatherCore

final class SiteAdminController {

    let logoPath = "site/logo.png"

    func settingsView(req: Request) throws -> EventLoopFuture<View> {
        let form = SiteSettingsForm()

        form.image.value = req.variables.get("site.logo") ?? ""
        form.title.value = req.variables.get("site.title") ?? ""
        form.excerpt.value = req.variables.get("site.excerpt") ?? ""
        form.primaryColor.value = req.variables.get("site.color.primary") ?? ""
        form.secondaryColor.value = req.variables.get("site.color.secondary") ?? ""
        form.fontFamily.value = req.variables.get("site.font.family") ?? ""
        form.fontSize.value = req.variables.get("site.font.size") ?? ""
        form.locale.value = Application.Config.locale.identifier
        form.clientlocale.value = Application.Config.clientlocale ? "true" : "false"
        form.timezone.value = Application.Config.timezone.identifier
        form.css.value = req.variables.get("site.css") ?? ""
        form.js.value = req.variables.get("site.js") ?? ""
        form.footer.value = req.variables.get("site.footer") ?? ""
        form.footerBottom.value = req.variables.get("site.footer.bottom") ?? ""
        form.copy.value = req.variables.get("site.copy") ?? ""
        form.copyYearStart.value = req.variables.get("site.copy.year.start") ?? ""

        return render(req: req, form: form)
    }

    func render(req: Request, form: SiteSettingsForm) -> EventLoopFuture<View> {
        let formId = UUID().uuidString
        let nonce = req.generateNonce(for: "site-settings-form", id: formId)

        return req.leaf.render(template: "Site/Admin/Settings", context: [
            "formId": .string(formId),
            "formToken": .string(nonce),
            "fields": form.leafData
        ])
    }
    
    func updateSettings(req: Request) throws -> EventLoopFuture<Response> {
        try req.validateFormToken(for: "site-settings-form")

        let form = try SiteSettingsForm(req: req)
        return form.validate(req: req).flatMap { [self] isValid in
            guard isValid else {
                return render(req: req, form: form).encodeResponse(for: req)
            }

            var future: EventLoopFuture<Void> = req.eventLoop.future()

            form.image.value = req.variables.get("site.logo") ?? ""

            if let data = form.image.data {
                future = req.fs.upload(key: logoPath, data: data).flatMap { _ in
                    form.image.value = logoPath
                    return req.variables.set("site.logo", value: logoPath)
                }
            }

            let path = Application.Paths.assets + logoPath
            if
                form.image.delete, FileManager.default.fileExists(atPath: path)
            {
                future = req.fs.delete(key: logoPath).flatMap {
                    form.image.value = ""
                    return req.variables.unset("site.logo")
                }
            }

            Application.Config.set("site.locale", value: form.locale.value)
            Application.Config.set("site.clientlocale", value: form.clientlocale.value)
            Application.Config.set("site.timezone", value: form.timezone.value)

            return req.eventLoop.flatten([
                req.variables.set("site.title", value: form.title.value),
                req.variables.set("site.excerpt", value: form.excerpt.value),
                req.variables.set("site.color.primary", value: form.primaryColor.value),
                req.variables.set("site.color.secondary", value: form.secondaryColor.value),
                req.variables.set("site.font.family", value: form.fontFamily.value),
                req.variables.set("site.font.size", value: form.fontSize.value),
                req.variables.set("site.css", value: form.css.value),
                req.variables.set("site.js", value: form.js.value),
                req.variables.set("site.footer", value: form.footer.value),
                req.variables.set("site.footer.bottom", value: form.footerBottom.value),
                req.variables.set("site.copy", value: form.copy.value),
                req.variables.set("site.copy.year.start", value: form.copyYearStart.value),
            ])
            .flatMap { future }
            .flatMap {
                render(req: req, form: form).encodeResponse(for: req)
            }
        }
    }

}
