//
//  SplashModule.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 17..
//

import Vapor
import Fluent
import ViperKit
import Splash

final class SplashModule: ViperModule {

    static var name: String = "splash"
    
    func invokeSync(name: String, req: Request, params: [String: Any]) -> Any? {
        switch name {
        case "content-filter":
            return [SplashFilter()]
        default:
            return nil
        }
    }
    
}
