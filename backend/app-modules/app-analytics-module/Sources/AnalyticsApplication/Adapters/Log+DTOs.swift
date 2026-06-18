import AnalyticsDomain
import Foundation

public extension Log {
    var asListItem: LogList.Item {
        .init(
            id: id,
            accountId: accountId,
            source: source.rawValue,
            method: method,
            path: path,
            responseCode: responseCode,
            ip: ip,
            browserName: browserName,
            createdAt: createdAt.timeIntervalSince1970
        )
    }

    var asDetail: LogDetail {
        .init(
            id: id,
            accountId: accountId,
            source: source.rawValue,
            method: method,
            url: url,
            headers: headers,
            ip: ip,
            path: path,
            referer: referer,
            origin: origin,
            acceptLanguage: acceptLanguage,
            userAgent: userAgent,
            language: language,
            region: region,
            osName: osName,
            osVersion: osVersion,
            browserName: browserName,
            browserVersion: browserVersion,
            engineName: engineName,
            engineVersion: engineVersion,
            deviceVendor: deviceVendor,
            deviceType: deviceType,
            deviceModel: deviceModel,
            cpu: cpu,
            responseCode: responseCode,
            createdAt: createdAt.timeIntervalSince1970,
            updatedAt: updatedAt.timeIntervalSince1970
        )
    }
}
