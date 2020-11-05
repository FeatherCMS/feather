//
//  AdminController.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

struct AdminController {

    func homeView(req: Request) throws -> EventLoopFuture<View> {
        req.leaf.render(template: "Admin/Home")
    }
}
