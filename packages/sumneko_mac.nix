self: super: {
  sumneko-lua-language-server-mac = super.sumneko-lua-language-server.overrideAttrs (
    let
      version = "2.5.5";
      platform = if super.stdenv.isDarwin then "darwin" else "linux";
      arch = if super.stdenv.isx86_64 then "x64" else "arm64";

      finalUrl = "https://github.com/sumneko/vscode-lua/releases/download/v${version}/vscode-lua-v${version}-${platform}-${arch}.vsix";
      sha = if super.stdenv.isx86_64 then "0qqqic1w0mm5f4zyjp1hgixnkvd88cxafjjia28sjq0q8xdhz04x" else "1rbl3kcdc02id0a83i3jd5fsnw5dzv2fb44mc87km3yjmdj4kw1z";
    in
    o: rec {
      inherit version platform;

      src = builtins.fetchurl {
        url = finalUrl;
        sha256 = sha;
      };

      unpackPhase = ''
        ${super.pkgs.unzip}/bin/unzip $src
      '';

      preBuild = "";
      postBuild = "";
      nativeBuildInputs = [
        super.makeWrapper
      ];

      installPhase = ''
        mkdir -p $out
        cp -r extension $out/extras
        chmod a+x $out/extras/server/bin/lua-language-server 
        makeWrapper $out/extras/server/bin/lua-language-server \
          $out/bin/lua-language-server \
          --add-flags "-E -e LANG=en $out/extras/server/main.lua \
          --logpath='~/.cache/sumneko_lua/log' \
          --metapath='~/.cache/sumneko_lua/meta'"
      '';

      meta.platforms = super.lib.platforms.all;
    }
  );
}
