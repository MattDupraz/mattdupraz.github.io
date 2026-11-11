const { execFile } = require("node:child_process");
const path = require("node:path");
const { promisify } = require("node:util");
const markdownItKatex = require("@vscode/markdown-it-katex").default;
const markdownIt = require("markdown-it");

// Text from _data is written for the CV (Typst markup): dollar signs mark
// math ("$K$-theory") and ~ is a non-breaking space ("J.~Wang"). The website
// shows it as plain text: without the dollar signs, with real non-breaking
// spaces. As in Typst, \~ and \$ are a literal ~ and $.
function plain(value) {
    if (typeof value !== "string") return value;
    return value.replace(/\\([~$])|[~$]/g, (match, escaped) =>
        escaped ?? (match === "~" ? "\u00a0" : ""));
}

// Dates in _data are ISO: "2026-05-04", or "2027-02" for a whole month,
// represented by its first day (src/cv.typ parses the same format).
function parseDate(s) {
    const hasDay = s.length > 7;
    const date = hasDay
        ? Temporal.PlainDate.from(s)
        : Temporal.PlainYearMonth.from(s).toPlainDate({ day: 1 });
    return { date, hasDay };
}

// An event's "date" (one ISO date, or [start, end]) for the narrow date
// column: "May 4\u20138<br>2026", "Feb\u2013Mar<br>2027", or the full range when it
// spans two years ("Dec 30, 2026\u2013Jan 2, 2027").
function eventDate(value) {
    const [a, b = a] = [].concat(value);
    const start = parseDate(a), end = parseDate(b);
    const year = start.date.year;
    const sameYear = year === end.date.year;
    const format = new Intl.DateTimeFormat("en", {
        month: "short",
        ...(start.hasDay && { day: "numeric" }),
        ...(!sameYear && { year: "numeric" }),
    });
    // Intl puts thin spaces around the dash; the CV has none.
    const shown = format.formatRange(start.date, end.date).replace(/\s*\u2013\s*/, "\u2013");
    return sameYear ? `${shown}<br>${year}` : shown;
}

// The CV: src/cv.typ reads src/_data and is compiled to CV.pdf after each
// build, using only the fonts in fonts/ (plus Typst's built-in ones), so the
// result is the same everywhere. Set TYPST to use a typst binary that is not
// on the PATH.
const CV_SOURCE = "src/cv.typ";
const CV_FONTS = "fonts";
const TYPST = process.env.TYPST ?? "typst";

async function compileCv(outputDir) {
    const output = path.join(outputDir, "CV.pdf");
    try {
        await promisify(execFile)(TYPST, [
            "compile", "--font-path", CV_FONTS, "--ignore-system-fonts",
            CV_SOURCE, output,
        ]);
    } catch (err) {
        if (err.code === "ENOENT" && !process.env.CI) {
            console.warn(`[cv] Typst not found, skipping ${output} (install it from https://typst.app)`);
            return;
        }
        throw new Error(`Compiling the CV failed:\n${err.stderr || err.message}`, { cause: err });
    }
    console.log(`[cv] Wrote ${output}`);
}

module.exports = function (eleventyConfig) {
    eleventyConfig.addPassthroughCopy('src/assets');

    eleventyConfig.addFilter("plain", plain);
    eleventyConfig.addFilter("eventDate", eventDate);

    eleventyConfig.addWatchTarget(CV_SOURCE);
    eleventyConfig.addWatchTarget(CV_FONTS);
    eleventyConfig.on("eleventy.after", ({ dir }) => compileCv(dir.output));

    const md = markdownIt({
        html: true,
        linkify: true,
    }).use(markdownItKatex);

    eleventyConfig.setLibrary("md", md);

    return {
        dir: {
            input: "src",
            output: "_site"
        }
    }
}
