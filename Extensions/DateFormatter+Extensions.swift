//
//  DateFormatter+Extensions.swift
//  Extensions
//
//  Created by Andrew Chersky  on 4/6/18.
//

import Foundation

public extension DateFormatter {
    public static var dayNumberAndName: DateFormatter {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "uk_UA")
        formatter.locale = locale
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d MMMM", options: 0, locale: locale)
        return formatter.localized.copy() as! DateFormatter
    }
    
    public static var weekday: DateFormatter {
        let formatter = DateFormatter()
        let locale = Locale(identifier: "uk_UA")
        formatter.locale = locale
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: locale)
        return formatter.localized.copy() as! DateFormatter
    }
    
    public static var server: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.copy() as! DateFormatter
    }
    
    private var localized: DateFormatter {
        let prefferedLocale =  Locale.preferredLanguages.first ?? ""
        let localizedLocale: Locale
        if prefferedLocale == "ru-UA" || prefferedLocale == "en-UA" || prefferedLocale == "uk-UA" {
            localizedLocale = Locale(identifier: "uk_UA")
        } else {
            localizedLocale = Locale(identifier: "en_UA")
        }
        locale = localizedLocale
        dateFormat = DateFormatter.dateFormat(fromTemplate: dateFormat, options: 0, locale: localizedLocale)
        return self
    }
}
