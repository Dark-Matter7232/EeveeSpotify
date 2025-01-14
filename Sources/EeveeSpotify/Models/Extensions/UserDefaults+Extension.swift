import Foundation

extension UserDefaults {
    
    private static let defaults = UserDefaults.standard
    
    private static let lyricsSourceKey = "lyricsSource"
    private static let musixmatchTokenKey = "musixmatchToken"
    private static let lrclibFallbackKey = "lrclibFallback"
    private static let fallbackReasonsKey = "fallbackReasons"
    private static let darkPopUpsKey = "darkPopUps"
    private static let patchTypeKey = "patchType"
    private static let overwriteConfigurationKey = "overwriteConfiguration"
    private static let lyricsColorsKey = "lyricsColors"
    private static let lyricsOptionsKey = "lyricsOptions"
    private static let hasShownCommonIssuesTipKey = "hasShownCommonIssuesTip"
    private static let instrumentalgapKey = "instrumentalgap"

    static var lyricsSource: LyricsSource {
        get {
            if let rawValue = defaults.object(forKey: lyricsSourceKey) as? Int {
                return LyricsSource(rawValue: rawValue)!
            }

            if Locale.isInRegion("JP", orHasLanguage: "ja") {
                return .petit
            }
            
            return .lrclib
        }
        set (newSource) {
            defaults.set(newSource.rawValue, forKey: lyricsSourceKey)
        }
    }

    static var musixmatchToken: String {
        get {
            defaults.string(forKey: musixmatchTokenKey) ?? ""
        }
        set (token) {
            defaults.set(token, forKey: musixmatchTokenKey)
        }
    }

    static var lrclibFallback: Bool {
        get {
            defaults.object(forKey: lrclibFallbackKey) as? Bool ?? true
        }
        set (fallback) {
            defaults.set(fallback, forKey: lrclibFallbackKey)
        }
    }

    static var lyricsOptions: LyricsOptions {
        get {
            if let data = defaults.object(forKey: lyricsOptionsKey) as? Data, 
            let lyricsOptions = try? JSONDecoder().decode(LyricsOptions.self, from: data) {
                return lyricsOptions
            }
            
            return LyricsOptions(
                romanization: false,
                musixmatchLanguage: Locale.current.languageCode ?? ""
            )
        }
        set (lyricsOptions) {
            defaults.set(try! JSONEncoder().encode(lyricsOptions), forKey: lyricsOptionsKey)
        }
    }
    
    static var fallbackReasons: Bool {
        get {
            defaults.object(forKey: fallbackReasonsKey) as? Bool ?? true
        }
        set (reasons) {
            defaults.set(reasons, forKey: fallbackReasonsKey)
        }
    }

    static var darkPopUps: Bool {
        get {
            defaults.object(forKey: darkPopUpsKey) as? Bool ?? true
        }
        set (darkPopUps) {
            defaults.set(darkPopUps, forKey: darkPopUpsKey)
        }
    }

    static var patchType: PatchType {
        get {
            if let rawValue = defaults.object(forKey: patchTypeKey) as? Int {
                return PatchType(rawValue: rawValue) ?? .requests
            }

            return .notSet
        }
        set (patchType) {
            defaults.set(patchType.rawValue, forKey: patchTypeKey)
        }
    }
    
    static var overwriteConfiguration: Bool {
        get {
            defaults.bool(forKey: overwriteConfigurationKey)
        }
        set (overwriteConfiguration) {
            defaults.set(overwriteConfiguration, forKey: overwriteConfigurationKey)
        }
    }
    
    static var hasShownCommonIssuesTip: Bool {
        get {
            defaults.bool(forKey: hasShownCommonIssuesTipKey)
        }
        set (hasShownCommonIssuesTip) {
            defaults.set(hasShownCommonIssuesTip, forKey: hasShownCommonIssuesTipKey)
        }
    }
    
    static var instrumentalgap: Double {
        get {
            let value = defaults.double(forKey: instrumentalgapKey)
            return value == 0 ? 5 : value
        }
        set (newGap) {
            defaults.set(newGap, forKey: instrumentalgapKey)
        }
    }
    
    static var lyricsColors: LyricsColorsSettings {
        get {
            if let data = defaults.object(forKey: lyricsColorsKey) as? Data {
                return try! JSONDecoder().decode(LyricsColorsSettings.self, from: data)
            }
            
            return LyricsColorsSettings(
                displayOriginalColors: true,
                useStaticColor: false,
                staticColor: "",
                normalizationFactor: 0.5
            )
        }
        set (lyricsColors) {
            defaults.set(try! JSONEncoder().encode(lyricsColors), forKey: lyricsColorsKey)
        }
    }
}
