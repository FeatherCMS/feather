//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension ViperModel where Self: LeafDataRepresentable {
    
    func joinedMetadata() -> LeafData {
        var data: [String: LeafData] = leafData.dictionary!
        data["metadata"] = try! joined(Metadata.self).leafData
        return .dictionary(data)
    }
}
