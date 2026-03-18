{ pkgs, ... }:

{
  home.packages = with pkgs.llm-agents; [
    # agent-browser
    ccstatusline
  ];

  # home.file.".claude/skills/agent-browser".source =
  #   "${pkgs.llm-agents.agent-browser}/etc/agent-browser/skills/agent-browser";
}
