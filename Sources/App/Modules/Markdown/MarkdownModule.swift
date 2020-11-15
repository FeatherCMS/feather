//
//  MarkdownModule.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 17..
//

import Vapor
import Fluent
import ViperKit

final class MarkdownModule: ViperModule {

    static var name: String = "markdown"

    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "content-filter":
            return [MarkdownFilter()]
        default:
            return nil
        }
    }
}
