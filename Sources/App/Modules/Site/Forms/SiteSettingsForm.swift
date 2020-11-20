//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import FeatherCore

final class SiteSettingsForm: Form {

    struct Input: Decodable {
        var title: String
        var excerpt: String
        var primaryColor: String
        var secondaryColor: String
        var fontFamily: String
        var fontSize: String
        var locale: String
        var timezone: String
        var css: String
        var js: String
        var footer: String
        var footerBottom: String
        var copy: String
        var copyYearStart: String
        var image: File?
        var imageDelete: Bool?
    }

    var title = StringFormField()
    var excerpt = StringFormField()
    var primaryColor = StringFormField()
    var secondaryColor = StringFormField()
    var fontFamily = StringFormField()
    var fontSize = StringFormField()
    var locale = StringSelectionFormField()
    var timezone = StringSelectionFormField()
    var css = StringFormField()
    var js = StringFormField()
    var footer = StringFormField()
    var footerBottom = StringFormField()
    var copy = StringFormField()
    var copyYearStart = StringFormField()
    var image = FileFormField()
    var notification: String?

    var leafData: LeafData {
        .dictionary([
            "title": title,
            "excerpt": excerpt,
            "primaryColor": primaryColor,
            "secondaryColor": secondaryColor,
            "fontFamily": fontFamily,
            "fontSize": fontSize,
            "locale": locale,
            "timezone": timezone,
            "css": css,
            "js": js,
            "footer": footer,
            "footerBottom": footerBottom,
            "copy": copy,
            "copyYearStart": copyYearStart,
            "image": image,
            "notification": notification,
        ])
    }

    init() {
        initialize()
    }

    init(req: Request) throws {
        initialize()

        let context = try req.content.decode(Input.self)
        title.value = context.title
        excerpt.value = context.excerpt
        primaryColor.value = context.primaryColor
        secondaryColor.value = context.secondaryColor
        fontFamily.value = context.fontFamily
        fontSize.value = context.fontSize
        locale.value = context.locale
        timezone.value = context.timezone
        css.value = context.css
        js.value = context.js
        footer.value = context.footer
        footerBottom.value = context.footerBottom
        copy.value = context.copy
        copyYearStart.value = context.copyYearStart

        image.delete = context.imageDelete ?? false
        if let img = context.image, let data = img.data.getData(at: 0, length: img.data.readableBytes), !data.isEmpty {
            image.data = data
        }
    }

    func initialize() {
        locale.options = FormFieldStringOption.locales
        timezone.options = FormFieldStringOption.gmtTimezones
    }

    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true
       
        if title.value.isEmpty {
            title.error = "Title is required"
            valid = false
        }
        if Validator.count(...250).validate(title.value).isFailure {
            title.error = "Title is too long (max 250 characters)"
            valid = false
        }

        if copy.value.isEmpty {
            copy.error = "Copyright text is required"
            valid = false
        }
        
        return req.eventLoop.future(valid)
    }
}
