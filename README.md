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
| `content/posts/` | markdown posts |

The home page is a terminal-multiplexer layout: panes with a tmux-style status
bar, `hjkl` or arrows to move focus, `1`–`5` to jump, `?` for help. Posts drop
the grid for a single reading pane — mono chrome, serif body, because mono is
tiring past a few hundred words.
