import SwiftUI

struct EeveeLyricsSettingsView: View {
    
    @State var musixmatchToken = UserDefaults.musixmatchToken
    @State var lyricsSource = UserDefaults.lyricsSource
    @State var lrclibFallback = UserDefaults.lrclibFallback
    @State var lyricsOptions = UserDefaults.lyricsOptions
    @State var instrumentalgap = UserDefaults.instrumentalgap

    @State var showLanguageWarning = false
    
    var body: some View {
        List {
            LyricsSourceSection()
            
            if lyricsSource == .beautiful {
                Section(
                    footer: Text("Amount of time between lyrics before it's marked as instrumental.")
                ) {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Instrumental Gap \(instrumentalgap, specifier: "%.1f") seconds")
                        
                        Slider(
                            value: $instrumentalgap,
                            in: 5...15,
                            step: 0.5
                        )
                    }
                }
            }

            if lyricsSource != .lrclib {
                Section(
                    footer: Text("lrclib_fallback_description".localizeWithFormat(lyricsSource.description))
                ) {
                    Toggle(
                        "lrclib_fallback".localized,
                        isOn: $lrclibFallback
                    )
                    
                    if lrclibFallback {
                        Toggle(
                            "show_fallback_reasons".localized,
                            isOn: Binding<Bool>(
                                get: { UserDefaults.fallbackReasons },
                                set: { UserDefaults.fallbackReasons = $0 }
                            )
                        )
                    }
                }
            }
            
            //
            
            Section(footer: Text("romanized_lyrics_description".localized)) {
                Toggle(
                    "romanized_lyrics".localized,
                    isOn: $lyricsOptions.romanization
                )
            }
            
            if lyricsSource == .musixmatch {
                Section {
                    HStack {
                        if showLanguageWarning {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title3)
                                .foregroundColor(.yellow)
                        }
                        
                        Text("musixmatch_language".localized)

                        Spacer()
                        
                        TextField("en", text: $lyricsOptions.musixmatchLanguage)
                            .frame(maxWidth: 20)
                            .foregroundColor(.gray)
                    }
                } footer: {
                    Text("musixmatch_language_description".localized)
                }
            }
            
            if !UIDevice.current.isIpad {
                Spacer()
                    .frame(height: 40)
                    .listRowBackground(Color.clear)
                    .modifier(ListRowSeparatorHidden())
            }
        }
        .listStyle(GroupedListStyle())
        
        .animation(.default, value: lyricsSource)
        .animation(.default, value: showLanguageWarning)
        .animation(.default, value: lrclibFallback)
        
        .onChange(of: instrumentalgap) { newGap in
            UserDefaults.instrumentalgap = newGap
        }
        
        .onChange(of: lrclibFallback) { lrclibFallback in
            UserDefaults.lrclibFallback = lrclibFallback
        }
        
        .onChange(of: lyricsOptions) { lyricsOptions in
            let selectedLanguage = lyricsOptions.musixmatchLanguage
            
            if selectedLanguage.isEmpty || selectedLanguage ~= "^[\\w\\d]{2}$" {
                showLanguageWarning = false
                
                MusixmatchLyricsRepository.shared.selectedLanguage = selectedLanguage
                UserDefaults.lyricsOptions = lyricsOptions
                
                return
            }
            
            showLanguageWarning = true
        }
    }
}
