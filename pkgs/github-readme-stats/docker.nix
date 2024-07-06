{ 
  lib,
  dockerTools,
  # runCommand,
  github-readme-stats,
  nodejs,

  port ? 9000,
  ...
}:
# TODO: Figure out how to use nodejs-slim without github-readme-stats also pulling in the non-slim version.
# let
#   # avoid npm & other lib files
#   node-bin = runCommand "node-only" {} ''
#     mkdir -p $out/bin; cp ${nodejs}/bin/node $out/bin
#   '';
#   # avoid dependency on regular node
#   github-readme-stats-src = runCommand "github-readme-stats-src" {} ''
#     mkdir -p $out/src; cp -r "${github-readme-stats}/lib/node_modules/github-readme-stats" $out/src
#   '';
# in
dockerTools.buildImage {
  name = "github-readme-stats";
  tag = "latest";
  created = "now";
  config = {
    Cmd = [
      # "${node-bin}/bin/node"
      # "${github-readme-stats-src}/lib/node_modules/github-readme-stats/express.js"
      (lib.getExe nodejs)
      "${github-readme-stats}/lib/node_modules/github-readme-stats/express.js"
    ];
    ExportedPorts."${toString port}/tcp" = { };
    Env = [
      # SSL_CERT_FILE is necessary for the post requests to github's api (note that GIT_SSL_CAINFO is *not*).
      # See https://github.com/NixOS/nixpkgs/blob/c9d9fd0c619e2f73f94e4a79abad722e578ff7f1/pkgs/build-support/docker/default.nix#L871-L880
      "SSL_CERT_FILE=${dockerTools.caCertificates}/etc/ssl/certs/ca-bundle.crt"

      "port=${toString port}" # uses undercase for this
    ];
  };
}
