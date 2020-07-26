//
//  SponsorModule.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 16..
//

import Vapor
import Fluent
import ViperKit

final class SponsorModule: ViperModule {

    static var name: String = "sponsor"
    
    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        switch name {
        case "install":
            return self.installHook(req: req)
        default:
            return nil
        }
    }

    private func installHook(req: Request) -> EventLoopFuture<Any?>? {
        req.eventLoop.flatten([
            req.variables.set("sponsor.isEnabled", value: "true"),
            req.variables.set("sponsor.title", value: "Sponsor title"),
            req.variables.set("sponsor.description", value: "Sponsor description"),
            req.variables.set("sponsor.image.title", value: "sponsor image title"),
            req.variables.set("sponsor.image.url", value: "sponsor image link"),
            req.variables.set("sponsor.button.title", value: "click me"),
            req.variables.set("sponsor.button.url", value: "https://theswiftdev.com/about/"),
            req.variables.set("sponsor.more.title", value: "thank you"),
            req.variables.set("sponsor.more.url", value: "https://theswiftdev.com/"),
        ])
        .map { $0 as Any }
    }
}
