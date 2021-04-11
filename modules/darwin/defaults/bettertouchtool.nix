{ ... }:

{
  config.system.activationScripts.userDefaults.text = ''
    defaults write com.hegenberg.BetterTouchTool BTTShowControlStripItem -bool false
    defaults write com.hegenberg.BetterTouchTool BTTTouchBarVisible -bool false
    defaults write com.hegenberg.BetterTouchTool launchOnStartup -bool true
    defaults write com.hegenberg.BetterTouchTool showicon -bool false
    defaults write com.hegenberg.BetterTouchTool windowSnappingEnabled -bool false
  '';
}

