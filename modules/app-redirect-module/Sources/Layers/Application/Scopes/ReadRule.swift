//
//  ReadRule.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import RedirectDomain

public struct ReadRule: Scope {
    public let rule: any RuleQueries

    public init(rule: any RuleQueries) {
        self.rule = rule
    }
}
