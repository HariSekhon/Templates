//  vim:ts=4:sts=4:sw=4:et
//
//  Author: Hari Sekhon
//  Date: 2024-09-25 13:57:27 +0100 (Wed, 25 Sep 2024)
//
//  https://github.com/HariSekhon
//
//  License: see accompanying Hari Sekhon LICENSE file
//
//  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
//
//  https://www.linkedin.com/in/HariSekhon
//

// ========================================================================== //
//                        F l y s c r a p e   C o n f i g
// ========================================================================== //

// Config Settings reference:
//
//      https://flyscrape.com/docs/configuration/starting-url

export const config = {

  // follows redirects eg. to https://news.ycombinator.com
  url: "https://hackernews.com",

  // Enable rendering with headless browser.             (default = false)
  //browser: true,

  // Specify if browser should be headless or not.       (default = true)
  //headless: false,

  // Specify the multiple URLs to start scraping from.   (default = [])
  // urls: [
  //     "https://anothersite.com/",
  //     "https://yetanother.com/",
  // ],

  // Specify how deep links should be followed.          (default = 0, no follow)
  // depth: 5,

  // Speficy the css selectors to follow.                (default = ["a[href]"])
  // follow: [".next > a", ".related a"],

  // Specify the allowed domains. ['*'] for all.         (default = domain from url)
  // allowedDomains: ["example.com", "anothersite.com"],

  // Specify the blocked domains.                        (default = none)
  // blockedDomains: ["somesite.com"],

  // Specify the allowed URLs as regex.                  (default = all allowed)
  // allowedURLs: ["/posts", "/articles/\d+"],

  // Specify the blocked URLs as regex.                  (default = none)
  // blockedURLs: ["/admin"],

  // Specify the rate in requests per minute.            (default = no rate limit)
  // rate: 60,

  // Specify the number of concurrent requests.          (default = no limit)
  // concurrency: 1,

  // Specify a single HTTP(S) proxy URL.                 (default = no proxy)
  // Note: Not compatible with browser mode.
  // proxy: "http://someproxy.com:8043",

  // Specify multiple HTTP(S) proxy URLs.                (default = no proxy)
  // Note: Not compatible with browser mode.
  // proxies: [
  //   "http://someproxy.com:8043",
  //   "http://someotherproxy.com:8043",
  // ],

  // XXX: use this in development mode to not have to repeatedly request the page
  // Enable file-based request caching.                  (default = no cache)
  // creates a <configfile_without_.js>.cache in the same directory
  cache: "file",

  // Specify the HTTP request header.                    (default = none)
  // headers: {
  //     "Authorization": "Bearer ...",
  //     "User-Agent": "Mozilla ...",
  // },

  // Use the cookie store of your local browser.         (default = off)
  // XXX: use this for sites that require being logged in
  // Options: "chrome" | "edge" | "firefox"
  // cookies: "chrome",

  // Specify the output options.
  // output: {
  //     // Specify the output file.                        (default = stdout)
  //     file: "results.json",
  //
  //     // Specify the output format.                      (default = json)
  //     // Options: "json" | "ndjson"
  //     format: "json",
  // },
};

// Reference for how to select HTML elements:
//
//      https://flyscrape.com/docs/api-reference/

export default function({ doc, absoluteURL }) {
  const title = doc.find("h1");
  //const link = doc.find("a");
  const posts = doc.find(".athing");

  return {
    title: title.text(),
	posts: posts.map((post) => {
        const link = post.find(".titleline > a");
        const meta = post.next();

        return {
          title: link.text(),
          url: absoluteURL(link.attr("href")),
          user: meta.find(".hnuser").text(),
        };
    }),
    //link: {
    //  text: link.text(),
    //  url: absoluteURL(link.attr("href")),
    //},
  };
}
