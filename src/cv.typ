// CV, compiled to /CV.pdf after each Eleventy build (see eleventy.config.js).
//
// Sections marked "from _data" are generated from the JSON files in
// src/_data; edit those to change them. Everything else is written here.
// The fonts are in fonts/ at the repository root. To preview:
//   typst watch --font-path fonts --ignore-system-fonts src/cv.typ

#let publications = json("_data/publications.json")
#let invited-talks = json("_data/invitedTalks.json")
#let contributed-talks = json("_data/contributedTalks.json")
#let visits = json("_data/visits.json")
#let organization = json("_data/organization.json")
#let conferences = json("_data/conferences.json")

// Text from _data is evaluated as Typst markup, so "$K$-theory" gives math,
// ~ is a non-breaking space ("J.~Wang") and quotes are curled. Avoid other
// markup characters there (# @ * _ < `): the website shows the same strings
// as plain text (see the plain filter in eleventy.config.js).

// ---- Style -----------------------------------------------------------------

#let sans = "Cabin"
#let accent = rgb(146, 6, 50) // icons and bullets

#set document(title: "Matthew Dupraz – CV", author: "Matthew Dupraz")
#set page(paper: "a4", margin: (x: 2.25cm, y: 2.2cm), numbering: "1")
#set text(font: "Cochineal", size: 11pt, lang: "en", number-type: "old-style")
#set par(leading: 0.55em)
#set list(marker: text(fill: accent, size: 1.25em, baseline: 0.05em)[•], indent: 0.8em, spacing: 0.85em)

// As in LaTeX, math stays regular weight inside bold text. This needs bold
// to set an absolute weight (Typst's default adds to the current weight).
#show strong: it => text(weight: "bold", it.body)
#show math.equation: set text(weight: "regular")

// Cochineal joins "Th" into one glyph; LaTeX does not, so neither do we.
// (Only for these two letters: fi, ff, ffi stay ligatures.)
#show "Th": set text(ligatures: false)

// Monospace text (`...` in markup, raw(...) in code).
#show raw: set text(font: "Inconsolatazi4", size: 10.12pt)

// Section headings over a rule that fades out. The rule is the heading's
// bottom border, which is drawn behind the text, so descenders cross it.
#show heading.where(level: 1): set text(font: sans, size: 14.4pt)
#show heading.where(level: 1): set block(
  above: 19.25pt, below: 13.6pt, width: 100%, inset: (bottom: 3.3pt),
  stroke: (bottom: 2.6pt + gradient.linear(rgb(184, 206, 110), white)),
)

// ---- Helpers ---------------------------------------------------------------

// A Font Awesome icon in the accent color.
#let icon(glyph, solid: true) = text(
  font: if solid { "Font Awesome 5 Free Solid" } else { "Font Awesome 5 Free" },
  fill: accent, glyph,
)

// A dated entry: the date in a right-aligned column, the body on the right.
// It is kept on one page unless breakable is true.
#let entry(date, body, date-width: 2.6cm, breakable: false) = block(
  breakable: breakable, below: 0.75em,
  grid(columns: (date-width, 1fr), column-gutter: 1.2em, align(right, date), body),
)

// An entry whose date is just a year, with a narrower date column.
#let year-entry = entry.with(date-width: 2em)

#let months = ("jan", "feb", "mar", "apr", "may", "jun",
               "jul", "aug", "sep", "oct", "nov", "dec")

// Start of an entry's date ("Apr 20", "Feb-Mar", "May 4-8") in its year.
// Without a day ("Feb"), the first of the month.
#let start-date(e) = {
  let day = e.date.find(regex("\d+"))
  datetime(
    year: e.year,
    month: months.position(m => lower(e.date).starts-with(m)) + 1,
    day: if day == none { 1 } else { int(day) },
  )
}

// "Apr 20" + 2026 -> "Apr 20, 2026"; "Feb-Mar" + 2027 -> "Feb–Mar 2027".
// With month-only, "May 4-8" + 2026 -> "May 2026".
// Entries after the build day get a second line "(upcoming)".
#let cv-date(e, month-only: false) = {
  let date = if month-only { e.date.split(" ").first() } else { e.date }
  let sep = if date.ends-with(regex("\d")) { ", " } else { " " }
  let shown = date.replace("-", "–") + sep + str(e.year)
  if start-date(e) > datetime.today() [#shown \ (upcoming)] else [#shown]
}

// ", arXiv: 2508.20062" for arXiv links, ", <url>" for others, or nothing.
#let pub-link(p) = {
  if "url" not in p { return }
  if p.url.contains("arxiv.org/abs/") [, arXiv: #link(p.url, raw(p.url.split("/").last()))]
  else [, #link(p.url, raw(p.url))]
}

#let talk(t) = entry(cv-date(t))[
  #strong(eval(t.event, mode: "markup")), #emph(eval(t.university, mode: "markup")) \
  Title: #emph(eval(t.title, mode: "markup"))#if t.at("short", default: false) [ (short talk)]
]

// ---- Header ----------------------------------------------------------------

#grid(
  columns: (1fr, auto),
  stack(
    spacing: 0.75em,
    text(font: sans, weight: "bold", size: 20pt)[Matthew Dupraz],
    text(font: sans, style: "italic", fill: luma(128), size: 11.5pt)[Ph.D. student at FU Berlin],
  ),
  grid(
    columns: 2, column-gutter: 0.35em, row-gutter: 0.7em, align: (right, center),
    link("mailto:matthew.dupraz@fu-berlin.de", raw("matthew.dupraz@fu-berlin.de")),
    icon("\u{f0e0}", solid: false),
    raw("Arnimallee 3, 14195 Berlin"),
    icon("\u{f3c5}"),
    link("https://mattdupraz.github.io/", raw("https://mattdupraz.github.io/")),
    icon("\u{f0ac}"),
  ),
)

// ---- Education -------------------------------------------------------------

= Education

#entry[2024 -- Sep 2027 \ (expected)][
  *Ph.D. Mathematics*, _Freie Universität_, Berlin \
  DFG project _"$K$-theory and normal complexes"_
  (SPP 2458 _"Combinatorial Synergies"_) \
  Advisors: _Prof. Christian Haase and Dr. Leonid Monin (EPFL)_
]

#entry[2022 -- 2024][
  *M.Sc. Mathematics* (with minor in Computer Science), _EPFL_, Lausanne \
  Obtained the _EPFL Master Excellence Fellowship_ \
  Thesis: _Tropical linear systems and the realizability problem_,
  arXiv: #link("https://arxiv.org/abs/2506.21268")[`2506.21268`] \
  Advisor: _Prof. Francesca Carocci_
]

#entry[2019 -- 2022][
  *B.Sc. Mathematics*, _EPFL_, Lausanne
]

// ---- Publications (from _data/publications.json) ---------------------------

= Publications and Preprints

#for p in publications [
  - #strong(eval(p.title, mode: "markup")), with #eval(p.coauthors, mode: "markup"), #eval(p.status, mode: "markup")#pub-link(p).
]

// ---- Talks (from _data/invitedTalks.json, _data/contributedTalks.json) -----

= Invited Talks

#for t in invited-talks { talk(t) }

= Contributed Talks

#for t in contributed-talks { talk(t) }

// ---- Research visits (from _data/visits.json) ------------------------------

= Research Visits

#for v in visits {
  entry(cv-date(v))[
    #strong(eval(v.university, mode: "markup"))#if "city" in v [, #eval(v.city, mode: "markup")] \
    #eval(v.description, mode: "markup")#if "host" in v [, hosted by #emph(eval(v.host, mode: "markup"))]
  ]
}

// ---- Organization (from _data/organization.json) ---------------------------

= Organization

#for o in organization {
  entry(cv-date(o, month-only: true))[
    #strong(eval(o.event, mode: "markup")) \
    #if "role" in o [#eval(o.role, mode: "markup"), ]#emph(eval(o.university, mode: "markup"))#if "city" in o [, #eval(o.city, mode: "markup")]
    #if "details" in o [\ #eval(o.details, mode: "markup")]
  ]
}

// ---- Teaching --------------------------------------------------------------

= Teaching Experience

#entry[2024 -- present][
  *Coordinator*, _Lernzentrum, FU Berlin_ \
  Coordinate student tutors and hold weekly drop-in hours for undergraduate courses
]

#entry[2020 -- 2024][
  #set list(marker: text(size: 0.8em)[•], spacing: 0.55em)
  *Teaching assistant*, _EPFL_, Lausanne
  - 2023--24: _Rings and fields_; _Analysis IV_; _Algebraic structures_; _Probability_
  - 2021--22: _Advanced analysis II_; _Group theory_; _Metric and topological spaces_
  - 2020--21: _Classical mechanics_; _Information, Computation, Communication_;
    _Fluids and electromagnetism_; _Object-oriented programming_
]

// ---- Software --------------------------------------------------------------

= Software

#year-entry[2025][
  *Normal Complexes in Julia*,
  #link("https://github.com/MattDupraz/NormalComplexes.jl")[`github.com/MattDupraz/NormalComplexes.jl`] \
  Julia package for computing the volume, Ehrhart and Snapper polynomials of
  normal complexes of matroids, implementing a formula from the Frobenius
  quotients paper
]

#year-entry[][
  *Tropical Linear Systems on an Interval*,
  #link("https://github.com/MattDupraz/TLS_Interval")[`github.com/MattDupraz/TLS_Interval`] \
  Interactive web visualization of tropical linear systems of degree 2 on an interval
]

#year-entry[2024][
  *Tropical Linear Systems in Julia*,
  #link("https://github.com/MattDupraz/TropicalLinearSystems.jl")[`github.com/MattDupraz/TropicalLinearSystems.jl`] \
  Julia package for linear systems of divisors on tropical curves:
  chip-firing, extremals, realizability
]

// ---- Conferences (from _data/conferences.json; "cv": false entries skipped) -

= Attended Conferences and Workshops

#for group in conferences {
  let lines = group.events.filter(c => c.at("cv", default: true)).map(c => {
    let name = strong(eval(c.event, mode: "markup"))
    [#if "url" in c { link(c.url, name) } else { name }, #eval(c.city, mode: "markup")]
  })
  year-entry(str(group.year), lines.join(linebreak()), breakable: true)
}
