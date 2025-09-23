module.exports = function (eleventyConfig) {
    eleventyConfig.addPassthroughCopy('src/assets');
    eleventyConfig.addPassthroughCopy('src/.nojekyll');
    return { 
        dir: {
            input: "src",
            output: "docs"
        }
    }
}
