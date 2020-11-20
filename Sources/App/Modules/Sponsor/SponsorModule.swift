//
//  SponsorModule.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 16..
//

import FeatherCore

final class SponsorModule: ViperModule {

    static var name: String = "sponsor"

    var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }
    
    // MARK: - hook functions

    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "installer":
            return SponsorInstaller()
        default:
            return nil
        }
    }
}
