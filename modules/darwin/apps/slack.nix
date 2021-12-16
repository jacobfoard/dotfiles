_:
{
  config.system.activationScripts.postUserActivation.text = ''
    sudo codesign --remove-signature /Applications/Slack.app
    sudo codesign --remove-signature /Applications/Slack.app/Contents/Frameworks/Slack\ Helper\ \(GPU\).app
    sudo codesign --remove-signature /Applications/Slack.app/Contents/Frameworks/Slack\ Helper\ \(Renderer\).app
    sudo codesign --remove-signature /Applications/Slack.app/Contents/Frameworks/Slack\ Helper\ \(Plugin\).app
  '';
}
