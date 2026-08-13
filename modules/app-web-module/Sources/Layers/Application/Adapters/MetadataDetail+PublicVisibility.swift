//
//  MetadataDetail+PublicVisibility.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Foundation
import WebDomain

extension MetadataDetail {

    public func isPublic(
        at date: Date
    ) -> Bool {
        status == .published && isWithinPublicationWindow(at: date)
    }

    public func isDirectlyAccessible(
        at date: Date
    ) -> Bool {
        switch status {
        case .draft:
            return true
        case .published:
            return isWithinPublicationWindow(at: date)
        case .archived:
            return false
        }
    }

    private func isWithinPublicationWindow(
        at date: Date
    ) -> Bool {
        guard publicationDate <= date else {
            return false
        }
        if let expirationDate, expirationDate <= date {
            return false
        }
        return true
    }
}
