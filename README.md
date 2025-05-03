# KiCad iBOM action
Generates an [interactive HTML BOM](https://github.com/openscopeproject/InteractiveHtmlBom/s) for the provided `.kicad_pcb` file

See [this list](https://github.com/stars/maartin0/lists/kicad-action-utils) for related actions

### Example
`.github/workflows/gen-ibom.yml`
```yml
name: Generate interactive HTML BOM for pull request

on:
  pull_request:
    types:
      - opened
    paths:
      - "**.kicad_pcb"

jobs:
  run:
    runs-on: ubuntu-latest

    permissions:
      contents: write
      pull-requests: read

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Checkout to latest PR commit
        env:
          PR: ${{ github.event.pull_request.url }}
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          git config --global --add safe.directory "$(pwd)"
          gh pr checkout "$(echo "$PR" | sed 's/.*\/pulls\///')"

      - name: Generate iBOM
        uses: maartin0/kicad-ibom-action@v1
        with:
          pcb: project_name.kicad_pcb
          output: "ibom.html"

      - name: Commit and push changes
        run: |
          git config --global user.name 'github-actions'
          git config --global user.email 'github-actions[bot]@users.noreply.github.com'
          git config --global --add safe.directory "$(pwd)"
          git add ibom.html
          git commit -m "Generate interactive HTML BOM"
          git push
```
