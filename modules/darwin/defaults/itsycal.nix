_:
{
  config.system.activationScripts.userDefaults.text = ''
    defaults write com.mowglii.ItsycalApp ClockFormat -string "E MMM dd h:mm a"
    defaults write com.mowglii.ItsycalApp HideIcon -int 1
    defaults write com.mowglii.ItsycalApp ShowEventDays -int 7
    defaults write com.mowglii.ItsycalApp SizePreference -int 1
    defaults write com.mowglii.ItsycalApp UseOutlineIcon -int 0
    defaults write com.mowglii.ItsycalApp HighlightedDOWs -int 62
    defaults write com.mowglii.ItsycalApp ShowLocation -int 1
    defaults write com.mowglii.ItsycalApp ShowWeeks -int 1
  '';
}

