const markdownItKatex = require("@vscode/markdown-it-katex").default;
const markdownIt = require("markdown-it");

module.exports = function (eleventyConfig) {
    eleventyConfig.addPassthroughCopy('src/assets');
    eleventyConfig.addPassthroughCopy('src/.nojekyll');

    const md = markdownIt({
        html: true,
        linkify: true,
    }).use(markdownItKatex);

    eleventyConfig.setLibrary("md", md);

    return { 
        dir: {
            input: "src",
            output: "docs"
        }
    }
}
