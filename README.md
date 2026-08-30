# stole.ro

Personal site for [noam.stole.ro](https://noam.stole.ro). Hugo, deployed to
Cloudflare Workers as static assets.

```sh
nix develop          # hugo, wrangler, node
hugo server -D       # live reload on :1313, includes drafts
nix build            # -> result/  (same output as `hugo --minify`)
```

Writing a post:

```sh
hugo new content posts/some-title.md
```

Deploying:

```sh
hugo --minify --destination public
wrangler deploy
```

## Layout

| Path | |
| --- | --- |
| `layouts/home.html` | the pane grid, status bar, and keyboard navigation |
| `layouts/page.html` | a single post |
| `layouts/section.html` | the post index |
| `layouts/_partials/style.html` | all CSS |
| `static/fonts/` | IBM Plex Mono subset, self-hosted |
| `content/posts/` | markdown posts |

The home page is a terminal-multiplexer layout: panes with a tmux-style status
bar, `hjkl` or arrows to move focus, `1`–`5` to jump, `?` for help. Posts drop
the grid for a single reading pane — mono chrome, serif body, because mono is
tiring past a few hundred words.

## Fonts

`--mono` keeps Berkeley Mono first, so anyone who owns it renders that and
downloads nothing. Everyone else falls through to IBM Plex Mono, self-hosted
from `static/fonts/` — weights 400 and 500, latin subset, ~29 KB total.

Regenerate after an `ibm-plex` bump:

```sh
nix shell --impure --expr 'with import <nixpkgs> {}; python3.withPackages (ps: [ ps.fonttools ps.brotli ])' -c sh -c '
  d=$(nix build --no-link --print-out-paths nixpkgs#ibm-plex)/share/fonts/opentype
  U="U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD"
  pyftsubset "$d/IBMPlexMono-Regular.otf" --output-file=static/fonts/ibm-plex-mono-400.woff2 --flavor=woff2 --unicodes="$U"
  pyftsubset "$d/IBMPlexMono-Medium.otf"  --output-file=static/fonts/ibm-plex-mono-500.woff2 --flavor=woff2 --unicodes="$U"
'
```

No italic face: the only italic text is one line of mono, where a synthesized
oblique is fine. `--prose` (IBM Plex Serif) is not self-hosted either — it
applies only to posts, and Georgia is a good fallback until there are some.
