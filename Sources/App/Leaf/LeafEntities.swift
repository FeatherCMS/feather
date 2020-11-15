//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 10. 09..
//

import FeatherCore

public struct Resolve: LeafUnsafeEntity, LeafNonMutatingMethod, StringReturn {
    public var unsafeObjects: UnsafeObjects? = nil
    
    public static var callSignature: [LeafCallParameter] { [.string] }
    
    public func evaluate(_ params: LeafCallValues) -> LeafData {
        guard let req = req else { return .error("Needs unsafe access to Request") }
        return .string(req.fs.resolve(key: params[0].string!))
    }
}

public struct Hook: LeafUnsafeEntity, LeafNonMutatingMethod, StringReturn {
    public var unsafeObjects: UnsafeObjects? = nil

    public static var callSignature: [LeafCallParameter] { [.string] }

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        guard let req = req else { return .error("Needs unsafe access to Request") }
        let hookName = "leaf-\(params[0].string!)"
        return req.syncHook(hookName, type: LeafDataRepresentable.self)?.leafData ?? .trueNil
    }
}

public struct HookAll: LeafUnsafeEntity, LeafNonMutatingMethod, StringReturn {
    public var unsafeObjects: UnsafeObjects? = nil

    public static var callSignature: [LeafCallParameter] { [.string] }

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        guard let req = req else { return .error("Needs unsafe access to Request") }
        let hookName = "leaf-\(params[0].string!)"
        let item = req.syncHookAll(hookName, type: LeafDataRepresentable.self)
        return .array(item.map(\.leafData))
    }
}


public struct InlineSvg: LeafNonMutatingMethod, Invariant, StringReturn {

    public static var callSignature: [LeafCallParameter] {
        [
            .string,
            .string(labeled: "class", optional: true, defaultValue: "")
        ]
    }
    
    public func evaluate(_ params: LeafCallValues) -> LeafData {
        do {
            let path = Application.Paths.public + Application.Locations.images + "feather-icons/" + params[0].string! + ".svg"
            var svg = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
            let cls = params[1].string!
            if !cls.isEmpty {
                svg = svg.replacingOccurrences(of: "<svg", with: "<svg class=\"\(cls)\" ")
            }
            return .string(svg)
        }
        catch {
            return .error(error.localizedDescription)
        }
    }
}
