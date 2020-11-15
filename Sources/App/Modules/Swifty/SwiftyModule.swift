//
//  SwiftyModule.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 17..
//

import Vapor
import Fluent
import ViperKit

final class SwiftyModule: ViperModule {

    static var name: String = "swifty"
    
    func invokeSync(name: String, req: Request, params: [String: Any]) -> Any? {
        switch name {
        case "content-filter":
            return [SwiftyFilter()]
        default:
            return nil
        }
    }
    
}
