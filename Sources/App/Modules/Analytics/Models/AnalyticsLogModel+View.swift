//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

import FeatherCore

extension AnalyticsLogModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "date": date.timeIntervalSinceReferenceDate,
            "session": session,
            "method": method,
            "url": url,
            "headers": headers,
            "ip": ip,
            "path": path,
            "referer": referer,
            "origin": origin,
            "language": language,
            "region": region,
            "os": [
                "name": osName,
                "version": osVersion,
            ],
            "browser": [
                "name": browserName,
                "version": browserVersion,
            ],
            "engine": [
                "name": engineName,
                "version": engineVersion,
            ],
            "device": [
                "vendor": deviceVendor,
                "type": deviceType,
                "model": deviceModel,
            ],
            "cpu": cpu,
        ])
    }
}
