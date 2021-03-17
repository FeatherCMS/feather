//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 01. 05..
//

import FeatherCore
import LiquidLocalDriver

extension Feather {

    func useLocalFileStorage() {
        use(fileStorage: .local(publicUrl: Application.baseUrl,
                                publicPath: Application.Paths.public.path,
                                workDirectory: Application.Directories.assets),
            fileStorageId: .local)
    }
}

