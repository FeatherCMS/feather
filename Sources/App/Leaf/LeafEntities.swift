//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 10. 09..
//

import FeatherCore

public struct InlineSvg: LeafNonMutatingMethod, Invariant, StringReturn {

    public static var callSignature: [LeafCallParameter] {
        [
            .string,
            .string(labeled: "class", optional: true, defaultValue: "")
        ]
    }
    
    public func evaluate(_ params: LeafCallValues) -> LeafData {
        let name = params[0].string!
        let path = Application.Paths.public + Application.Locations.images + "feather-icons/" + name + ".svg"
        do {
            var svg = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
            let cls = params[1].string!
            if !cls.isEmpty {
                svg = svg.replacingOccurrences(of: "<svg", with: "<svg class=\"\(cls)\" ")
            }
            return .string(svg)
        }
        catch {
            return .string("!\(name)!")
        }
    }
}
