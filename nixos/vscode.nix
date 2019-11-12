{ config, pkgs, ... }:
{
  users.users.cyryl = {
    packages = with pkgs; [
      (unstable.vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [ bbenoist.Nix  ]
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            publisher = "ms-python";
            name = "python";
            version = "2019.10.41019";
            sha256 = "0szikd76vy8mgv8zc0m90rx1jrnwwphx5bb8928drln65xwbzs1q";
          }
          {
            publisher = "justusadam";
            name = "language-haskell";
            version = "2.6.0";
            sha256 = "1891pg4x5qkh151pylvn93c4plqw6vgasa4g40jbma5xzq8pygr4";
          }
          {
            publisher = "UCL";
            name = "haskelly";
            version = "0.5.5";
            sha256 = "0s6a3hdckn2ssk7wkxdv09c0gjk4g0h8071bf7x8br0brnnrwsgi";
          }
          {
            publisher = "TabNine";
            name = "tabnine-vscode";
            version = "2.1.10";
            sha256 = "10z9xn9haagyky5h9f8r7jfj5q9973lxknjqjm7bqks0qmvpxif3";
          }
          {
            publisher = "2gua";
            name = "rainbow-brackets";
            version = "0.0.6";
            sha256 = "1m5c7jjxphawh7dmbzmrwf60dz4swn8c31svbzb5nhaazqbnyl2d";
          }
          {
            publisher = "vscodevim";
            name = "vim";
            version = "1.4.0";
            sha256 = "0vfhvsp485rgik3pjzbpnc4jxrjpiykynl563a16rlz8h85x2m4f";
          }
          {
            publisher = "swyphcosmo";
            name = "spellchecker";
            version = "1.2.13";
            sha256 = "1lr33lf01afgi74c1a9gylk92li4hyq24l8bki4l6ggl4z4c2h3w";
          }
          {
            publisher = "asabil";
            name = "meson";
            version = "1.1.1";
            sha256 = "00cc28a2nb325f54bx51wf5q15x1pmsn0j9z6rnxxqxwii1dm5cl";
          }
          {
            publisher = "bungcip";
            name = "better-toml";
            version = "0.3.2";
            sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
          }
          {
            publisher = "codezombiech";
            name = "gitignore";
            version = "0.6.0";
            sha256 = "0gnc0691pwkd9s8ldqabmpfvj0236rw7bxvkf0bvmww32kv1ia0b";
          }
          {
            publisher = "DavidAnson";
            name = "vscode-markdownlint";
            version = "0.26.0";
            sha256 = "0g4pssvajn7d8p2547v7313gjyqx4pzs7cbjws2s3v2fk1sw7vbj";
          }
          {
            publisher = "esbenp";
            name = "prettier-vscode";
            version = "1.8.1";
            sha256 = "0qcm2784n9qc4p77my1kwqrswpji7bp895ay17yzs5g84cj010ln";
          }
          {
            publisher = "hbenl";
            name = "vscode-test-explorer";
            version = "2.9.3";
            sha256 = "1yf85hgvganxq5n5jff9ckn3smxd6xi79cgn6k53qi5w1r5rahy0";
          }
          {
            publisher = "lextudio";
            name = "restructuredtext";
            version = "106.0.0";
            sha256 = "096r8071202nxi1is6z7dghcmpsh0f0mm3mp3cfh1yj2mnyzlaxa";
          }
          {
            publisher = "lostintangent";
            name = "vsls-pomodoro";
            version = "0.1.0";
            sha256 = "1b73zbkhlhacvi18cx4g3n6randy3hw9cab1gkw5gzb3375w7w3p";
          }
          {
            publisher = "lostintangent";
            name = "vsls-whiteboard";
            version = "0.0.8";
            sha256 = "13fcay9bs861msb5y694casbw66dmhl504xm5cvprssx1qka186p";
          }
          {
            publisher = "mauve";
            name = "terraform";
            version = "1.3.9";
            sha256 = "0hnarr21rivvv41y5x1sp0skdmzwz7zi9aya3n5z1b13ir7lyy42";
          }
          {
            publisher = "mechatroner";
            name = "rainbow-csv";
            version = "1.0.0";
            sha256 = "1fyamgm7zq31r3c00cn6pcb66rrkfhwfmp72qnhrajydmnvcnbg6";
          }
          {
            publisher = "ms-vscode";
            name = "Go";
            version = "0.9.2";
            sha256 = "0yxnsby8zz1dvnx8nqrhi4xx316mpjf2hs2c5r6fkzh8zhjccwqz";
          }
          {
            publisher = "ronnidc";
            name = "nunjucks";
            version = "0.2.3";
            sha256 = "119xgyn1dggw2rcqkn2mnz364iw5jlrxg7pcydbijsqj5d3zdfsf";
          }
          {
            publisher = "rust-lang";
            name = "rust";
            version = "0.6.1";
            sha256 = "0f66z6b374nvnrn7802dg0xz9f8wq6sjw3sb9ca533gn5jd7n297";
          }
          {
            publisher = "serayuzgur";
            name = "crates";
            version = "0.4.2";
            sha256 = "1knspsc98cfw4mhc0yaz0f2185sxdf9kn9qsysfs6c82g9wjaqcj";
          }
        ];})
      ];
    };
  }
